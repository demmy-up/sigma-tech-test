import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sigma_test/utils/currency_format.dart';
import 'package:sigma_test/view/pin_sheet.dart';
import 'package:sigma_test/view_model/transfer_view_model.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final _accountNumberController = TextEditingController();
  final _transferAmountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TransferViewModel(),
      child: Consumer<TransferViewModel>(builder: (_, viewModel, __) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Home'),
          ),
          body: ListView(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.green.shade600,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Saldo',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 4),
                    Text(
                      formatCurrency(viewModel.balance),
                      style:
                          TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.grey.shade300)),
                child: TextField(
                  controller: _accountNumberController,
                  onChanged: (String accountNumber) {
                    viewModel.accountNumber = accountNumber;
                  },
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  decoration: InputDecoration.collapsed(
                    hintText: 'No. Rekening',
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 24, top: 16),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.grey.shade300)),
                child: TextField(
                  controller: _transferAmountController,
                  onChanged: (String transferAmount) {
                    viewModel.transferAmount = parseAmount(transferAmount).toString();
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: [CurrencyInputFormatter()],
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  decoration: InputDecoration.collapsed(
                    hintText: 'Nominal',
                  ),
                ),
              ),
              MaterialButton(
                  height: 48,
                  disabledColor: Colors.grey.shade600,
                  color: Colors.blue.shade700,
                  onPressed: viewModel.isLocked
                      ? null
                      : !viewModel.isValid
                          ? null
                          : () async {
                              final pin = await showModalBottomSheet(
                                  context: context,
                                  builder: (_) {
                                    return PinSheet();
                                  });

                              if (pin is String && pin.length == 6) {
                                final result = await viewModel.transfer(context, pin);
                                if (result == true) {
                                  setState(() {
                                    _transferAmountController.text = '';
                                    _accountNumberController.text = '';
                                  });
                                }
                              }
                            },
                  child: viewModel.isLocked
                      ? SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white,
                          ))
                      : Text(
                          'Transfer',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ))
            ],
          ),
        );
      }),
    );
  }
}
