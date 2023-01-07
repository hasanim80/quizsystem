import 'package:flutter/material.dart';

class Questions extends StatefulWidget {
  final String question;
  final String A;
  final String B;
  final String C;
  final String D;
  final void Function()? onpressed;
  final Function(String?)? onChanged;
  final String groupValue;

  const Questions(
      {Key? key,
      required this.question,
      required this.A,
      required this.B,
      required this.C,
      required this.D,
      required this.onpressed,
      required this.onChanged,
      required this.groupValue})
      : super(key: key);

  @override
  State<Questions> createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      color: Colors.grey,
      child: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          Container(
            padding: const EdgeInsets.symmetric( vertical: 8),
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 3),

            ),
            child: Text(
              widget.question,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.redAccent),
              textAlign: TextAlign.start,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          RadioListTile(
            title: Text(
              widget.A,
              style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 17,
                  fontWeight: FontWeight.bold),
            ),
            value: widget.A,
            groupValue: widget.groupValue,
            onChanged: widget.onChanged,
          ),
          RadioListTile(
            title: Text(
              widget.B,
              style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 17,
                  fontWeight: FontWeight.bold),
            ),
            value: widget.B,
            groupValue: widget.groupValue,
            onChanged: widget.onChanged,
          ),
          RadioListTile(
            title: Text(
              widget.C,
              style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 17,
                  fontWeight: FontWeight.bold),
            ),
            value: widget.C,
            groupValue: widget.groupValue,
            onChanged: widget.onChanged,
          ),
          RadioListTile(
            title: Text(
              widget.D,
              style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 17,
                  fontWeight: FontWeight.bold),
            ),
            value: widget.D,
            groupValue: widget.groupValue,
            onChanged: widget.onChanged,
          ),
          const SizedBox(
            height: 5,
          ),
          ElevatedButton(
            onPressed: widget.onpressed,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
            child: const Text('save',style: TextStyle(fontWeight: FontWeight.bold , color: Colors.black,fontSize: 18)),
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
