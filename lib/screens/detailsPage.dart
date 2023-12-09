import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:control_gastos/expenses_repository.dart';
import 'package:control_gastos/screens/ui/backgroundTheme.dart';
import 'package:control_gastos/states/login_state.dart';
import 'package:control_gastos/screens/ui/dayExpensesListTile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    documents.sort((a, b) => a['day'].compareTo(b['day']));
    return Scaffold(
        appBar: AppBar(
          title: Text(categoryName.toUpperCase()),
          backgroundColor: Color.fromARGB(55, 0, 0, 0),
          foregroundColor: Colors.white,
        ),
        body: BackgroundContainerObscure(
          child: ListView.builder(
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
                    color: Color.fromARGB(255, 250, 97, 97),
                    child: const Icon(Icons.delete),
                    height: 5,
                  ),
                  direction: DismissDirection.endToStart,
                  child:
                      new DayExpensesListTile(documents: document) // ListTile(

                  );
            },
          ),
        ));
  }
}
