import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.autoFocus = false,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.controller,
    this.focusNode,
    this.readOnly = false,
    this.textInputType,
    this.textInputAction,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.labelText,
    this.hintText,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
    this.prefixIcon,
    this.suffixIcon,
  });

  final void Function()? onTap;
  final void Function(String value)? onChanged;
  final void Function(String value)? onSubmitted;
  final void Function()? onEditingComplete;
  final bool autoFocus;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool readOnly;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final String? labelText;
  final String? hintText;
  final EdgeInsetsGeometry? contentPadding;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  var isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (value) => setState(() => isFocused = value),
      child: TextField(
        controller: widget.controller,
        autofocus: widget.autoFocus,
        focusNode: widget.focusNode,
        readOnly: widget.readOnly,
        keyboardType: widget.textInputType,
        textInputAction: widget.textInputAction,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        maxLength: widget.maxLength,
        onTap: widget.onTap,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        onEditingComplete: widget.onEditingComplete,
        cursorColor: Theme.of(context).colorScheme.primary,
        decoration: InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
          hintStyle: const TextStyle(fontWeight: FontWeight.normal),
          contentPadding: widget.contentPadding,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          fillColor: isFocused
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.surfaceVariant.withAlpha(120),
          filled: true,
          prefixIcon: widget.prefixIcon,
          prefixIconColor: isFocused
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onBackground.withAlpha(200),
          suffixIcon: widget.suffixIcon,
          suffixIconColor: isFocused
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onBackground.withAlpha(200),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(16.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1.5),
            borderRadius: BorderRadius.circular(16.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
      ),
    );
  }
}
