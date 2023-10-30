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
                  if (data.hasData) {
                    return ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        var documents = data.data?.docs[index];

                        return ListTile(
                          leading: Text(documents?['day'.toString()]),
                          title: Text(documents?['value'.toString()]),
                        );
                      },
                      itemCount: data.data?.docs.length,
                    );
                  } else {
                    // Return a placeholder widget or an error message widget.
                    return Center(
                      child:
                          CircularProgressIndicator(), // You can customize this message.
                    );
                  }
                  ;
                }));
      },
    );
  }
}
