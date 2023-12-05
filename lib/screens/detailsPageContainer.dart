import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:control_gastos/screens/detailsPage.dart';
import 'package:control_gastos/screens/homePage.dart';
import 'package:flutter/material.dart';
import 'package:control_gastos/expenses_repository.dart';

import 'package:provider/provider.dart';

class DetailsParams {
  final String categoryName;
  final int month;

  DetailsParams(this.categoryName, this.month);
}

class DetailsPageContainer extends StatelessWidget {
  final DetailsParams params;

  const DetailsPageContainer({Key? key, required this.params})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('DetailsPageContainer - Building widget');
    print(
        'DetailsPageContainer - Params: ${params.categoryName}, ${params.month}');
    return Consumer<expensesRepository>(
      builder: (BuildContext context, expensesRepository db, Widget? child) {
        var _query = db.queryByCategory(params.month, params.categoryName);

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
                child: HomePage(),
              );
            } else {
              return DetailsPage(
                categoryName: params.categoryName,
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
