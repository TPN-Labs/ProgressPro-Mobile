import 'package:progressp/model/student/session_model.dart';
import 'package:progressp/model/student/student_model.dart';

class NoteModel {
  final String id;
  final StudentModelShort student;
  final String measurementName;
  final double measurementValue;
  final DateTime tookAt;

  NoteModel({
    required this.id,
    required this.student,
    required this.measurementName,
    required this.measurementValue,
    required this.tookAt,
  });

  factory NoteModel.fromJson(Map<String, dynamic> parsedJson) {
    return NoteModel(
      id: parsedJson['id'],
      student: StudentModelShort(
        id: parsedJson['student']['id'],
        fullName: parsedJson['student']['fullName'],
        avatar: parsedJson['student']['avatar'],
      ),
      measurementName: parsedJson['measurementName'],
      measurementValue: parsedJson['measurementValue'],
      tookAt: DateTime(
        parsedJson['tookAt'][0],
        parsedJson['tookAt'][1],
        parsedJson['tookAt'][2],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student': student,
      'measurementName': measurementName,
      'measurementValue': measurementValue,
      'tookAt': [
        tookAt.year,
        tookAt.month,
        tookAt.day,
      ],
    };
  }

  @override
  String toString() {
    return '{id: $id, student: $student, name: $measurementName, value: $measurementValue, tookAt: $tookAt}\n';
  }
}