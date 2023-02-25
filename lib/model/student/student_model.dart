class StudentModel {
  final String id;
  final String fullName;
  final int gender;
  final int avatar;
  final double height;
  final String knownFrom;

  StudentModel({
    required this.id,
    required this.fullName,
    required this.gender,
    required this.avatar,
    required this.height,
    required this.knownFrom,
  });

  factory StudentModel.fromJson(Map<String, dynamic> parsedJson) {
    return StudentModel(
      id: parsedJson['id'].toString(),
      fullName: parsedJson['fullName'].toString(),
      gender: parsedJson['gender'],
      avatar: parsedJson['avatar'],
      height: parsedJson['height'],
      knownFrom: parsedJson['meetOn'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'gender': gender,
      'avatar': avatar,
      'height': height,
      'knownFrom': knownFrom,
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

  StudentModelShort({
    required this.id,
    required this.fullName,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
    };
  }

  @override
  String toString() {
    return '{id: $id, fullName: $fullName}';
  }
}