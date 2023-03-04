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
    List<String> startAtArr = startAt.toString().substring(0, 10).split('-');
    List<String> endAtArr = endAt.toString().substring(0, 10).split('-');
    return {
      'id': id,
      'student': student,
      'session': session,
      'startAt': [
        int.parse(startAtArr[0]),
        int.parse(startAtArr[1]),
        int.parse(startAtArr[2]),
      ],
      'endAt': [
        int.parse(endAtArr[0]),
        int.parse(endAtArr[1]),
        int.parse(endAtArr[2]),
      ],
    };
  }

  @override
  String toString() {
    return '{id: $id, student: $student, session: $session, startAt: $startAt}\n';
  }
}
