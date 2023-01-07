import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quizsystem/components/customtextform.dart';
import 'package:quizsystem/components/valid.dart';
import 'dart:math' show Random;
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../components/crud.dart';
import '../../constant/linkapi.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with Crud {
  //********************************1

  // Position Dropdown START
  String? positionName;
  List<String> positionList = ["Teacher", "Student"];

// Position Dropdown END

  //*******

//department Dropdown START
  String? departmentName, message;
  bool? error;
  var data, dataid;
  final formKeySearch = GlobalKey<FormState>();
  TextEditingController selectTeacherFormDropdownCtrl = TextEditingController();
  List<String> departmentsList = [
    "Select Your Department",
    "Computer Engineering",
    "Machine Engineering",
    //"Food Engineering"
  ];

//department dropdown END

  // API DATA
  String dataurl = linkDropDownTeachers;

// API DATA END
  @override
  void initState() {
    error = false;
    message = "";
    // departmentName = "Select Your Department"; //default department
    super.initState();
  }

  Future<void> getTeachers() async {
    var res = await http.post(
        Uri.parse("$dataurl?dep=${Uri.encodeComponent(departmentName!)}"));
    //attache countryname on parameter country in url
    if (res.statusCode == 200) {
      setState(() {
        data = json.decode(res.body);
        if (data["error"]) {
          //check if there is any error from server.
          error = true;
          message = data["errmsg"];
        }
      });
    } else {
      //there is error
      setState(() {
        error = true;
        message = "Error during fetching data";
      });
    }
  }

  late int teacherid;
  Future getTeacherId() async {
    setState(() {});
    var response = await postRequest(linkTeacherId,
        {"displaynameforid": selectTeacherFormDropdownCtrl.text});

    setState(() {
      teacherid = response['data'][0]['id'];
      if (kDebugMode) {
        print(teacherid);
      }

    });

    return response;
  }

  //*********************************1
  GlobalKey<FormState> formstate = GlobalKey();
  TextEditingController nameSurname = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  bool obs = false;
  bool obs2 = false;
  String? value;
  String? value2;
  String? message2;

  //auth
  UserCredential? userCredential;
  final Crud _crud = Crud();

  String userName(String namesurname) {
    String user, rand, total;
    user = namesurname.replaceAll(' ', '');
    rand = getRandomString(3, '1234567890');
    total = user.toLowerCase() + rand;
    return total;
  }

  String getRandomString(length, [characterString]) {
    String chars = characterString ?? '1234567890';
    Random rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }

// sign up STUDENT
  signUpStudent() async {
    if (emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        value2!.isNotEmpty &&
        nameSurname.text.isNotEmpty &&
        confirmPassword.text.isNotEmpty &&
        positionName != null &&
        departmentName != null &&
        selectTeacherFormDropdownCtrl.text.isNotEmpty) {
      if (passwordController.text == confirmPassword.text) {
        try {
          userCredential =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
          );
          var userid = FirebaseAuth.instance.currentUser!.uid;
          message2 = 'Account has been created successfully.';
          await getTeacherId();
          //API , sending uID to MYSQL Database
          var response = await _crud.postRequest(linkSignUpStudent, {
            "username": value2,
            "email": emailController.text,
            "uid": userid,
            "displayname": nameSurname.text,
            "usertype": positionName.toString(),
            "department": departmentName.toString(),
            "teacherstudent": selectTeacherFormDropdownCtrl.text,
            "teacherstudentid": teacherid.toString(),
          });
          if (response['status'] == "success") {
            if (kDebugMode) {
              print("sign-up succeeded");
            }
          }
          //API End

          Show(message2!);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            message2 = 'The password provided is too weak.';
            Show(message2!);
            //print('The password provided is too weak.');
          } else if (e.code == 'email-already-in-use') {
            message2 = 'The account already exists for that email.';
            Show(message2!);
            //print('The account already exists for that email.');
          }
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
        }
      } else if (passwordController.text != confirmPassword.text) {
        message2 = 'Passwords do not match';
        Show(message2!);
      }
    } else {
      message2 = 'One of these fields cannot be empty';
      Show(message2!);
    }
  }

  // sign up Teacher
  signUpTeacher() async {
    if (emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        value2!.isNotEmpty &&
        nameSurname.text.isNotEmpty &&
        confirmPassword.text.isNotEmpty &&
        positionName != null &&
        departmentName != null) {
      if (passwordController.text == confirmPassword.text) {
        try {
          userCredential =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
          );
          var userid = FirebaseAuth.instance.currentUser!.uid;
          message2 = 'Account has been created successfully.';

          //API , sending uID to MYSQL Database
          var response = await _crud.postRequest(linkSignUpTeacher, {
            "username": value2,
            "email": emailController.text,
            "uid": userid,
            "displayname": nameSurname.text,
            "usertype": positionName.toString(),
            "department": departmentName.toString(),
          });
          if (response['status'] == "success") {
            if (kDebugMode) {
              print("sign-up succeeded");
            }
          }
          //API End

          Show(message2!);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            message2 = 'The password provided is too weak.';
            Show(message2!);
            //print('The password provided is too weak.');
          } else if (e.code == 'email-already-in-use') {
            message2 = 'The account already exists for that email.';
            Show(message2!);
            //print('The account already exists for that email.');
          }
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
        }
      } else if (passwordController.text != confirmPassword.text) {
        message2 = 'Passwords do not match';
        Show(message2!);
      }
    } else {
      message2 = 'One of these fields cannot be empty';
      Show(message2!);
    }
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
              if (message2 == 'Account has been created successfully.') {
                Navigator.of(context).pushReplacementNamed("login");
              } else if (message2 == 'The password provided is too weak.') {
                Navigator.of(ctx).pop();
              } else if (message2 ==
                  'The account already exists for that email.') {
                Navigator.of(ctx).pop();
              } else if (message2 == 'The email or password cannot be empty') {
                Navigator.of(ctx).pop();
              } else if (message2 == 'One of these fields cannot be empty') {
                Navigator.of(ctx).pop();
              } else if (message2 == 'Passwords do not match') {
                Navigator.of(ctx).pop();
              }
              //Navigator.of(ctx).pop();
            },
            child: Container(
              color: Colors.indigo,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text("sign-up page"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 25,
              ),
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
                    setState(() {
                      value = text!;
                      value2 = userName(value!);
                    });
                  },
                  valid: (val) {
                    return validInput(val!, 2, 40);
                  },
                  obscureText: false,
                  keyboardType: TextInputType.text,
                  icon2: IconButton(
                      onPressed: () {
                        setState(() {
                          nameSurname.clear();
                          username.text = '';
                        });
                      },
                      icon: const Icon(Icons.close)),
                  //Icons.abc,
                  icon:
                      const IconButton(onPressed: null, icon: Icon(Icons.abc)),
                  mycontroller: nameSurname,
                  height: 40,
                  hint: "name surname"),
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
                  icon: const IconButton(
                      onPressed: null, icon: Icon(Icons.email)),
                  mycontroller: emailController,
                  height: 40,
                  hint: "email"),
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
                        setState(() {
                          username.text = '';
                          value2 = '';
                        });

                        //value = TextEditingController(text: userName(nameSurname.text)) as String;
                      },
                      icon: const Icon(Icons.close)),
                  //Icons.abc,
                  icon: const IconButton(
                      onPressed: null, icon: Icon(Icons.person)),
                  mycontroller: TextEditingController(
                      text: nameSurname.text.isEmpty ? username.text : value2),
                  height: 40,
                  hint: "username"),
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
                      icon: Icon(obs == true
                          ? Icons.visibility
                          : Icons.visibility_off)),
                  valid: (val) {
                    return validInput(val!, 5, 15);
                  },
                  mycontroller: passwordController,
                  height: 40,
                  hint: "password"),
              CustomTextFormSign(
                  onChanged: (text) {
                    if (kDebugMode) {
                      //print(text);
                    }
                  },
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: !obs2,
                  icon2: IconButton(
                      onPressed: () {
                        confirmPassword.clear();
                      },
                      icon: const Icon(Icons.close)),
                  //Icons.abc,
                  icon: IconButton(
                      onPressed: () {
                        setState(() {
                          obs2 = !obs2;
                        });
                      },
                      icon: Icon(obs2 == true
                          ? Icons.visibility
                          : Icons.visibility_off)),
                  valid: (val) {
                    return validInput(val!, 5, 15);
                  },
                  mycontroller: confirmPassword,
                  height: 40,
                  hint: "confirm password"),

              const Divider(color: Colors.indigo, height: 5),
              const Text(
                "Academic Information",
                style: TextStyle(fontSize: 20, color: Colors.indigo),
              ),
              const Divider(color: Colors.indigo, height: 5),
              Container(
                padding: const EdgeInsets.all(30),
                child: Column(children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9.0),
                      border: Border.all(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 0.80),
                    ),
                    child: DropdownButton(
                      underline: const SizedBox(),
                      borderRadius: BorderRadius.circular(12.0),
                      //iconEnabledColor: Colors.black,
                      isExpanded: true,
                      value: positionName,
                      hint: const Text("Select Your Position"),
                      items: positionList.map((positionone) {
                        return DropdownMenuItem(
                          enabled: true,
                          value: positionone,
                          child: Text(positionone), //value of item
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          positionName =
                              value as String; //change the department name
                          getTeachers(); //get teacher list.
                          data = null;
                          selectTeacherFormDropdownCtrl.clear();
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9.0),
                      border: Border.all(
                          color: Colors.black,
                          style: BorderStyle.solid,
                          width: 0.80),
                    ),
                    child: DropdownButton(
                      underline: const SizedBox(),
                      borderRadius: BorderRadius.circular(12.0),
                      //iconEnabledColor: Colors.indigo,
                      isExpanded: true,
                      value: departmentName ?? departmentsList.first,
                      hint: const Text("Select Department"),
                      items: departmentsList.map((departmentone) {
                        return DropdownMenuItem(
                          enabled: true,
                          value: departmentone,
                          child: Text(departmentone), //value of item
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          departmentName =
                              value as String; //change the department name
                          if (departmentName != null &&
                              departmentName != departmentsList.first) {
                            getTeachers(); //get teacher list.
                            selectTeacherFormDropdownCtrl.clear();
                          } else {
                            selectTeacherFormDropdownCtrl.clear();
                            data = null;
                          }
                        });
                      },
                    ),
                  ),
                  positionName == "Student"
                      ? Container(
                          child: error!
                              ? Text(message!)
                              : data == null
                                  ? Container()
                                  : teachers(),
                        )
                      : Container(/*Empty*/),
                ]),
              ),

              //const MyDropDown(),
              ElevatedButton(
                onPressed: () async {
                  positionName == 'Student'
                      ? await signUpStudent()
                      : await signUpTeacher();
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                child: const Text(
                  'sign up',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                child: const Text(
                  "Don't have an account? , Click for Login",
                  style: TextStyle(color: Colors.red, fontSize: 15),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed("login");
                },
              ),

              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget teachers() {
    //widget function for teacher list
    List<TeacherOne> teacherlist = List<TeacherOne>.from(data["data"].map((i) {
      return TeacherOne.fromJSON(i);
    }));
    return Form(
      key: formKeySearch,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 1.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9.0),
              border: Border.all(
                  color: Colors.white30, style: BorderStyle.solid, width: 0.80),
            ),
            child: CustomDropdown.search(
              borderRadius: BorderRadius.circular(12.0),
              hintText: 'Select Your Teacher',
              items: teacherlist.map((e) => e.displayname).toList(),
              controller: selectTeacherFormDropdownCtrl,
              excludeSelected: false,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

//model class to searilize country list JSON data.
class TeacherOne {
  String id, department, displayname;

  TeacherOne(
      {required this.id, required this.department, required this.displayname});

  factory TeacherOne.fromJSON(Map<String, dynamic> json) {
    return TeacherOne(
        id: json["id"],
        department: json["department"],
        displayname: json["displayname"]);
  }
}
