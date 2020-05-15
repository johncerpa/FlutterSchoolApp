import 'package:login/models/person.dart';

class CourseDetailsModel {
  final String name;
  final Person professor;
  final List<Person> students;

  CourseDetailsModel({this.name, this.professor, this.students});

  CourseDetailsModel.initial()
      : name = '',
        professor = Person.initial(),
        students = [];

  factory CourseDetailsModel.fromJson(Map<String, dynamic> json) {
    List list = json['students'] as List;
    List<Person> studentList = list.map((i) => Person.fromJson(i)).toList();
    return CourseDetailsModel(
        name: json['name'],
        professor: Person.fromJson(json['professor']),
        students: studentList);
  }
}
