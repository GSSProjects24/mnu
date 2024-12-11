import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../main.dart';
import '../../theme/myfonts.dart';

class CustomFormField extends StatefulWidget {
  const CustomFormField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.obscureText,
    this.suffixIcon,
    this.viewIcon,
    this.validator,
    this.inputType,
    this.readOnly,
    this.maxlines,
    this.formatters,
    // this.onChanged
  }) : super(key: key);

  final TextEditingController? controller;
  final String labelText;
  final bool obscureText;
  final Widget? suffixIcon;
  final IconButton? viewIcon;
  final String? Function(String?)? validator;
  final TextInputType? inputType;
  final bool? readOnly;
  final int? maxlines;
  // final void Function(String)? onChanged;
  final List<TextInputFormatter>? formatters;

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  final FocusNode _focusNode = FocusNode(); // Create a custom focus node

  @override
  void dispose() {
    _focusNode.dispose(); // Dispose of the custom focus node
    super.dispose();
  }

  @override
  bool view = false;

  Widget build(BuildContext context) {
    //

    // view = widget.obscureText?true:false;

    return // Generated code for this yourName Widget...
        Padding(
      padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 16),
      child: TextFormField(
        focusNode: _focusNode,
        inputFormatters: widget.formatters ?? [],
        readOnly: widget.readOnly ?? false,
        keyboardType: widget.inputType,
        controller: widget.controller,
        validator: widget.validator,
        obscureText: view,
        decoration: InputDecoration(
          suffixIcon: widget.obscureText == false
              ? widget.suffixIcon
              : IconButton(
                  onPressed: () {
                    setState(() {
                      view = view ? false : true;
                    });
                  },
                  icon: view
                      ? Icon(Icons.visibility)
                      : Icon(Icons.visibility_off),
                ),
          labelText: widget.labelText,
          labelStyle: getText(context).bodyMedium?.copyWith(
                fontFamily: 'Outfit',
                color: Color(0xFF57636C),
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
          hintStyle: getText(context).bodyMedium?.copyWith(
                fontFamily: 'Outfit',
                color: Color(0xFF57636C),
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFFF1F4F8),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xFFF1F4F8),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: clrschm.onError,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: clrschm.onError,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsetsDirectional.fromSTEB(20, 24, 0, 24),
        ),
        style: getText(context).bodyLarge?.copyWith(
              fontFamily: 'Outfit',
              color: Color(0xFF101213),
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
        maxLines: widget.maxlines ?? 1,
      ),
    );
  }
}
