import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:control_gastos/login_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailsParams {
  final String categoryName;
  final int month;
  final String details;

  DetailsParams(this.categoryName, this.month, this.details);
}

class DetailsPage extends StatefulWidget {
  final DetailsParams params;
  const DetailsPage({super.key, required this.params});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool lastItem = true;
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginState>(
      builder: (BuildContext context, LoginState state, Widget? child) {
        var user = Provider.of<LoginState>(context).currentUser();
        var _query = FirebaseFirestore.instance
            .collection('user')
            .doc(user?.uid)
            .collection('expenses')
            .where('month', isEqualTo: widget.params.month)
            .where('category', isEqualTo: widget.params.categoryName)
            .where('details', isEqualTo: widget.params.details)
            .snapshots();

        return Scaffold(
            appBar: AppBar(
              title: Text(widget.params.categoryName),
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream: _query,
              builder:
                  (BuildContext context, AsyncSnapshot<QuerySnapshot> data) {
                if (data.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (data.hasError) {
                  return Center(
                    child: Text('Error: ${data.error}'),
                  );
                } else if (!data.hasData || data.data!.docs.isEmpty) {
                  return Center(
                    child: Text('No hay datos para mostrar.'),
                  );
                } else {
                  return ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      var documents = data.data?.docs[index];
                      return Dismissible(
                        key: Key(documents!.id),
                        onDismissed: (direction) async {
                          await FirebaseFirestore.instance
                              .collection('user')
                              .doc(user?.uid)
                              .collection('expenses')
                              .doc(documents.id)
                              .delete();
                        },
                        confirmDismiss: (direction) async {
                          final result = await showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                  '¿Está seguro de que quiere eliminar el gasto de \$${documents!['value'.toString()].toString()}?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, false);
                                    },
                                    child: const Text(
                                      'Cancelar',
                                      style: TextStyle(color: Colors.redAccent),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context, true);
                                    },
                                    child: const Text('Sí, estoy seguro'),
                                  ),
                                ],
                              );
                            },
                          );

                          if (result == true) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Se eliminó el gasto: \$${documents!['value'.toString()].toString()}',
                                ),
                              ),
                            );
                          }

                          return result;
                        },
                        background: Container(
                          color: Color.fromARGB(255, 255, 144, 144),
                          child: const Icon(Icons.delete),
                          height: 5,
                        ),
                        direction: DismissDirection.endToStart,
                        child: ListTile(
                          leading: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.calendar_today,
                                size: 40,
                                color: Colors.blueGrey,
                              ),
                              Positioned(
                                left: 0,
                                right: 0,
                                bottom: 5.5,
                                child: Text(
                                  documents!['day'.toString()].toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.blueGrey),
                                ),
                              ),
                            ],
                          ),
                          title: Container(
                            decoration: BoxDecoration(
                              color: Colors.blueAccent.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        '\$${documents!['value'.toString()].toString()}',
                                        style: TextStyle(
                                          color: Colors.blueAccent,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 130,
                                      ),
                                      Icon(
                                        Icons.arrow_left,
                                        size: 32,
                                        color: Colors.blueGrey,
                                      ),
                                      Icon(
                                        Icons.delete,
                                        size: 32,
                                        color: Colors.blueGrey,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _showInfoDialog(
                                              context, widget.params.details);
                                        },
                                        child: Icon(
                                          Icons.info,
                                          size: 32,
                                          color: Colors.amber,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: data.data?.docs.length,
                  );
                }
              },
            ));
      },
    );
  }

  void _showInfoDialog(BuildContext context, String details) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Detalles del gasto'),
          content: Text(details),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}
