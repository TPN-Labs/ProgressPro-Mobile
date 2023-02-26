import 'package:progressp/model/student/student_model.dart';

class SessionModel {
  final String id;
  final StudentModelShort student;
  final int status;
  final String name;
  final int meetings;
  final int value;
  final String currencyCode;
  final DateTime startAt;
  final DateTime endAt;

  SessionModel({
    required this.id,
    required this.student,
    required this.status,
    required this.name,
    required this.meetings,
    required this.value,
    required this.currencyCode,
    required this.startAt,
    required this.endAt,
  });

  factory SessionModel.fromJson(Map<String, dynamic> parsedJson) {
    return SessionModel(
      id: parsedJson['id'],
      student: StudentModelShort(
        id: parsedJson['student']['id'],
        fullName: parsedJson['student']['fullName'],
      ),
      status: parsedJson['status'],
      name: parsedJson['name'],
      meetings: parsedJson['meetings'],
      value: parsedJson['value'],
      currencyCode: parsedJson['currencyCode'],
      startAt: DateTime(
        parsedJson['startAt'][0],
        parsedJson['startAt'][1],
        parsedJson['startAt'][2],
      ),
      endAt: DateTime(
        parsedJson['endAt'][0],
        parsedJson['endAt'][1],
        parsedJson['endAt'][2],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student': {
        'id': student.id,
        'fullName': student.fullName,
      },
      'status': status,
      'name': name,
      'meetings': meetings,
      'value': value,
      'currencyCode': currencyCode,
      'startAt': startAt,
      'endAt': endAt,
    };
  }

  @override
  String toString() {
    return '{name: $name, status: $status, value: $value}';
  }
}

class SessionModelShort {
  final String id;
  final String name;
  final int status;

  SessionModelShort({
    required this.id,
    required this.name,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
    };
  }
}