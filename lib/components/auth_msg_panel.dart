import 'package:flutter/material.dart';

class AuthMsgPanel extends StatelessWidget {
  AuthMsgPanel({this.error, this.visible, super.key});
  String? error;
  bool? visible;

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: const BoxConstraints(minHeight: 50, maxHeight: 50),
        margin: const EdgeInsets.all(15),
        child: visible == true
            ? Text(error ?? '',
                maxLines: 5,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.error))
            : Container());
  }
}
