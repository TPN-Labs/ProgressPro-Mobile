import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progressp/utils/storage_utils.dart';

class CustomTextFormField extends StatelessWidget {
  final double? width;
  final String? labelText;
  final String hintText;
  final TextEditingController textEditingController;
  final Widget? sufix;
  final Widget? prefix;
  final bool obscure;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? limit;
  final TextCapitalization capitalization;
  final TextInputType? inputType;
  final bool? readOnly;

  const CustomTextFormField({
    Key? key,
    required this.hintText,
    required this.textEditingController,
    this.width,
    this.sufix,
    this.prefix,
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
        color: Theme.of(context).selectedRowColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            blurRadius: 2,
          ),
        ],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: TextFormField(
          controller: textEditingController,
          obscureText: obscure,
          focusNode: focusNode,
          textCapitalization: capitalization,
          keyboardType: inputType,
          readOnly: readOnly!,
          inputFormatters: limit,
          keyboardAppearance: isThemeDark() == true ? Brightness.dark : Brightness.light,
          decoration: InputDecoration(
            prefixIcon: prefix,
            suffixIcon: sufix,
            labelText: labelText,
            hintText: hintText,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
