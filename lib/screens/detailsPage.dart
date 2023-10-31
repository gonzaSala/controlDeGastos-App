import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:control_gastos/login_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailsParams {
  final String categoryName;
  final int month;

  DetailsParams(this.categoryName, this.month);
}

class DetailsPage extends StatefulWidget {
  final DetailsParams params;
  const DetailsPage({super.key, required this.params});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
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
                        key: Key(documents!['uID']),
                        onDismissed: (direction) {
                          FirebaseFirestore.instance
                              .collection('user')
                              .doc(user?.uid)
                              .collection('expenses')
                              .doc(documents!['uID'])
                              .delete();
                        },
                        child: ListTile(
                          leading: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.calendar_today,
                                size: 40,
                              ),
                              Positioned(
                                  left: 0,
                                  right: 0,
                                  bottom: 8.5,
                                  child: Text(
                                    documents!['day'.toString()].toString(),
                                    textAlign: TextAlign.center,
                                  )),
                            ],
                          ),
                          title: Container(
                              decoration: BoxDecoration(
                                color: Colors.blueAccent.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  documents!['value'.toString()].toString(),
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18.0,
                                  ),
                                ),
                              )),
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
}
