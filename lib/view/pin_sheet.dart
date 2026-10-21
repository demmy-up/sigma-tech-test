import 'dart:math';

import 'package:flutter/material.dart';

class PinSheet extends StatefulWidget {
  const PinSheet({super.key});

  @override
  State<PinSheet> createState() => _PinSheetState();
}

class _PinSheetState extends State<PinSheet> {
  late final List<int> digits;

  String pin = '';

  @override
  void initState() {
    super.initState();
    _randomizeDigits();
  }

  _randomizeDigits() {
    digits = List.generate(10, (index) => index)..shuffle(Random.secure());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 24,
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.grey.shade600,
                  ),
                  margin: EdgeInsets.only(bottom: 24),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(6, (index) => index)
                      .map((index) => PinPlaceholder(
                    key: Key(index.toString()),
                            isFilled: pin.length > index,
                          ))
                      .toList(),
                ),
                SizedBox(height: 24),
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: digits
                          .map((digit) => PinItemView(
                              onTap: () {
                                if (pin.length == 6) return;
                                setState(() {
                                  pin = '$pin$digit';
                                });
                                print('pin $pin');
                              },
                              digit: digit))
                          .toList(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        ButtonPin(
                          iconData: Icons.backspace_outlined,
                          onTap: () {
                            pin = pin.substring(0, pin.length - 1);
                            setState(() {});
                          },
                        ),
                        ButtonPin(
                          iconData: Icons.check_circle_outlined,
                          onTap: () {
                            Navigator.of(context).pop(pin);
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          )),
    );
  }
}

class PinPlaceholder extends StatelessWidget {
  final bool isFilled;
  const PinPlaceholder({super.key, required this.isFilled});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      width: 24,
      margin: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
          color: isFilled ? Colors.green.shade600 : Colors.grey.shade600,
          borderRadius: BorderRadius.circular(32)),
    );
  }
}

class PinItemView extends StatelessWidget {
  final VoidCallback onTap;
  final int digit;
  const PinItemView({super.key, required this.onTap, required this.digit});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: MaterialButton(onPressed: onTap, child: Text(digit.toString())),
    );
  }
}

class ButtonPin extends StatelessWidget {
  final VoidCallback onTap;
  final IconData iconData;
  const ButtonPin({super.key, required this.onTap, required this.iconData});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      width: 100,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: MaterialButton(onPressed: onTap, child: Icon(iconData)),
    );
  }
}
