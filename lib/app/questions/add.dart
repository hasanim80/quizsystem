import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quizsystem/main.dart';
import '../../components/crud.dart';
import '../../components/customtextform.dart';
import '../../components/valid.dart';
import '../../constant/linkapi.dart';

class Add extends StatefulWidget {
  const Add({Key? key}) : super(key: key);

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> with Crud {
  GlobalKey<FormState> formstate = GlobalKey(); // for validator
  TextEditingController questionController = TextEditingController();
  TextEditingController A = TextEditingController();
  TextEditingController B = TextEditingController();
  TextEditingController C = TextEditingController();
  TextEditingController D = TextEditingController();

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

  addTestQuestion() async {
    if (questionController.text.isNotEmpty &&
        A.text.isNotEmpty &&
        B.text.isNotEmpty &&
        C.text.isNotEmpty &&
        D.text.isNotEmpty) {
      //isLoading = true;

        await getTeacherId();


      var response = await postRequest(linkAddTestQuestion, {
        "question": questionController.text,
        "A": A.text,
        "B": B.text,
        "C": C.text,
        "D": D.text,
        "userid": teacherid.toString(),
      });
      //isLoading = false;
      setState(() {});

      if (response['status'] == "success") {
        //success//
        AwesomeDialog(
            context: context,
            btnOkOnPress: () {
              questionController.clear();
              A.clear();
              B.clear();
              C.clear();
              D.clear();
              Navigator.of(context).pushReplacementNamed('add');
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
            "All feild should be filled",
            style: TextStyle(color: Color.fromARGB(255, 245, 3, 3)),
          )).show();
    }
  }

  /*late int teacherid;
  Future getTeacherId() async {
    setState(() {});
    var response = await postRequest(linkTeacherId,
        {"displaynameforid": useremail.toString()});

    setState(() {
      teacherid = response['data'][0]['id'];
      if (kDebugMode) {
        print(teacherid);
      }

    });

    return response;
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text('Add Test Questions'),
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
                    return validInputSign(val!, "Question", 2, 250);
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
                    return validInputSign(val!, "A", 5, 250);
                  },
                  obscureText: false,
                  keyboardType: TextInputType.emailAddress,
                  icon2: IconButton(
                      onPressed: () {
                        A.clear();
                      },
                      icon: const Icon(Icons.close)),
                  //Icons.abc,
                  icon: const IconButton(
                      onPressed: null, icon: Icon(Icons.question_answer)),
                  mycontroller: A,
                  height: 40,
                  hint: "Answer A"),
              CustomTextFormSign(
                  onChanged: (text) {},
                  valid: (val) {
                    return validInputSign(val!, "B", 5, 250);
                  },
                  obscureText: false,
                  keyboardType: TextInputType.emailAddress,
                  icon2: IconButton(
                      onPressed: () {
                        B.clear();
                      },
                      icon: const Icon(Icons.close)),
                  //Icons.abc,
                  icon: const IconButton(
                      onPressed: null, icon: Icon(Icons.question_answer)),
                  mycontroller: B,
                  height: 40,
                  hint: "Answer B"),
              CustomTextFormSign(
                  onChanged: (text) {},
                  valid: (val) {
                    return validInputSign(val!, "C", 5, 250);
                  },
                  obscureText: false,
                  keyboardType: TextInputType.emailAddress,
                  icon2: IconButton(
                      onPressed: () {
                        C.clear();
                      },
                      icon: const Icon(Icons.close)),
                  //Icons.abc,
                  icon: const IconButton(
                      onPressed: null, icon: Icon(Icons.question_answer)),
                  mycontroller: C,
                  height: 40,
                  hint: "Answer C"),
              CustomTextFormSign(
                  onChanged: (text) {},
                  valid: (val) {
                    return validInputSign(val!, "D", 5, 250);
                  },
                  obscureText: false,
                  keyboardType: TextInputType.emailAddress,
                  icon2: IconButton(
                      onPressed: () {
                        D.clear();
                      },
                      icon: const Icon(Icons.close)),
                  //Icons.abc,
                  icon: const IconButton(
                      onPressed: null, icon: Icon(Icons.question_answer)),
                  mycontroller: D,
                  height: 40,
                  hint: "Answer D"),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    getUser();
                  });
                  await addTestQuestion();
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
