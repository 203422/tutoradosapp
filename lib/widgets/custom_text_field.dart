import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? hint;
  final String? label;
  final bool isObscureText;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final String? errorMessage;
  final Function()? onTap;
  final String? initialValue;
  final TextEditingController? controller;
  final bool readOnly;
  final bool enabled;
  final TextInputType keyboardType;
  final bool isFormStudent;

  const CustomTextField(
      {super.key,
      this.hint,
      this.label,
      this.isObscureText = false,
      this.onChanged,
      this.onFieldSubmitted,
      this.errorMessage,
      this.onTap,
      this.initialValue,
      this.controller,
      this.readOnly = false,
      this.enabled = true,
      this.keyboardType = TextInputType.text,
      this.isFormStudent = false});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: isFormStudent
            ? Color(colors.tertiaryContainer.value)
            : Color(colors.secondaryContainer.value),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, bottom: 5),
        child: TextFormField(
          enabled: enabled,
          onChanged: onChanged,
          obscureText: isObscureText,
          onFieldSubmitted: onFieldSubmitted,
          initialValue: initialValue,
          controller: controller,
          keyboardType: keyboardType,
          onTap: onTap,
          readOnly: readOnly,
          style: TextStyle(
              color: isFormStudent
                  ? Color(colors.onTertiaryContainer.value)
                  : Color(colors.onSecondaryContainer.value),
              fontSize: 16,
              fontWeight: FontWeight.normal),
          cursorColor: isFormStudent
              ? Color(colors.secondary.value)
              : Color(colors.primary.value),
          decoration: InputDecoration(
            floatingLabelStyle: TextStyle(
              color: isFormStudent
                  ? Color(colors.onTertiaryContainer.value)
                  : Color(colors.onSecondaryContainer.value),
            ),
            border: InputBorder.none,
            hintText: hint,
            label: label != null ? Text(label!) : null,
            errorText: errorMessage,
          ),
        ),
      ),
    );
  }
}
