import 'dart:convert';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constant/linkapi.dart';

class MyDropDown extends StatefulWidget {
  const MyDropDown({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyDropDown();
  }
}

class _MyDropDown extends State<MyDropDown> {
// Position Dropdown START
  String? positionName;
  List<String> positionList = ["Teacher","Student"];
// Position Dropdown END

  //*******

//department Dropdown START
  String? departmentName, message;
  bool? error;
  var data;
  final formKeySearch = GlobalKey<FormState>();
  TextEditingController selectTeacherFormDropdownCtrl = TextEditingController();
  List<String> departmentsList = [
    "Select Your Department",
    "Computer Engineering",
    "Machine Engineering"
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
        Uri.parse("$dataurl?country=${Uri.encodeComponent(departmentName!)}"));
    //attache countryname on parameter country in url
    if (res.statusCode == 200) {
      setState(() {
        data = json.decode(res.body);
        if (data["error"]) {
          //check fi there is any error from server.
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("App Bar")),
      body: Container(
        padding: const EdgeInsets.all(30),
        child: Column(children: <Widget>[
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9.0),
              border: Border.all(
                  color: Colors.black, style: BorderStyle.solid, width: 0.80),
            ),
            child: DropdownButton(
              underline: const SizedBox(),
              borderRadius: BorderRadius.circular(12.0),
              iconEnabledColor: Colors.indigo,
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
                  positionName = value as String; //change the department name
                    getTeachers(); //get teacher list.
                    selectTeacherFormDropdownCtrl.clear();

                });
              },
            ),
          ),
          const SizedBox(height: 10,),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9.0),
              border: Border.all(
                  color: Colors.black, style: BorderStyle.solid, width: 0.80),
            ),
            child: DropdownButton(
              underline: const SizedBox(),
              borderRadius: BorderRadius.circular(12.0),
              iconEnabledColor: Colors.indigo,
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
                  departmentName = value as String; //change the department name
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
          positionName == "Student" ? Container(
            child: error!
                ? Text(message!)
                : data == null
                    ? Container()
                    : teachers(),
          ) : Container(/*Empty*/),
        ]),
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
