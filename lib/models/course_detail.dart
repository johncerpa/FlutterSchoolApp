import 'package:login/models/person.dart';

class CourseDetail {
  final String name;
  final Person professor;
  final List<Person> students;

  CourseDetail({this.name, this.professor, this.students});

  CourseDetail.initial()
      : name = '',
        professor = Person.initial(),
        students = [];

  factory CourseDetail.fromJson(Map<String, dynamic> json) {
    List list = json['students'] as List;
    List<Person> studentList = list.map((i) => Person.fromJson(i)).toList();
    return CourseDetail(
        name: json['name'],
        professor: Person.fromJson(json['professor']),
        students: studentList);
  }
}
