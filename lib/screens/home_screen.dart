

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
import 'package:student_app/utils/user_list.dart';
import 'package:student_app/models/teacher_model.dart';
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
  Map<String, String> _paths;
  String _extension;
  FileType _pickType;
  bool _multiplePick = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  List<StorageUploadTask> _tasks=<StorageUploadTask>[];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Home Screen"),),
        body: ListView(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Hi " + widget.studentName, style: TextStyle(fontSize: 25.0,
                color: Colors.purpleAccent,
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
            child: Divider(color: Colors.purpleAccent,),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(onPressed: () {
              filePicker();
            }, child: Text("UPLOAD Assignment"), color: Colors.purpleAccent,),
          ),
        Divider(color: Colors.purpleAccent,),
         Column(children: studentAssignmentWidgets
         )

        ],)

    );
  }

// List<StudentAssignmentWidget> listofUploadeddocuments(){
//    List<StudentAssignmentWidget> listAssignmentUrl=[];
//    Firestore.instance
//        .collection('assignmentDownloadLinks')
//        .where("student_deviceId", isEqualTo:widget.studentDeviceId)
//        .snapshots()
//        .listen((data) =>
//        data.documents.forEach((doc) =>
//            listAssignmentUrl.add(StudentAssignmentWidget(studentName:doc["student_name"],assignmentUrl:doc["assignmentDownloadUrl"]))
//
//        ));
//    return listAssignmentUrl;
//  }

  List<StudentAssignmentWidget> listofStatusForUploadedAssignment(){
    List<StudentAssignmentWidget> listAssignmentUrl=[];
    Firestore.instance
        .collection('assignmentstatus')
        .where("student_deviceId", isEqualTo:widget.studentDeviceId )
        .snapshots()
        .listen((data) =>
        data.documents.forEach((doc) =>
            listAssignmentUrl.add(StudentAssignmentWidget(studentName:doc["student_name"],assignmentUrl:doc["assignmentDownloadUrl"]))

        ));
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
    "assignmentDownloadUrl":uplodedDocumentUrl,"student_name":widget.studentName,"student_id":widget.studentId});

}


  upload(filename, filePath)async {
    _extension = filename
        .toString()
        .split('.')
        .last;
    StorageReference storageReference = FirebaseStorage.instance.ref().child(
        filename);

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
//fetchData()async{
//  SharedPreferences prefs = await SharedPreferences.getInstance();
//  String teacherName = prefs.getString('name');
//  setState(() {
//    teacherName=teacherName;
//  });
//}
}



//class UploadedTaskLIstTile extends StatelessWidget{
//
//  UploadedTaskLIstTile({Key key,this.task,this.onDismiss,this.onDownload}):super(key:key);
// final  StorageUploadTask task;
// final VoidCallback onDismiss;
// final VoidCallback onDownload;
//
//  @override
//  Widget build(BuildContext context) {
//    // TODO: implement build
//    return StreamBuilder<StorageTaskEvent>(
//      stream: task.events,
//      builder: (BuildContext context, AsyncSnapshot<StorageTaskEvent>, asyncSnapshot){
//        Widget subTitle;
//    }
//    )
//  }
//}

