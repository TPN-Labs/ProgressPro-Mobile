class StudentModel {
  final String id;
  final String fullName;
  final int gender;
  final int totalMeetings;

  StudentModel({
    required this.id,
    required this.fullName,
    required this.gender,
    required this.totalMeetings,
  });

  factory StudentModel.fromJson(Map<String, dynamic> parsedJson) {
    return StudentModel(
      id: parsedJson['id'].toString(),
      fullName: parsedJson['fullName'].toString(),
      gender: parsedJson['gender'],
      totalMeetings: parsedJson['totalMeetings'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'gender': gender,
      'totalMeetings': totalMeetings,
    };
  }

  @override
  String toString() {
    return '{id: $id, fullName: $fullName}';
  }
}

class StudentModelShort {
  final String id;
  final String fullName;
  final int totalMeetings;

  StudentModelShort({
    required this.id,
    required this.fullName,
    required this.totalMeetings,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'totalMeetings': totalMeetings,
    };
  }

  @override
  String toString() {
    return '{id: $id, fullName: $fullName}';
  }
}