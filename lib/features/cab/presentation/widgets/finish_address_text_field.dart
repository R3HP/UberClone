import 'package:flutter/material.dart';



class FinishTextField extends StatelessWidget {
  final String? text;

  const FinishTextField({
    Key? key,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _finishAddressTextFielController = TextEditingController(text: text);
    final Size size = MediaQuery.of(context).size;
    return Positioned(
      bottom: size.height * 0.12,
      right: 2,
      left: 2,
      child: Container(
        decoration: BoxDecoration(boxShadow: const [
          BoxShadow(
              offset: Offset(2, 2),
              color: Colors.black38,
              blurRadius: 10.0,
              blurStyle: BlurStyle.outer),
        ], borderRadius: BorderRadius.circular(8.0), color: Colors.white),
        padding: const EdgeInsets.all(1.0),
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        child: TextField(
          controller: _finishAddressTextFielController,
          decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(5.0),
            hintText: 'Finish Address',
          ),
        ),
      ),
    );
  }
}