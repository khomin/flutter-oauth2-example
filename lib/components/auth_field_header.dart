import 'package:flutter/material.dart';

class AuthFieldHeader extends StatelessWidget {
  AuthFieldHeader({this.header, super.key});
  String? header;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(5),
        child: Text(header ?? '',
            style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 14,
                color: Theme.of(context).colorScheme.tertiary)));
  }
}
