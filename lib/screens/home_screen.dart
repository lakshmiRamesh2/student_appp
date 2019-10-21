

import 'package:flutter/material.dart';

//import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_app/widget/studdent assignment widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
//import 'package:image_picker/image_picker.dart'; // For Image Picker
//import 'package:path/path.dart' as Path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:student_app/api_manager/api_manager.dart';


class HomeScreen extends StatefulWidget{

  final String studentName;
  final String studentDeviceId;
  final String studentEmailId;
  final String studentId;
  HomeScreen({@required this.studentName,this.studentDeviceId,this.studentEmailId,this.studentId});


  @override
  HomeScreenState createState() =>HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   studentAssignmentWidgets=listofStatusForUploadedAssignment();
    getTeacherDetails();
 //  Future.delayed(Duration(seconds: 2)).then((d){
     //listofUploadeddocuments();
  // });
  }
 List<StudentAssignmentWidget> studentAssignmentWidgets=[];
  String _path;



  List<StorageUploadTask> _tasks=<StorageUploadTask>[];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Home Screen"),backgroundColor: Colors.green),
        body: ListView(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Hi " + widget.studentName, style: TextStyle(fontSize: 25.0,
                color: Colors.green,
                fontWeight: FontWeight.bold),),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Send Assignment ", style: TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.bold),),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Divider(color: Colors.green,),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(onPressed: () {
              filePicker();
            }, child: Text("UPLOAD Assignment"), color: Colors.green,),
          ),
        Divider(color: Colors.green,),
        // Column(children: studentAssignmentWidgets
      //   )

        ],)

    );
  }



  List<StudentAssignmentWidget> listofStatusForUploadedAssignment(){
    List<StudentAssignmentWidget> listAssignmentUrl=[];
    Firestore.instance
        .collection('assignmentstatus')
        .where("teacher_devicceId", isEqualTo:"eGKhVGqD5-Q:APA91bHFSjGi58VC_CkTwnOKXn1ovnEMbCtygdhptN73LHAXN6FSBCr1Wo6l3IUtlh7XE6yEdN3xHNn2y1Zk3gzNoik_vRFDQBDkKWTzE778rUXRR1LZ9rVNQ0tebdJNAShlPuAbj3Fj" )
        .snapshots()
        .listen((data) =>
        data.documents.forEach((doc) =>
            listAssignmentUrl.add(StudentAssignmentWidget(studentName:doc["assignment_name"],
                assignmentUrl:doc["assignment_url"],
                assignmentName: doc["assignment_name"],
              teacherName: doc["teacher_name"],
              statusOfAssignment: doc["assignment_url"],
            ))

        ));

    print(listAssignmentUrl.length);
    return listAssignmentUrl;
  }




  void filePicker() async {
    try {
      _path = await FilePicker.getFilePath(type: FileType.ANY);
      String filename = _path
          .split("/")
          .last;
      String filePath = _path;
      upload(filename, filePath);
    } on PlatformException catch (e) {
      print("Unsported permission");
      print(e);

    }
  }
  getTeacherDetails(){

    Firestore.instance
        .collection('teacher')
        .document('LqQZlKHwVxFRrwpcjPFB')
        .get()
        .then((DocumentSnapshot ds) {
      Map<String,dynamic> teacherData=ds.data;

      teacherData.forEach((k,v){

        if(k=="device_id") {
          setState(() {
            teacherDeviceid=v.toString();
            print(teacherDeviceid);
          });
        }
      });
    });

  }

  String teacherDeviceid;
sendNotificationToTeacher()
{
ApiManager().sendNotification(studentName: widget.studentName,teacherDeviceId: teacherDeviceid);

}
uplodthedownlodedurl(){
  Firestore.instance.collection('assignmentDownloadLinks').document()
      .setData({ 'student_deviceId':widget.studentDeviceId,"student_emailId":widget.studentEmailId,
    "assignmentDownloadUrl":uplodedDocumentUrl,"student_name":widget.studentName,"student_id":widget.studentId,
      "teacher_deviceId":teacherDeviceid,"toview":true
      });

}
  String _extension;


  upload(filename, filePath)async {
    _extension = filename
        .toString()
        .split('.')
        .last;
    StorageReference storageReference = FirebaseStorage.instance.ref().child(
        filename);
    print(_extension);

    final StorageUploadTask uploadTask = storageReference.putFile(File(filePath));
    await download(storageReference);
    await uplodthedownlodedurl();
    await sendNotificationToTeacher();
    setState(() {
      _tasks.add(uploadTask);
    });
  }





String uplodedDocumentUrl;
  download(StorageReference ref)async{
  print("download url called");
    String url= await ref.getDownloadURL();
    setState(() {
      uplodedDocumentUrl=url;
    });

    print("im printing the download url");
    print(url);
    final http.Response downloadedData=await http.get(url);
  }


  Widget studentAssignmentWidget(String studentName, String downloadurl) {
    return Card(child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[ Text(studentName), Text("Download")],),);
  }

  String teacherName = "";

}





