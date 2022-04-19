import 'package:flutter/material.dart';

class AuthFormTextFormField extends StatelessWidget {
  const AuthFormTextFormField(
      {Key? key,
      required TextEditingController textController,
      required this.label})
      : _textController = textController,
        super(key: key);

  final TextEditingController _textController;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _textController,
      validator: ((value) {
        if (value!.isEmpty || value.length < 8) {
          return '$label must at least be 8 characters';
        }
        if (label == 'Email') {
          if (!value.contains('@')) {
            return '$label not valid. @ is missed';
          }
        }
        return null;
      }),
      obscureText: label == 'Password',
      textInputAction:
          label == 'Password' ? TextInputAction.done : TextInputAction.next,
      decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          filled: true,
          fillColor: Colors.white),
    );
  }
}
