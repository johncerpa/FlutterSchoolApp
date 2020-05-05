class Course {
  String name;
  String professor;
  int students;

  Course({this.name, this.professor, this.students});

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
        name: json['name'],
        professor: json['professor'],
        students: json['students']);
  }
}
