class StudentModel {
  final String id;
  final String fullName;
  final int gender;
  final int avatar;
  final double height;
  final DateTime knownFrom;

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
      knownFrom: DateTime(
        parsedJson['knownFrom'][0],
        parsedJson['knownFrom'][1],
        parsedJson['knownFrom'][2],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    List<String> knownFromArr = knownFrom.toString().substring(0, 10).split('-');
    return {
      'id': id,
      'fullName': fullName,
      'gender': gender,
      'avatar': avatar,
      'height': height,
      'knownFrom': [
        int.parse(knownFromArr[0]),
        int.parse(knownFromArr[1]),
        int.parse(knownFromArr[2]),
      ],
    };
  }

  @override
  String toString() {
    return '{id: $id, fullName: $fullName, knownFrom: $knownFrom}';
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