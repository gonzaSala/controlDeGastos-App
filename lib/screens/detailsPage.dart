import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:control_gastos/expenses_repository.dart';
import 'package:control_gastos/states/login_state.dart';
import 'package:control_gastos/screens/ui/dayExpensesListTile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailsParams {
  final String categoryName;
  final int month;

  DetailsParams(
    this.categoryName,
    this.month,
  );
}

class DetailsPageConteiner extends StatefulWidget {
  final DetailsParams params;
  const DetailsPageConteiner({Key? key, required this.params})
      : super(key: key);

  @override
  State<DetailsPageConteiner> createState() => _DetailsPageConteinerState();
}

class _DetailsPageConteinerState extends State<DetailsPageConteiner> {
  bool lastItem = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<expensesRepository>(
      builder: (BuildContext context, expensesRepository db, Widget? child) {
        var _query =
            db.queryByCategory(widget.params.month, widget.params.categoryName);

        return StreamBuilder<QuerySnapshot>(
          stream: _query,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> data) {
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
              return DetailsPage(
                categoryName: widget.params.categoryName,
                documents: data.data!.docs,
                OnDelete: (documentId) {
                  db.delete(documentId);
                },
                details: data.data?.docs[0]['details'],
              );
            }
          },
        );
      },
    );
  }
}

class DetailsPage extends StatelessWidget {
  final String categoryName;
  final List<DocumentSnapshot> documents;
  final Function(String) OnDelete;
  final String details;

  const DetailsPage({
    Key? key,
    required this.categoryName,
    required this.documents,
    required this.OnDelete,
    required this.details,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
      ),
      body: ListView.builder(
        itemCount: documents.length,
        itemBuilder: (BuildContext context, int index) {
          var document = documents[index];

          return Dismissible(
              key: Key(document.id),
              onDismissed: (direction) async {
                OnDelete(document.id);
              },
              confirmDismiss: (direction) async {
                final result = await showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        '¿Está seguro de que quiere eliminar el gasto de \$${document['value'].toString()}?',
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
                        'Se eliminó el gasto: \$${document['value'].toString()}',
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
              child: new DayExpensesListTile(documents: document) // ListTile(

              );
        },
      ),
    );
  }
}
