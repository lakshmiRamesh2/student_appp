import 'package:flutter/material.dart';
import 'package:student_app/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class LoginScreen extends StatefulWidget{
  LoginScreenState createState()=>LoginScreenState();
}
class LoginScreenState extends State<LoginScreen>{
  TextEditingController nameController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  final GlobalKey<ScaffoldState> _globalScaffoldKey = new GlobalKey<ScaffoldState>();
bool isNameFilled=true;
bool isEmailFIlled=true;
bool isPasswordFilled=true;

  @override
  void initState() {
    super.initState();
    getToken();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.purpleAccent,
      key: _globalScaffoldKey,
      appBar: AppBar(title:Center(child: Text("Login Screen")),backgroundColor: Colors.purpleAccent,elevation: 0.0,),
      body: ListView(
        children: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical:100.0,horizontal:16.0),
              child: Card(
                child: Column( children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: flexibleTextfield(controller: nameController,hintText: "Name"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: flexibleTextfield(controller: emailController,hintText: "Email-ID"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: flexibleTextfield(controller:passwordController,hintText: "Password",obscure: true),
                  ),
                  RaisedButton(onPressed:(){done();}
//                    Navigator.pushReplacement(
//                      context,
//                      MaterialPageRoute(
//                        builder: (context) => HomeScreen(),
//                      ),
//                    );
                  ,child: Text("Done"),color:Colors.purpleAccent,)
                ],
                ),
              ),
            ),
          ),
        ],
      ),

    );
  }


  Widget flexibleTextfield({TextEditingController controller,String hintText ,bool obscure:false }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(child: TextField(
        controller: controller,
        decoration: InputDecoration.collapsed(hintText: hintText),
        obscureText: obscure,)),
    );
  }
  void done(){
    print("tapped");

    print(nameController.text);
    if(nameController.text.isEmpty)
    {
      setState(() {
        isPasswordFilled = false;
        print(isPasswordFilled);
        showInSnackBar("Please Enter UserName");
      });
    }
    print(emailController.text);
    if(emailController.text.isEmpty)
    {
      setState(() {
        isPasswordFilled = false;
        print(isPasswordFilled);
        showInSnackBar("Please Enter Email-ID");
      });
    }

    print(passwordController.text);
    if(passwordController.text.isEmpty) {
      setState(() {
        isPasswordFilled = false;
        print(isPasswordFilled);
        showInSnackBar("Please Enter the passsword");
      });
    }
 if(nameController.text.isNotEmpty&& emailController.text.isNotEmpty&& passwordController.text.isNotEmpty){
   setState(() {
     print("Sucessfully LogedIn");
     SharedPreferences.getInstance().then((prefs) {
       //  print('USER ID: ${model.userId}');
       prefs.setString("name", nameController.text);
       prefs.setString("emailId",emailController.text);
       prefs.setString("password",passwordController.text);
       storeData();
       Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(studentName: nameController.text,
                        studentDeviceId: devicetoken,
                        studentEmailId: emailController.text,
                        studentId:studentID ,),
                      ),
                    );

     });

   });
 }

  }

  String studentID;
  void storeData(){
    var uuid = new Uuid();
    print("im printing uuid");
    print(uuid.v1());
    studentID=uuid.v1();
    if(emailController.text=="student1@123") {
      Firestore.instance.collection('student').document("HLhDZS01qnlRILkr9mDl")
          .setData({
        'student_deviceId': devicetoken,
        "student_emailId": emailController.text,
        "student_password": passwordController.text,
        "student_name": nameController.text,
        "student_id": studentID
      });
    }
    if(emailController.text=="student2@123"){
      Firestore.instance.collection('student').document("KAlHI4093ozwO9uWEetK")
          .setData({
        'student_deviceId': devicetoken,
        "student_emailId": emailController.text,
        "student_password": passwordController.text,
        "student_name": nameController.text,
        "student_id": studentID
      });
    }else{ Firestore.instance.collection('student').document()
        .setData({
      'student_deviceId': devicetoken,
      "student_emailId": emailController.text,
      "student_password": passwordController.text,
      "student_name": nameController.text,
      "student_id": studentID
    });
    }

    }
    }

  }
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String devicetoken;

  void getToken() {

    _firebaseMessaging.getToken().then((token) {
      print(token);
      devicetoken=token;

    });
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {

      },
      onResume: (Map<String, dynamic> message) async {

      },
      onLaunch: (Map<String, dynamic> message) async {
      },
    );
  }

  void iosPermission() {
    print("its IOs");
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  void showInSnackBar(String value) {
    _globalScaffoldKey.currentState.showSnackBar(
        new SnackBar(key: Key("message"), content: new Text(value)));
  }
}