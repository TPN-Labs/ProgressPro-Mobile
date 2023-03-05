import 'package:progressp/config/constants.dart';
import 'package:progressp/model/student/student_model.dart';

class SessionModel {
  final String id;
  final StudentModelShort student;
  final int status;
  final SessionStatus statusEnum;
  final int unit;
  final int meetings;
  final int price;

  SessionModel({
    required this.id,
    required this.student,
    required this.status,
    required this.statusEnum,
    required this.unit,
    required this.meetings,
    required this.price,
  });

  factory SessionModel.fromJson(Map<String, dynamic> parsedJson) {
    return SessionModel(
      id: parsedJson['id'],
      student: StudentModelShort(
        id: parsedJson['student']['id'],
        fullName: parsedJson['student']['fullName'],
      ),
      status: parsedJson['status'],
      statusEnum: SessionStatus.values.firstWhere((e) => e.value == parsedJson['status']),
      unit: parsedJson['unit'],
      meetings: parsedJson['meetings'],
      price: parsedJson['price'],
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
      'price': price,
    };
  }

  @override
  String toString() {
    return '{unit: $unit, status: $status, price: $price}';
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