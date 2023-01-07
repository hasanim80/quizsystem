import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizsystem/teacher_or_student_dropdown/teacher_or_student.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/auth/login.dart';
import 'app/auth/signup.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app/home.dart';
import 'app/questions/add.dart';
import 'app/questions/addclassic.dart';
import 'app/questions/questiontype.dart';
import 'components/test.dart';
import 'components/test2.dart';
late SharedPreferences sharedPref;
late bool islogin;
late String usertype;
late String useremail;
late bool isFloatingActionVisible;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  sharedPref = await SharedPreferences
      .getInstance(); // API shared preferance

  var user = FirebaseAuth.instance.currentUser;
  if(user == null){
    islogin = false;
  }
  else{
    islogin = true;
  }
  /*sharedPref = await SharedPreferences
      .getInstance(); */// to access shared preferences from any where in app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'course PHP Rest API',
      initialRoute:  islogin == false ? "login": "home",
      //initialRoute:  "test2",
      routes: {
        "login": (context) => const Login(),
        "signup": (context) => const SignUp(),
        "home": (context) => const Home(),
        "add": (context) => const Add(),
        "addclassic" : (context) => const AddClassic(),
        "questiontype": (context) => const QuestionType(),
        "test": (context) => const Test(),
        "test2": (context) =>  const MyDropDown(),
        "dropdown1": (context) =>  DropDown(),
        //"success": (context) => Success(),
        //"addnotes": (context) => AddNotes(),
        //"editnotes": (context) => EditNotes()
      },
    );
  }
}
