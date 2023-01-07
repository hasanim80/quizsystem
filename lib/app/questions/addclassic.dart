import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../components/crud.dart';
import '../../components/customtextform.dart';
import '../../components/valid.dart';
import '../../constant/linkapi.dart';
import '../../main.dart';

class AddClassic extends StatefulWidget {
  const AddClassic({Key? key}) : super(key: key);

  @override
  State<AddClassic> createState() => _AddClassicState();
}

class _AddClassicState extends State<AddClassic> with Crud {
  TextEditingController questionController = TextEditingController();
  TextEditingController answer = TextEditingController();
  String getUser() {
    var user = FirebaseAuth.instance.currentUser;
    useremail = user!.email!;
    return useremail;
  }

  late int teacherid;

  Future getTeacherId() async {
    var response = await postRequest(
        linkTeacherIdForQuestions, {"useremail": useremail.toString()});

    setState(() {
      teacherid = response['data'][0]['id'];
      if (kDebugMode) {
        print(teacherid);
      }
    });

    return response;
  }
  addClassicQuestion() async {
    if (questionController.text.isNotEmpty && answer.text.isNotEmpty) {
      //isLoading = true;
      setState(() {

      });
      await getTeacherId();
      var response = await postRequest(linkAddClassicQuestion, {
        "question": questionController.text,
        "answer": answer.text,
        "userid": "1".toString(),
      });
      //isLoading = false;
      setState(() {});

      if (response['status'] == "success") {
        //success//
        AwesomeDialog(
            context: context,
            btnOkOnPress: () {
              questionController.clear();
              answer.clear();
              Navigator.of(context).pushReplacementNamed('addclassic');
            },
            title: "Attention",
            body: const Text(
              "Question successfully added",
              style: TextStyle(color: Color.fromARGB(255, 245, 3, 3)),
            )).show();
        //Navigator.pop(context);
      }
    } else {
      AwesomeDialog(
          context: context,
          btnOkOnPress: () {},
          title: "Attention",
          body: const Text(
            "All feild should be fulled",
            style: TextStyle(color: Color.fromARGB(255, 245, 3, 3)),
          )).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text('Add Classic Questions'),
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              CustomTextFormSign(
                  onChanged: (text) {
                    if (kDebugMode) {
                      //print(text);
                    }
                  },
                  valid: (val) {
                    //return validInput(val!, 11, 40);
                  },
                  obscureText: false,
                  keyboardType: TextInputType.emailAddress,
                  icon2: IconButton(
                      onPressed: () {
                        questionController.clear();
                      },
                      icon: const Icon(Icons.close)),
                  //Icons.abc,
                  icon: const IconButton(
                      onPressed: null, icon: Icon(Icons.question_mark)),
                  mycontroller: questionController,
                  height: 40,
                  hint: "Add Question"),
              CustomTextFormSign(
                  onChanged: (text) {},
                  valid: (val) {
                    //return validInput(val!, 11, 40);
                  },
                  obscureText: false,
                  keyboardType: TextInputType.emailAddress,
                  icon2: IconButton(
                      onPressed: () {
                        answer.clear();
                      },
                      icon: const Icon(Icons.close)),
                  //Icons.abc,
                  icon: const IconButton(
                      onPressed: null, icon: Icon(Icons.question_answer)),
                  mycontroller: answer,
                  height: 40,
                  hint: "Answer"),
              ElevatedButton(
                onPressed: () async{
                  setState(() {
                    getUser();
                  });
                  await addClassicQuestion();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigoAccent),
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 20),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
