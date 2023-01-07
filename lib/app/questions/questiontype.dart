import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../components/customtextform.dart';
import '../../components/valid.dart';

class QuestionType extends StatefulWidget {
  const QuestionType({Key? key}) : super(key: key);

  @override
  State<QuestionType> createState() => _QuestionTypeState();
}

class _QuestionTypeState extends State<QuestionType> {
  TextEditingController questionController = TextEditingController();
  TextEditingController A = TextEditingController();
  TextEditingController B = TextEditingController();
  TextEditingController C = TextEditingController();
  TextEditingController D = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text('Question Type'),
        actions: [],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),

            InkWell(
              onLongPress: () { null;},
              onTap: (){
                Navigator.of(context).pushNamed('add');
              },
              child: Container(
                width: double.infinity,
                height: 100,
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(30),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.amber,
                    gradient: const RadialGradient(
                        colors: [Colors.indigo, Colors.grey, Colors.amber],
                        center: Alignment.center,
                        radius: 5),
                    border: Border.all(
                        color: Colors.grey, width: 3.0, style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(20.0)),
                child: const Text(
                  "Add Test Question",
                  style: TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w500, color: Colors.black),
                ),
              ),
            ),
            InkWell(
              onLongPress: () { null;},
              onTap: (){
                Navigator.of(context).pushNamed('addclassic');
              },
              child: Container(
                width: double.infinity,
                height: 100,
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(30),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.amber,
                    gradient: const RadialGradient(
                        colors: [Colors.indigo, Colors.grey, Colors.amber],
                        center: Alignment.center,
                        radius: 5),
                    border: Border.all(
                        color: Colors.grey, width: 3.0, style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(20.0)),
                child: const Text(
                  "Add Classic Question",
                  style: TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w500, color: Colors.black),
                ),
              ),
            ),
            /*ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent),
              child: const Text(
                'Save',
                style: TextStyle(fontSize: 20),
              ),
            )*/
          ],
        ),
      ),
    );
  }
}
