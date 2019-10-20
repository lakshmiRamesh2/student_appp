


import 'package:flutter/material.dart';


class AssignmentScreen extends StatefulWidget {

  final String studentName;
  final String assignmentUrl;
  final String assignmentName;
  final String statusOfAssignment;
  final String teacherName;

  AssignmentScreen({@required this.studentName,
    @required this.assignmentUrl,
    @required this.assignmentName,
    @required this.statusOfAssignment,
    @required this.teacherName});



  @override
  AssignmentScreenState createState() => AssignmentScreenState();
}
  class AssignmentScreenState extends State<AssignmentScreen>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Column(
        children: <Widget>[
          Text("Student Name"),

        ],
      ),
    );
  }

  String Wish;
Widget assignmentWidget(String studentName,String studentUrl) {
  return Card(child: Column(
    children: <Widget>[
      Text(Wish),
      RaisedButton(onPressed: () {}, child: Text("download"))
    ],
  ),);
}

  Widget statusButton(String status){
    return  RaisedButton(onPressed: (){}, child:Text(status));
  }

 Widget wisher(){
  if(widget.statusOfAssignment=="BAD"){
    return Row(children: <Widget>[
      Text("DO WELL NEXT TIME ! ",style: TextStyle(fontSize: 18.0),),
      Text(widget.studentName,style: TextStyle(fontSize: 18.0)),
    ],);
  }
  else{
    return Row(children: <Widget>[
      Text("GREAT ,CONGRATULATIONS! ",style: TextStyle(fontSize: 18.0),),
   Text(widget.studentName,style: TextStyle(fontSize: 18.0)),
 ],);
  }
 }
 Widget greatings(){
  return Wrap(children: <Widget>[
    Row(children: <Widget>[
      Text("Teacher "),
      Text(widget.teacherName),
      Text(" has been given you the status"),
      Text(widget.statusOfAssignment),
      Text(" For assignment"),
      Text(widget.assignmentName),
    ],)
  ],);
 }
}