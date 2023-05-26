import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:taskoo/utils/app_colors.dart';

class DottedPopUpButton extends StatefulWidget {
  //Var created to validate if inputText isNotEmpty
  final bool inputTextIsNotEmpty;
  //If inputTextIsNotEmpty == false - DottedPopUpButton show textButton instead Icons.add
  final String textButton;
  final Icon icon;
  final VoidCallback onPress;

  const DottedPopUpButton(
      {Key? key,
      required this.inputTextIsNotEmpty,
      required this.textButton,
      required this.icon,
      required this.onPress})
      : super(key: key);

  @override
  State<DottedPopUpButton> createState() => _DottedPopUpButtonState();
}

class _DottedPopUpButtonState extends State<DottedPopUpButton> {
  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: const Radius.circular(10),
      padding: const EdgeInsets.all(0),
      child: Container(
        height: 40,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: widget.onPress,
            child: widget.inputTextIsNotEmpty
                ? widget.icon
                : Text(widget.textButton)),
      ),
    );
  }
}
