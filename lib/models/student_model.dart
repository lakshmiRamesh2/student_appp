








class StudentModel{

  String studentId;
  String studentName;
  String studentEmailId;
  String studentPassword;
  String studentDeviceId;
  StudentModel.fromjson(Map jsonMap)
      : this.studentId = jsonMap['student_id'],
        this.studentName = jsonMap["student_name"],
        this.studentEmailId = jsonMap["studentEmail_id"],
        this.studentPassword = jsonMap["student_password"],
        this.studentDeviceId = jsonMap["studentDevice_id"];

}
