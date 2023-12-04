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
            color: Color.fromARGB(141, 49, 49, 49),
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(
                color: Color.fromARGB(78, 255, 255, 255),
                strokeAlign: BorderSide.strokeAlignOutside)),
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
                    color: const Color.fromARGB(255, 146, 196, 221),
                  ),
                  Icon(
                    Icons.delete,
                    size: 32,
                    color: Color.fromARGB(118, 146, 196, 221),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            elevation: 8,
                            shape: BeveledRectangleBorder(
                              side: BorderSide(
                                  color:
                                      const Color.fromARGB(125, 255, 255, 255),
                                  width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.elliptical(8, 5)),
                            ),
                            shadowColor:
                                const Color.fromARGB(255, 255, 255, 255),
                            alignment: Alignment.center,
                            title: Text('Detalles del gasto'),
                            backgroundColor: Color.fromARGB(255, 239, 224, 255),
                            content: Text('${documents['details'] ?? ''}'),
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
