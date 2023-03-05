import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progressp/utils/storage_utils.dart';

class CustomSearchField extends StatelessWidget {
  final double? width;
  final String? labelText;
  final String hintText;
  final Color color;
  final TextEditingController controller;
  final Function(String) onChanged;
  final bool obscure;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? limit;
  final TextCapitalization capitalization;
  final TextInputType? inputType;
  final bool? readOnly;

  const CustomSearchField({
    Key? key,
    required this.color,
    required this.hintText,
    required this.controller,
    required this.onChanged,
    this.width,
    this.obscure = false,
    this.limit,
    this.labelText,
    required this.capitalization,
    this.inputType,
    this.readOnly = false,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 56,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        autocorrect: false,
        autofocus: false,
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.only(
              top: 12.0,
              left: 15.0,
              bottom: 5.0,
              right: 15.0,
            ),
            child: Icon(
              Icons.search,
              color: Theme.of(context).shadowColor,
              size: 32,
            ),
          ),
          contentPadding: const EdgeInsets.only(top: 15),
          isDense: true,
          border: InputBorder.none,
          hintText: hintText,
          labelText: labelText,
          hintStyle: const TextStyle(color: Colors.grey),
        ),
        focusNode: focusNode,
        inputFormatters: limit,
        keyboardAppearance: isThemeDark() == true ? Brightness.dark : Brightness.light,
        keyboardType: inputType,
        maxLines: 1,
        obscureText: obscure,
        onChanged: onChanged,
        readOnly: readOnly!,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Theme.of(context).textTheme.headline6!.color, fontFamily: 'Manrope'),
        textAlign: TextAlign.left,
      ),
    );
  }
}
