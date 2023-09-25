import 'package:control_gastos/models/expenses_item.dart';

class expenseData {
  List<expenseItem> overAllExpenseList = [];

  List<expenseItem> getAllExpenseList (){
    return overAllExpenseList;
  };

  void addNewExpense(expenseItem newExpense){
    overAllExpenseList.add(newExpense);
  }

  void deleteExpense (expenseItem expense){
    overAllExpenseList.remove(expense);
  }

  String getDayName (DateTime dateTime){
    switch (dateTime.weekday){
      case 1:
      return 'Dom';
      case 2:
      return 'Lun';
      case 3:
      return 'Mar';
      case 4:
      return 'Mier';
      case 5:
      return 'Jue';
      case 6:
      return 'Vie';
case 7:
      return 'Sab';
    }
  }

}
