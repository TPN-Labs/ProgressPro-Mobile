class StudentModel {
  final String id;
  final String fullName;
  final int gender;
  final int avatar;
  final double height;

  StudentModel({
    required this.id,
    required this.fullName,
    required this.gender,
    required this.avatar,
    required this.height,
  });

  factory StudentModel.fromJson(Map<String, dynamic> parsedJson) {
    return StudentModel(
      id: parsedJson['id'].toString(),
      fullName: parsedJson['fullName'].toString(),
      gender: parsedJson['gender'],
      avatar: parsedJson['avatar'],
      height: parsedJson['height'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'gender': gender,
      'avatar': avatar,
      'height': height,
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
  final int avatar;

  StudentModelShort({
    required this.id,
    required this.fullName,
    required this.avatar,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'avatar': avatar,
    };
  }

  @override
  String toString() {
    return '{id: $id, fullName: $fullName}';
  }
}