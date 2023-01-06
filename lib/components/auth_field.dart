import 'package:flutter/material.dart';
import 'package:oauth2_flutter_example/const_values.dart';

class AuthField extends StatelessWidget {
  AuthField({this.hint, this.visible, this.onDone, this.onChanged, super.key});
  String? hint;
  bool? visible;
  Function? onDone;
  Function? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding:
            const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
        constraints: const BoxConstraints(maxWidth: ConstValues.inputMaxWidth),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: TextField(
            autofocus: true,
            onChanged: (value) {
              onChanged?.call(value);
            },
            onEditingComplete: () {
              onDone?.call();
            },
            style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontSize: 15),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary, fontSize: 15),
              contentPadding: const EdgeInsets.all(12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                    width: 2, color: Theme.of(context).colorScheme.primary),
              ),
            )));
  }
}
