import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AuthButton extends StatelessWidget {
  AuthButton(
      {this.text,
      this.iconPath,
      this.alignment,
      this.iconData,
      this.onPressed,
      super.key});
  String? text;
  String? iconPath;
  IconData? iconData;
  Function? onPressed;
  Alignment? alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: alignment,
        margin: const EdgeInsets.all(10),
        child: Directionality(
            textDirection: TextDirection.rtl,
            child: ElevatedButton.icon(
                label: Text(text ?? ''),
                icon: Container(),
                onPressed: () {
                  onPressed?.call();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.w300, fontSize: 14),
                ))));
  }
}
