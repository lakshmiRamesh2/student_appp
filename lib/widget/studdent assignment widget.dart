



import 'package:flutter/material.dart';
import "package:http/http.dart"as http;
import 'dart:io';
import 'package:student_app/screens/assignment_screen.dart';



class StudentAssignmentWidget extends StatefulWidget{

  final String studentName;
  final String assignmentUrl;
  final String assignmentName;
  final String statusOfAssignment;
  final String teacherName;

  StudentAssignmentWidget({@required this.studentName,
    @required this.assignmentUrl,
    @required this.assignmentName,
    @required this.statusOfAssignment,
  @required this.teacherName});

  StudentAssignmentWidgetState createState()=>StudentAssignmentWidgetState();
}

class StudentAssignmentWidgetState extends State<StudentAssignmentWidget>{
  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: (){
        Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AssignmentScreen(studentName: widget.studentName,
                          statusOfAssignment: widget.statusOfAssignment,
                          assignmentName: widget.assignmentName,
                          assignmentUrl: widget.assignmentUrl,
                          teacherName: widget.teacherName,),
                      ),
                    );


            },
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child:Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(widget.assignmentName,style: TextStyle(fontSize: 14.0,color: Colors.redAccent)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(onPressed: (){
                   // _showDownloadurl();
                    downloadUrl(widget.assignmentUrl);
                  },child:Row(
                    children: <Widget>[
                      Icon(Icons.file_download,color: Colors.blue,),
                      Text(" Download",style: TextStyle(fontSize: 14.0,color: Colors.blue),),
                    ],
                  ),),
                )
              ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDownloadurl() {
    print("dialog box called");
    AlertDialog dialog = AlertDialog(
      content: Column(
        children: <Widget>[
          Text("please tap on the link"+widget.assignmentUrl),

        ],
      ),
      actions: <Widget>[

      ],
    );
    showDialog(
      context: context,
      builder: (context) => dialog,
      // child: dialog,
    );
  }

  downloadUrl(String url)async{
    final http.Response downlodedData=await http.get(url);
    final Directory systemTempDir= Directory.systemTemp;
   // downlodedData.bodyBytes
    print(widget.assignmentUrl);
  }
}