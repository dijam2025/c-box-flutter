import 'package:flutter/foundation.dart';

class RentalStatusProvider extends ChangeNotifier {
  List<Map<String, dynamic>> myRentals = [];

  void addRental(Map<String, dynamic> rental) {
    myRentals.add(rental);
    notifyListeners();
  }

  void removeRental(int index) {
    myRentals.removeAt(index);
    notifyListeners();
  }
}
