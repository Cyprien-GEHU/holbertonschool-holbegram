import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
    final TextEditingController controller;
    final bool ispassword;
    final String hintText;
    final Widget? suffixIcon;
    final TextInputType keyboardType;

    const TextFieldInput({
        super.key,
        required this.controller,
        required this.ispassword,
        required this.hintText,
        this.suffixIcon,
        required this.keyboardType,
    });

    @override
    Widget build(BuildContext context) {
        return TextField(
            keyboardType: keyboardType,
            controller: controller,
            cursorColor: const Color.fromARGB(218, 226, 37, 24),
            textInputAction: TextInputAction.next,
            obscureText: ispassword,

            decoration: InputDecoration(
                hintText: hintText,
                filled: true,
                contentPadding: const EdgeInsets.all(8),
                suffixIcon: suffixIcon,
                border: const OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.transparent,
                        style: BorderStyle.none,
                    ),
                ),

                focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.transparent,
                    style: BorderStyle.none,
                    ),
                ),

                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.transparent,
                        style: BorderStyle.none,
                    ),
                ),
            )
        );
    }
}