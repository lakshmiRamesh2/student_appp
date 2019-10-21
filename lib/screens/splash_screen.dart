


import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "login_screen.dart";
import 'home_screen.dart';

class SplashScreen extends StatefulWidget{
  @override
  SplashScreenState createState() =>SplashScreenState();

}

class SplashScreenState extends State<SplashScreen>{

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2)).then(
            (d)async {
//          checkIfUserOnBoarded().then(
//                  (isOnBoarded) async {
                    String name = await getName();
                if (name==null) {
                  print("User not Logged in");
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginScreen())
                  );

                  } else {
                  print("user Loggedin");
                  String name = await getName();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(studentName: name,),
                    ),
                  );
                }
                 // });
  });

              }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(child: Text("Student App",style: TextStyle(color: Colors.green,fontSize: 20.0,fontStyle: FontStyle.italic),),),
    );
  }



  Future<bool> checkIfUserOnBoarded() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isOnBoarded = prefs.getBool("isOnboarded");
    if (isOnBoarded == null || !isOnBoarded) {
      print("no one logged in");
      return false;
    }
    print("some one logged in");
    return true;
  }

Future<String> getName()async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String teacherName = prefs.getString('name');
                   return teacherName;
            }


}

