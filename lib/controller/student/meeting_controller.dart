// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:progressp/config/constants.dart';
import 'package:progressp/model/student/meeting_model.dart';
import 'package:progressp/model/student/session_model.dart';
import 'package:progressp/model/student/student_model.dart';
import 'package:progressp/widget/snackbar_containers.dart';

class MeetingController extends GetxController {
  Rx<TextEditingController> fullNameController = TextEditingController().obs;
  Rx<TextEditingController> heightController = TextEditingController().obs;
  RxBool isVisible = false.obs;
}

class APIMeetingController {
  List<MeetingModel> getAllMeetings() {
    List allMeetings = GetStorage().read(StorageKeys.allMeetings) ?? List.empty();
    List<MeetingModel> storageMeetings = allMeetings.map((element) => MeetingModel.fromJson(element)).toList();
    storageMeetings.removeWhere((e) => e.session.status > 1);
    return storageMeetings;
  }

  void syncStorage(
    APIMethods method,
    String meetingId,
    DateTime startTime,
    DateTime endTime,
    StudentModelShort studentModelShort,
    SessionModelShort sessionModelShort,
  ) {
    List<MeetingModel> storageMeetings = getAllMeetings();
    switch (method) {
      case APIMethods.create:
        MeetingModel newMeeting = MeetingModel(
          id: meetingId,
          student: studentModelShort,
          session: sessionModelShort,
          startAt: startTime,
          endAt: endTime,
        );
        storageMeetings.add(newMeeting);
        break;
      case APIMethods.update:
        int currentSessionIdx = storageMeetings.indexWhere((meeting) => meeting.id == meetingId);
        storageMeetings[currentSessionIdx] = MeetingModel(
          id: meetingId,
          student: studentModelShort,
          session: sessionModelShort,
          startAt: startTime,
          endAt: endTime,
        );
        break;
      default:
        break;
    }
    GetStorage().remove(StorageKeys.allMeetings);
    GetStorage().write(
      StorageKeys.allMeetings,
      json.decode(json.encode(storageMeetings)),
    );
  }

  void userUpdate(
    BuildContext context,
    String meetingId,
    StudentModelShort student,
    SessionModelShort session,
    DateTime startTime,
    DateTime endTime,
    Function refreshList,
    Function refreshDetails,
  ) async {
    final authKey = GetStorage().read('authKey') ?? '';
    final formInput = <String, dynamic>{
      'id': meetingId,
      'studentId': student.id,
      'sessionId': session.id,
      'startAt': startTime.toIso8601String(),
      'endAt': endTime.toIso8601String(),
    };
    final response = await http.put(
      Uri.parse('${Constants.apiEndpoint}/students_meetings/my'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Device-Type': Platform.isIOS ? 'ios' : 'android',
        'Authorization': 'Bearer $authKey',
      },
      body: jsonEncode(formInput),
    );
    var responseBody = json.decode(response.body);
    if (response.statusCode != 200) {
      showErrorSnackBar(context, responseBody['message']);
    } else {
      Navigator.of(context).pop();
      syncStorage(
        APIMethods.update,
        meetingId,
        startTime,
        endTime,
        student,
        session,
      );
      refreshList();
      refreshDetails();
      showSuccessSnackBar(context, 'Meeting updated successfully');
    }
  }

  void userCreate(
    BuildContext context,
    StudentModelShort student,
    SessionModelShort session,
    DateTime startTime,
    DateTime endTime,
    Function refreshList,
  ) async {
    final authKey = GetStorage().read('authKey') ?? '';
    final formInput = <String, dynamic>{
      'studentId': student.id,
      'sessionId': session.id,
      'startAt': startTime.toIso8601String(),
      'endAt': endTime.toIso8601String(),
    };
    final response = await http.post(
      Uri.parse('${Constants.apiEndpoint}/students_meetings/my'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Device-Type': Platform.isIOS ? 'ios' : 'android',
        'Authorization': 'Bearer $authKey',
      },
      body: jsonEncode(formInput),
    );
    var responseBody = json.decode(response.body);
    if (response.statusCode != 200) {
      showErrorSnackBar(context, responseBody['message']);
    } else {
      Navigator.of(context).pop();
      syncStorage(
        APIMethods.create,
        responseBody['id'],
        startTime,
        endTime,
        student,
        session,
      );
      refreshList();
      showSuccessSnackBar(context, 'Meeting created successfully');
    }
  }

  Future<void> userGetAll() async {
    final authKey = GetStorage().read('authKey') ?? '';
    final response = await http.get(
      Uri.parse('${Constants.apiEndpoint}/students_meetings/my'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Device-Type': Platform.isIOS ? 'ios' : 'android',
        'Authorization': 'Bearer $authKey',
      },
    );
    var responseBody = json.decode(response.body);
    if (response.statusCode != 200) {
      print("eroare");
      print(responseBody['message']);
    } else {
      GetStorage().write(StorageKeys.allMeetings, responseBody);
    }
  }
}
