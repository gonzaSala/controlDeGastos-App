import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DayExpensesListTile extends StatelessWidget {
  const DayExpensesListTile({Key? key, required this.documents});

  final DocumentSnapshot documents;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Icon(
            Icons.calendar_today,
            size: 40,
            color: Colors.blueGrey[300],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 5.5,
            child: Text(
              documents['day'].toString(),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.blueGrey[50]),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${documents['value'].toString()}',
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w500,
                  fontSize: 18.0,
                ),
              ),
              Row(
                children: [
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
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Detalles del gasto'),
                            content: Text(documents['details'] ?? ''),
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
                    },
                    child: Icon(
                      (documents['details'] == '')
                          ? null
                          : Icons.message_rounded,
                      size: 28,
                      color: (documents['details'] == '')
                          ? Colors.blueGrey
                          : Colors.blueGrey[300],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
