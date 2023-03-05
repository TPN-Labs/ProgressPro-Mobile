import 'package:progressp/model/student/session_model.dart';
import 'package:progressp/model/student/student_model.dart';

class MeetingModel {
  final String id;
  final StudentModelShort student;
  final SessionModelShort session;
  final DateTime startAt;
  final DateTime endAt;

  MeetingModel({
    required this.id,
    required this.student,
    required this.session,
    required this.startAt,
    required this.endAt,
  });

  factory MeetingModel.fromJson(Map<String, dynamic> parsedJson) {
    return MeetingModel(
      id: parsedJson['id'],
      student: StudentModelShort(
        id: parsedJson['student']['id'],
        fullName: parsedJson['student']['fullName'],
        avatar: parsedJson['student']['avatar'],
      ),
      session: SessionModelShort(
        id: parsedJson['session']['id'],
        unit: parsedJson['session']['unit'],
        status: parsedJson['session']['status'],
      ),
      startAt: DateTime(
        parsedJson['startAt'][0],
        parsedJson['startAt'][1],
        parsedJson['startAt'][2],
        parsedJson['startAt'][3],
        parsedJson['startAt'][4],
      ),
      endAt: DateTime(
        parsedJson['endAt'][0],
        parsedJson['endAt'][1],
        parsedJson['endAt'][2],
        parsedJson['endAt'][3],
        parsedJson['endAt'][4],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student': student,
      'session': session,
      'startAt': [
        startAt.year,
        startAt.month,
        startAt.day,
        startAt.hour,
        startAt.minute,
      ],
      'endAt': [
        endAt.year,
        endAt.month,
        endAt.day,
        endAt.hour,
        endAt.minute,
      ],
    };
  }

  @override
  String toString() {
    return '{id: $id, student: $student, session: $session, startAt: $startAt}\n';
  }
}
