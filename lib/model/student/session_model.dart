import 'package:progressp/model/student/student_model.dart';

class SessionModel {
  final String id;
  final StudentModelShort student;
  final int status;
  final int unit;
  final int meetings;
  final int value;
  final String currencyCode;

  SessionModel({
    required this.id,
    required this.student,
    required this.status,
    required this.unit,
    required this.meetings,
    required this.value,
    required this.currencyCode,
  });

  factory SessionModel.fromJson(Map<String, dynamic> parsedJson) {
    return SessionModel(
      id: parsedJson['id'],
      student: StudentModelShort(
        id: parsedJson['student']['id'],
        fullName: parsedJson['student']['fullName'],
      ),
      status: parsedJson['status'],
      unit: parsedJson['unit'],
      meetings: parsedJson['meetings'],
      value: parsedJson['value'],
      currencyCode: parsedJson['currencyCode'],
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
      'unit': unit,
      'meetings': meetings,
      'value': value,
      'currencyCode': currencyCode,
    };
  }

  @override
  String toString() {
    return '{unit: $unit, status: $status, value: $value}';
  }
}

class SessionModelShort {
  final String id;
  final int unit;
  final int status;

  SessionModelShort({
    required this.id,
    required this.unit,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'unit': unit,
      'status': status,
    };
  }
}