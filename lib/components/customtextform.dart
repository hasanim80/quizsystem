import 'package:flutter/material.dart';


class CustomTextFormSign extends StatelessWidget {
  final String hint;
  final double height;
  final String? Function(String?) valid;
  final TextEditingController mycontroller;
  final IconButton icon;
  final IconButton icon2;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Function(String?) onChanged;

  const CustomTextFormSign({
    Key? key,
    required this.hint,
    required this.height,
    required this.mycontroller,
    required this.valid,
    required this.onChanged,
    required this.icon,
    required this.icon2,
    this.keyboardType,
    required this.obscureText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: const EdgeInsets.only(bottom: 15),
      child: SizedBox(
        width: 350,
        child: TextFormField(
          onChanged: onChanged,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: valid,
          controller: mycontroller,
          decoration: InputDecoration(
              labelText: hint,
              contentPadding: const EdgeInsets.all(8),
              prefixIcon: icon,
              suffixIcon: icon2,
              hintText: hint,
              hintMaxLines: 20,
              border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black87, width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(10)))),
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
