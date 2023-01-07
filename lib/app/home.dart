import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quizsystem/app/auth/login.dart';
import 'package:quizsystem/components/questions.dart';
import 'package:quizsystem/main.dart';
import '../components/crud.dart';
import '../constant/linkapi.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with Crud {
  String cevap = "";

  getQuestionsTest() async {
    setState(() {});
    var response = await postRequest(linkQuestionTest, {"id": "1"});
    setState(() {});

    return response;
  }

  String getUser() {
    var user = FirebaseAuth.instance.currentUser;
    useremail = user!.email!;
    return useremail;
  }

  Future getUserTypeForTeacher() async {
    setState(() {});
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

  @override
  void initState() {
    isFloatingActionVisible = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text('Home page'),
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacementNamed('login');
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      floatingActionButton: Visibility(
        visible: isFloatingActionVisible,
        child: FloatingActionButton(
          backgroundColor: Colors.indigo,
          onPressed: () {
            Navigator.of(context).pushNamed('questiontype');
          },
          child: const Icon(Icons.add),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            FutureBuilder(
                future: getQuestionsTest(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data['status'] == 'fail') {
                      return const Center(
                          child: Text(
                        "There are no questions here !",
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                        textAlign: TextAlign.center,
                      ));
                    }

                    return ListView.builder(
                        itemCount: snapshot.data['data'].length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, i) {
                          return Questions(
                            question: "${snapshot.data['data'][i]['question']}",
                            A: "${snapshot.data['data'][i]['A']}",
                            B: "${snapshot.data['data'][i]['B']}",
                            C: "${snapshot.data['data'][i]['C']}",
                            D: "${snapshot.data['data'][i]['D']}",
                            onpressed: () async {},
                            groupValue: cevap,
                            onChanged: (value) {
                              setState(() {
                                cevap = value.toString();
                              });
                            },
                          );
                        });
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Text("Loading zzzzzz"),
                    );
                  }
                  return const Center(
                    child: Text("Loading ....."),
                  );
                }),
            /*ElevatedButton(
                onPressed: () async {
                  //print(useremail);
                },
                child: const Text('Get User Type'))*/
          ],
        ),
      ),
    );
  }
}
