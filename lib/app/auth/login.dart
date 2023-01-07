import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quizsystem/components/crud.dart';
import 'package:quizsystem/components/customtextform.dart';
import 'package:quizsystem/components/valid.dart';
import 'package:quizsystem/constant/linkapi.dart';
import 'package:quizsystem/main.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with Crud {
  Crud crud = Crud();
  late UserCredential userCredential;
  String? message2;
  GlobalKey<FormState> formstate = GlobalKey();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obs = false;



  String getUser() {
    var user = FirebaseAuth.instance.currentUser;
    useremail = user!.email!;
    return useremail;
  }

  Future getUserTypeForTeacher() async {
    setState(() {
      getUser();
    });
    var response = await postRequest(
        linkTeacherUserType, {"emailforusertype": useremail.toString()});

    setState(() {
      usertype = response['data'][0]['user_type'];
      if (kDebugMode) {
        //print(usertype);

      }
    });
    return response;
  }

  void Show(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          "Warning",
          style: TextStyle(color: Colors.red),
        ),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              if (message2 == 'Logged in successfully.') {
                Navigator.of(context).pushReplacementNamed("home");
              } else if (message2 == 'No user found for that email.') {
                Navigator.of(ctx).pop();
              } else if (message2 == 'Wrong password provided for that user.') {
                Navigator.of(ctx).pop();
              } else if (message2 == 'The email or password cannot be empty') {
                Navigator.of(ctx).pop();
              }
              //Navigator.of(ctx).pop();
            },
            child: Container(
              color: Colors.blue,
              padding: const EdgeInsets.all(14),
              child: const Text(
                "Ok",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      message2 = 'The email or password cannot be empty';
      Show('The email or password cannot be empty');
    } else {
      try {
        userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);

        message2 = 'Logged in successfully.';
        Show('Logged in successfully.');
        if (kDebugMode) {
          print(message2);
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          message2 = 'No user found for that email.';
          Show('No user found for that email.');
          if (kDebugMode) {
            print('No user found for that email.');
          }
        } else if (e.code == 'wrong-password') {
          message2 = 'Wrong password provided for that user.';
          Show('Wrong password provided for that user.');
          if (kDebugMode) {
            print('Wrong password provided for that user.');
          }
        }
      }
      if (userCredential.user!.emailVerified == false) {
        User? user = FirebaseAuth.instance.currentUser;
        await user!.sendEmailVerification();
      }
    }
  }

  @override
  void initState() {
    isFloatingActionVisible = false;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text("sign-in page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "images/kmu.png",
              width: 150,
              height: 150,
              //color: Colors.indigo,
            ),
            const SizedBox(
              height: 15,
            ),
            CustomTextFormSign(
                onChanged: (text) {
                  if (kDebugMode) {
                    //print(text);
                  }
                },
                valid: (val) {
                  return validInput(val!, 11, 40);
                },
                obscureText: false,
                keyboardType: TextInputType.emailAddress,
                icon2: IconButton(
                    onPressed: () {
                      emailController.clear();
                    },
                    icon: const Icon(Icons.close)),
                //Icons.abc,
                icon:
                    const IconButton(onPressed: null, icon: Icon(Icons.email)),
                mycontroller: emailController,
                height: 40,
                hint: "email"),
            CustomTextFormSign(
                onChanged: (text) {
                  if (kDebugMode) {
                    //print(text);
                  }
                },
                keyboardType: TextInputType.visiblePassword,
                obscureText: !obs,
                icon2: IconButton(
                    onPressed: () {
                      passwordController.clear();
                    },
                    icon: const Icon(Icons.close)),
                //Icons.abc,
                icon: IconButton(
                    onPressed: () {
                      setState(() {
                        obs = !obs;
                      });
                    },
                    icon: Icon(
                        obs == true ? Icons.visibility : Icons.visibility_off)),
                valid: (val) {
                  return validInputSign(val!, "password", 5, 12);
                },
                mycontroller: passwordController,
                height: 40,
                hint: "password"),
            ElevatedButton(
              onPressed: () async {
                await login();
                getUser();
                await getUserTypeForTeacher();
                useremail;
                if (usertype == 'Teacher') {
                  isFloatingActionVisible = true;
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
              child: const Text(
                'sign in',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            InkWell(
              child: const Text(
                "Don't have an account? , Click for signup",
                style: TextStyle(color: Colors.red, fontSize: 15),
              ),
              onTap: () {
                Navigator.of(context).pushNamed("signup");
              },
            )
          ],
        ),
      ),
    );
  }
}
