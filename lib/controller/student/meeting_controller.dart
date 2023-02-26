// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

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
    List storageMeetings = GetStorage().read(StorageKeys.allMeetings) ?? List.empty();
    return storageMeetings.map((element) => MeetingModel.fromJson(element)).toList();
  }

  void syncStorage(
    APIMethods method,
    String homeId, {
    String? name,
    String? currencyCode,
    String? ownerId,
  }) {
    List<MeetingModel> storageMeetings = getAllMeetings();
    /*if (method == APIMethods.update) {
      int currentHomeIdx = storageStudents.indexWhere((home) => home.id == homeId);
      storageStudents[currentHomeIdx] = StudentModel(
        id: homeId,
        ownerId: storageStudents[currentHomeIdx].ownerId,
        name: name!,
        currencyCode: currencyCode!,
        users: [],
      );
    } else if (method == APIMethods.delete) {
      int currentHomeIdx = storageStudents.indexWhere((home) => home.id == homeId);
      storageStudents.removeAt(currentHomeIdx);
    } else if (method == APIMethods.create) {
      StudentModel newHome = StudentModel(
        id: homeId,
        ownerId: ownerId!,
        name: name!,
        currencyCode: currencyCode!,
        users: [],
      );
      storageStudents.add(newHome);
    }

    GetStorage().remove(StorageKeys.userHomesOwned);
    GetStorage().write(
      StorageKeys.userHomesOwned,
      json.decode(json.encode(storageStudents)),
    );*/
  }

  void userGetAll() async {
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

  void userUpdate(
    BuildContext context,
    String id,
    String name,
    String currencyCode,
    Function refreshList,
  ) async {
    final authKey = GetStorage().read('authKey') ?? '';
    final response = await http.put(
      Uri.parse('${Constants.apiEndpoint}/homes/my'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Device-Type': Platform.isIOS ? 'ios' : 'android',
        'Authorization': 'Bearer $authKey',
      },
      body: jsonEncode(
        <String, String>{
          'id': id,
          'name': name,
          'currencyCode': currencyCode,
        },
      ),
    );
    var responseBody = json.decode(response.body);
    if (response.statusCode != 201) {
      showErrorSnackBar(context, responseBody['message']);
    } else {
      Navigator.of(context).pop();
      syncStorage(
        APIMethods.update,
        id,
        name: name,
        currencyCode: currencyCode,
      );
      refreshList();
      showSuccessSnackBar(context, 'House updated successfully');
    }
  }

  void userDelete(
    BuildContext context,
    String id,
    Function refreshList,
  ) async {
    final authKey = GetStorage().read('authKey') ?? '';
    final response = await http.delete(
      Uri.parse('${Constants.apiEndpoint}/homes/my/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Device-Type': Platform.isIOS ? 'ios' : 'android',
        'Authorization': 'Bearer $authKey',
      },
    );
    var responseBody = json.decode(response.body);
    if (response.statusCode != 200) {
      showErrorSnackBar(context, responseBody['message']);
    } else {
      syncStorage(
        APIMethods.delete,
        id,
      );
      refreshList();
      showSuccessSnackBar(context, 'House deleted successfully');
    }
  }

  void userCreate(
    BuildContext context,
    String fullName,
    int gender,
    double height,
    String knownFrom,
    Function refreshList,
  ) async {
    final authKey = GetStorage().read('authKey') ?? '';
    final response = await http.post(
      Uri.parse('${Constants.apiEndpoint}/students/my'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Device-Type': Platform.isIOS ? 'ios' : 'android',
        'Authorization': 'Bearer $authKey',
      },
      body: jsonEncode(
        <String, dynamic>{
          'fullName': fullName,
          'gender': gender,
          'height': height,
          'knownFrom': knownFrom,
        },
      ),
    );
    var responseBody = json.decode(response.body);
    if (response.statusCode != 200) {
      showErrorSnackBar(context, responseBody['message']);
    } else {
      Navigator.of(context).pop();
      /*syncStorageForHome(
        APIMethods.create,
        responseBody['id'],
        name: name,
        currencyCode: currencyCode,
        ownerId: authKey,
      );
      refreshList();*/
      showSuccessSnackBar(context, 'Student created successfully');
    }
  }
}
