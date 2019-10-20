




class TeacherModel{

  String teacherId;
  String teacherName;
  String emailId;
  String password;
  String deviceId;
  TeacherModel.fromjson(Map jsonMap)
      : this.teacherId = jsonMap['teacher_id'],
        this.teacherName = jsonMap["teacher_name"],
        this.emailId = jsonMap["email_id"],
        this.password = jsonMap["password"],
        this.deviceId = jsonMap["device_id"];

}
