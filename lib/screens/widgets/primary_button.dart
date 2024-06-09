import 'package:flutter/material.dart';

// import '../../constants/colors.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
      {super.key,
      required this.text,
      required this.onPressed,
      this.isDisabled = false,
      required this.color});
  final String text;
  final VoidCallback onPressed;
  final bool isDisabled;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        // disabledBackgroundColor: paragraphColor,
        disabledForegroundColor:
            color ?? const Color.fromARGB(255, 124, 94, 94),
        backgroundColor: color ?? const Color.fromARGB(255, 206, 152, 151),
        minimumSize: const Size.fromHeight(55),
        side: const BorderSide(color: Colors.black),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: isDisabled ? null : onPressed,
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
    );
  }
}
