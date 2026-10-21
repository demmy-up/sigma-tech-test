import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sigma_test/utils/currency_format.dart';

class TransferViewModel extends ChangeNotifier {
  var balance = 5000000;

  bool _isLocked = false;
  bool get isLocked => _isLocked;
  set isLocked(bool newValue) {
    _isLocked = newValue;
    notifyListeners();
  }

  String _accountNumber = '';
  String get accountNumber => _accountNumber;
  set accountNumber(String newValue) {
    _accountNumber = newValue;
    notifyListeners();
  }

  String _transferAmount = '';
  String get transferAmount => _transferAmount;
  set transferAmount(String newValue) {
    _transferAmount = newValue;
    notifyListeners();
  }

  int get amount => int.tryParse(transferAmount) ?? 0;

  bool get isValid {
    return accountNumber.isNotEmpty && amount > 0 && amount < balance;
  }

  Future<bool> transfer(BuildContext context, String pin) async {
    if (isLocked || !isValid) return false;

    if (pin.length != 6 || pin != '123456') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Pin tidak sesuai')));
      return false;
    }

    isLocked = true;

    // simulate 3s api call
    await Future.delayed(Duration(seconds: 3));

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text('Selamat, Transfer ${formatCurrency(amount)} ke nomer rekening $accountNumber berhasil!')));

    balance = balance - amount;
    _transferAmount = '';
    _accountNumber = '';
    _isLocked = false;
    notifyListeners();
    return true;
  }
}
