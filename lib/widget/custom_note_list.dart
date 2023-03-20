import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progressp/config/textstyle.dart';
import 'package:progressp/config/constants.dart';
import 'package:progressp/model/student/note_model.dart';

Widget noteList(
  BuildContext context,
  NoteModel noteData,
) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Container(
      height: 80,
      width: Get.width,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).shadowColor,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
        color: HexColor(AppTheme.primaryColorString).withOpacity(0.2),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 64,
              width: 70,
              decoration: BoxDecoration(
                color: HexColor(AppTheme.primaryColorString),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    noteData.measurementValue.toString(),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${Constants().convertMonthNumber(noteData.tookAt.month).substring(0, 3)} ${noteData.tookAt.day.toString().padLeft(2, '0')} ${noteData.tookAt.year}',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 20,
                        color: Theme.of(context).shadowColor,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  noteData.measurementName,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 14,
                        color: Theme.of(context).shadowColor,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(width: 50),
            SizedBox(
              height: 64,
              width: 48,
              child: Icon(
                noteData.measurementType.icon,
                color: Theme.of(context).shadowColor,
                size: 36.0,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
