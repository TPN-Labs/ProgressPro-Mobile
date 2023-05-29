import 'dart:convert';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:progressp/config/constants.dart';
import 'package:progressp/model/student/meeting_model.dart';
import 'package:progressp/model/student/student_model.dart';
import 'package:progressp/widget/snackbar_containers.dart';

class MeetingController extends GetxController {
  Rx<TextEditingController> fullNameController = TextEditingController().obs;
  Rx<TextEditingController> heightController = TextEditingController().obs;
  RxBool isVisible = false.obs;
}

class APIMeetingController {
  List<MeetingModel> getAllMeetings() {
    List allMeetings =
        GetStorage().read(StorageKeys.allMeetings) ?? List.empty();
    List<MeetingModel> storageMeetings =
        allMeetings.map((element) => MeetingModel.fromJson(element)).toList();
    return storageMeetings;
  }

  MeetingModel? getLatestMeeting(String studentId) {
    List<MeetingModel> allMeetings = getAllMeetings();
    List<MeetingModel> studentMeetings =
        allMeetings.where((e) => e.student.id == studentId).toList();
    studentMeetings.sortBy((element) => element.startAt);
    return studentMeetings.lastOrNull;
  }

  void syncStorage(
    APIMethods method,
    String meetingId,
    bool firstInMonth,
    DateTime startTime,
    DateTime endTime,
    StudentModelShort studentModelShort,
  ) {
    List<MeetingModel> storageMeetings = getAllMeetings();
    switch (method) {
      case APIMethods.create:
        MeetingModel newMeeting = MeetingModel(
          id: meetingId,
          student: studentModelShort,
          firstInMonth: firstInMonth,
          startAt: startTime,
          endAt: endTime,
        );
        storageMeetings.add(newMeeting);
        break;
      case APIMethods.update:
        int currentSessionIdx =
            storageMeetings.indexWhere((meeting) => meeting.id == meetingId);
        storageMeetings[currentSessionIdx] = MeetingModel(
          id: meetingId,
          student: studentModelShort,
          firstInMonth: firstInMonth,
          startAt: startTime,
          endAt: endTime,
        );
        break;
      case APIMethods.delete:
        int currentMeetingIdx = storageMeetings.indexWhere((meeting) => meeting.id == meetingId);
        storageMeetings.removeAt(currentMeetingIdx);
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
    bool firstInMonth,
    DateTime startTime,
    DateTime endTime,
    Function refreshList,
    Function refreshDetails,
  ) async {
    final authKey = GetStorage().read('authKey') ?? '';
    final formInput = <String, dynamic>{
      'id': meetingId,
      'studentId': student.id,
      'firstInMonth': firstInMonth,
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
        firstInMonth,
        startTime,
        endTime,
        student,
      );
      refreshList();
      refreshDetails();
      showSuccessSnackBar(context, 'Meeting updated successfully');
    }
  }

  void userCreate(
    BuildContext context,
    StudentModelShort student,
    bool firstInMonth,
    DateTime startTime,
    DateTime endTime,
    Function refreshList,
  ) async {
    final authKey = GetStorage().read('authKey') ?? '';
    final formInput = <String, dynamic>{
      'studentId': student.id,
      'firstInMonth': firstInMonth,
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
        firstInMonth,
        startTime,
        endTime,
        student,
      );
      refreshList();
      showSuccessSnackBar(context, 'Meeting created successfully');
    }
  }

  void userDelete(
    BuildContext context,
    String studentId,
    String meetingId,
    Function refreshList,
  ) async {
    final authKey = GetStorage().read('authKey') ?? '';
    final formInput = <String, dynamic>{
      'id': meetingId,
      'studentId': studentId,
    };
    final response = await http.delete(
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
      syncStorage(
        APIMethods.delete,
        meetingId,
        false,
        DateTime.now(),
        DateTime.now(),
        StudentModelShort(id: studentId, fullName: '', totalMeetings: 0),
      );
      refreshList();
      showSuccessSnackBar(context, 'Meeting deleted successfully');
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
