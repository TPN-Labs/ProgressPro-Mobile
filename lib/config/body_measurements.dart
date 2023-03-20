import 'package:flutter/material.dart';
import 'package:progressp/config/textstyle.dart';

enum BodyMeasurementType {
  weight(1),
  waist(2),
  hip(3),
  femur(4),
  arm(5);

  final int value;

  const BodyMeasurementType(this.value);

  IconData get icon => value == 1
      ? Icons.scale
      : value == 2
      ? Icons.sports_bar
      : value == 3
      ? Icons.sports_volleyball
      : value == 4
      ? Icons.roller_skating
      : Icons.sports_tennis;

  Color get color => value == 1
      ? HexColor('#003CBF')
      : value == 2
      ? HexColor('#964826')
      : value == 3
      ? HexColor('#C03F6B')
      : value == 4
      ? HexColor('#23341D')
      : HexColor('#804954');
}

const List<BodyMeasurementType> maleMeasurements = [
  BodyMeasurementType.weight,
  BodyMeasurementType.waist,
  BodyMeasurementType.femur,
  BodyMeasurementType.arm,
];

const List<BodyMeasurementType> femaleMeasurements = [
  BodyMeasurementType.weight,
  BodyMeasurementType.waist,
  BodyMeasurementType.hip,
  BodyMeasurementType.femur,
  BodyMeasurementType.arm,
];

Map<int, List<BodyMeasurementType>> availableMeasurements = {
  1: maleMeasurements,
  2: femaleMeasurements,
  3: femaleMeasurements,
};