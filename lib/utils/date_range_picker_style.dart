import 'package:flutter/material.dart';
import 'package:progressp/config/constants.dart';
import 'package:progressp/config/textstyle.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DateRangePickerStyle {
  DateRangePickerHeaderStyle headerStyle(BuildContext context) {
    return DateRangePickerHeaderStyle(
        textAlign: TextAlign.left,
        textStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 15,
          color: Theme.of(context).shadowColor,
        ));
  }

  DateRangePickerMonthViewSettings monthViewSettings(BuildContext context, WeekStart weekStart) {
    return DateRangePickerMonthViewSettings(
      firstDayOfWeek: weekStart == WeekStart.monday ? 1 : 7,
      showTrailingAndLeadingDates: true,
      enableSwipeSelection: false,
      viewHeaderStyle: DateRangePickerViewHeaderStyle(
        textStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 15,
          color: Theme.of(context).shadowColor,
        ),
      ),
    );
  }

  DateRangePickerMonthCellStyle monthCellStyle(BuildContext context) {
    TextStyle otherMonthTextStyle = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 15,
      color: Theme.of(context).shadowColor.withOpacity(0.4),
    );
    BoxDecoration otherMonthBoxDecoration = BoxDecoration(
      color: Theme.of(context).colorScheme.background.withOpacity(0.4),
      border: Border.all(
        width: 2,
        color: Theme.of(context).shadowColor.withOpacity(0.4),
      ),
      shape: BoxShape.circle,
    );
    TextStyle disabledMonthTextStyle = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 10,
      color: Theme.of(context).shadowColor.withOpacity(0.1),
    );
    BoxDecoration disabledMonthBoxDecoration = BoxDecoration(
      color: Theme.of(context).colorScheme.background.withOpacity(0.1),
      border: Border.all(
        width: 2,
        color: Theme.of(context).shadowColor.withOpacity(0.1),
      ),
      shape: BoxShape.circle,
    );

    return DateRangePickerMonthCellStyle(
      cellDecoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background.withOpacity(0.9),
        border: Border.all(
          width: 2,
          color: Theme.of(context).shadowColor.withOpacity(0.5),
        ),
        shape: BoxShape.circle,
      ),
      textStyle: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 15,
        color: Theme.of(context).textTheme.headline6!.color,
      ),
      todayTextStyle: TextStyle(
        fontStyle: FontStyle.italic,
        fontSize: 15,
        fontWeight: FontWeight.w800,
        color: Theme.of(context).shadowColor,
      ),
      todayCellDecoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background.withOpacity(0.9),
        border: Border.all(
          width: 4,
          color: HexColor(AppTheme.primaryColorString!),
        ),
        shape: BoxShape.circle,
      ),
      leadingDatesTextStyle: otherMonthTextStyle,
      leadingDatesDecoration: otherMonthBoxDecoration,
      trailingDatesTextStyle: otherMonthTextStyle,
      trailingDatesDecoration: otherMonthBoxDecoration,
      disabledDatesDecoration: disabledMonthBoxDecoration,
      disabledDatesTextStyle: disabledMonthTextStyle,
    );
  }

  DateRangePickerYearCellStyle yearCellStyle(BuildContext context) {
    TextStyle otherMonthTextStyle = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 18,
      color: Theme.of(context).shadowColor.withOpacity(0.9),
    );
    BoxDecoration otherMonthBoxDecoration = BoxDecoration(
      color: Theme.of(context).colorScheme.background,
      border: Border.all(
        width: 2,
        color: Theme.of(context).shadowColor.withOpacity(0.5),
      ),
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.circular(64),
    );
    TextStyle disabledMonthTextStyle = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 18,
      color: Theme.of(context).shadowColor.withOpacity(0.3),
    );
    BoxDecoration disabledMonthBoxDecoration = BoxDecoration(
      color: Theme.of(context).backgroundColor,
      border: Border.all(
        width: 2,
        color: Theme.of(context).shadowColor.withOpacity(0.2),
      ),
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.circular(64),
    );

    return DateRangePickerYearCellStyle(
      todayCellDecoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background.withOpacity(0.9),
        border: Border.all(
          width: 2,
          color: Theme.of(context).shadowColor.withOpacity(0.5),
        ),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(64),
      ),
      todayTextStyle: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 18,
        color: Theme.of(context).textTheme.headline6!.color,
      ),
      cellDecoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background.withOpacity(0.9),
        border: Border.all(
          width: 2,
          color: Theme.of(context).shadowColor.withOpacity(0.5),
        ),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(64),
      ),
      textStyle: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 18,
        color: Theme.of(context).textTheme.headline6!.color,
      ),
      disabledDatesDecoration: disabledMonthBoxDecoration,
      disabledDatesTextStyle: disabledMonthTextStyle,
      leadingDatesDecoration: otherMonthBoxDecoration,
      leadingDatesTextStyle: otherMonthTextStyle,
    );
  }

  TextStyle selectionTextStyle(BuildContext context) {
    return const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    );
  }

  TextStyle rangeTextStyle(BuildContext context) {
    return TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      color: Theme.of(context).shadowColor,
    );
  }
}