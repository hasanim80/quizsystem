import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';



class DropDown extends StatelessWidget {
  final List<String> position = [
    'Teacher',
    'Student',
  ];
  final _formKey = GlobalKey<FormState>();
  String? selectedValue;
  final TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();

  }
   DropDown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 19),
          child: DropdownButtonFormField2(
            decoration: InputDecoration(
              //Add isDense true and zero Padding.
              //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              //Add more decoration as you want here
              //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
            ),
            isExpanded: true,
            hint: const Text(
              'Select Your Position',
              style: TextStyle(fontSize: 15),
            ),
            icon: const Icon(
              Icons.arrow_drop_down,
              color: Colors.black,
            ),
            iconSize: 30,
            buttonHeight: 60,
            buttonPadding: const EdgeInsets.only(left: 20, right: 10),
            dropdownDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            items: position
                .map((item) => DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ))
                .toList(),
            validator: (value) {
              if (value == null) {
                return 'Please Select Your Position.';
              }
            },
            onChanged: (value) {
              //Do something when changing the item if you want.
              print(value);
            },
            onSaved: (value) {
              selectedValue = value.toString();
            },
          ),
        ),
      ),
    );
  }
}
