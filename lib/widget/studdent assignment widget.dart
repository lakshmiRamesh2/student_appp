



import 'package:flutter/material.dart';
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("hey u got the result !!!!",style: TextStyle(fontSize: 14.0,color: Colors.redAccent)),
                      Text("Tap to see the status"),
                    ],
                  ),
                ),


              ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}