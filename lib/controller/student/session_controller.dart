// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:progressp/config/constants.dart';
import 'package:progressp/model/student/session_model.dart';
import 'package:progressp/model/student/student_model.dart';
import 'package:progressp/widget/snackbar_containers.dart';

class SessionController extends GetxController {
  Rx<TextEditingController> meetingsController = TextEditingController().obs;
  Rx<TextEditingController> priceController = TextEditingController().obs;
  RxBool isVisible = false.obs;
}

class APISessionController {
  SessionModel getById(String sessionId) {
    List<SessionModel> storageSessions = getAllSessions();
    return storageSessions.where((e) => e.id == sessionId).first;
  }

  List<SessionModel> getAllSessions() {
    List storageSessions = GetStorage().read(StorageKeys.allSessions) ?? List.empty();
    return storageSessions.map((element) => SessionModel.fromJson(element)).toList();
  }

  void syncStorage(
      APIMethods method,
      String sessionId,
      int unit,
      int status,
      StudentModelShort studentModelShort,
      Map<String, dynamic> formInput,
      ) {
    List<SessionModel> storageSessions = getAllSessions();
    switch (method) {
      case APIMethods.create:
        SessionModel newSession = SessionModel(
          id: sessionId,
          status: status,
          statusEnum: SessionStatus.values.firstWhere((e) => e.value == status),
          unit: unit,
          meetings: formInput['meetings'],
          price: formInput['price'], 
          student: studentModelShort,
        );
        storageSessions.add(newSession);
        break;
      case APIMethods.update:
        int currentSessionIdx = storageSessions.indexWhere((session) => session.id == sessionId);
        storageSessions[currentSessionIdx] = SessionModel(
          id: sessionId,
          status: status,
          statusEnum: SessionStatus.values.firstWhere((e) => e.value == status),
          unit: unit,
          meetings: formInput['meetings'],
          price: formInput['price'],
          student: studentModelShort,
        );
        break;
      default:
        break;
    }
    GetStorage().remove(StorageKeys.allSessions);
    GetStorage().write(
      StorageKeys.allSessions,
      json.decode(json.encode(storageSessions)),
    );
  }
  
  void userUpdate(
      BuildContext context,
      String sessionId,
      StudentModelShort student,
      int meetings,
      int price,
      int status,
      Function refreshList,
      Function refreshDetails,
      ) async {
    final authKey = GetStorage().read('authKey') ?? '';
    final formInput = <String, dynamic>{
      'id': sessionId,
      'studentId': student.id,
      'status': status,
      'meetings': meetings,
      'price': price,
    };
    final response = await http.put(
      Uri.parse('${Constants.apiEndpoint}/students_sessions/my'),
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
        responseBody['id'],
        responseBody['unit'],
        responseBody['status'],
        student,
        formInput,
      );
      refreshList();
      refreshDetails();
      showSuccessSnackBar(context, 'Session updated successfully');
    }
  }

  void userCreate(
      BuildContext context,
      StudentModelShort student,
      int meetings,
      int price,
      Function refreshList,
      ) async {
    final authKey = GetStorage().read('authKey') ?? '';
    final formInput = <String, dynamic>{
      'studentId': student.id,
      'meetings': meetings,
      'price': price,
    };
    final response = await http.post(
      Uri.parse('${Constants.apiEndpoint}/students_sessions/my'),
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
        responseBody['unit'],
        responseBody['status'],
        student,
        formInput,
      );
      refreshList();
      showSuccessSnackBar(context, 'Session created successfully');
    }
  }

  void userGetAll() async {
    final authKey = GetStorage().read('authKey') ?? '';
    final response = await http.get(
      Uri.parse('${Constants.apiEndpoint}/students_sessions/my'),
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
      GetStorage().write(StorageKeys.allSessions, responseBody);
    }
  }
}
