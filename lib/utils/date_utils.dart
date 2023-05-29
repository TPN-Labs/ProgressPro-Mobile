import 'package:intl/intl.dart';

String convertDateToString(DateTime date) {
  return DateFormat('dd/MM/yyyy').format(date);
}