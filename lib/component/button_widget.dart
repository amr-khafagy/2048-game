import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game/const/colors.dart';

class ButtonWidget extends ConsumerWidget {
  final String? text;
  final IconData? icon;
  final VoidCallback onPressed;

  ButtonWidget({super.key, this.text, this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (icon != null) {
      return Container(
        decoration: BoxDecoration(
            color: scoreColor, borderRadius: BorderRadius.circular(8)),
        child: IconButton(
            onPressed: onPressed,
            color: textColorWhite,
            icon: Icon(
              icon,
              size: 24.0,
            )),
      );
    }
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        text!,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
      ),
      style: ButtonStyle(
          padding:
              MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(16.0)),
          backgroundColor: MaterialStateProperty.all<Color>(buttonColor)),
    );
  }
}
