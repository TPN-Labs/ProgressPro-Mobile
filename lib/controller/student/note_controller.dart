import 'dart:convert';
import 'dart:io';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:progressp/config/body_measurements.dart';
import 'package:progressp/config/constants.dart';
import 'package:progressp/model/student/note_model.dart';
import 'package:progressp/model/student/note_model.dart';
import 'package:progressp/model/student/student_model.dart';
import 'package:progressp/widget/snackbar_containers.dart';

class NoteController extends GetxController {
  Rx<TextEditingController> valueController = TextEditingController().obs;
  RxBool isVisible = false.obs;
}

class APINoteController {

  List<NoteModel> getAllNotes() {
    List allNotes = GetStorage().read(StorageKeys.allNotes) ?? List.empty();
    List<NoteModel> storageNotes = allNotes.map((e) => NoteModel.fromJson(e)).toList();
    return storageNotes;
  }

  List<NoteModel> getAllNotesForStudent(String studentId) {
    List<NoteModel> allNotes = getAllNotes();
    List<NoteModel> notesForStudent = allNotes.where((e) => e.student.id == studentId).toList();
    return notesForStudent..sort((a, b) => b.tookAt.compareTo(a.tookAt));
  }
  
  void syncStorage(
    APIMethods method,
    String noteId,
    StudentModelShort studentModelShort,
    Map<String, dynamic> formInput,
  ) {
    List<NoteModel> storageNotes = getAllNotes();
    List<String> tookAtArr = formInput['tookAt'].split('-');
    switch (method) {
      case APIMethods.create:
        NoteModel newNote = NoteModel(
          id: noteId,
          student: studentModelShort,
          measurementName: formInput['measurementName'],
          measurementValue: formInput['measurementValue'],
          measurementType: BodyMeasurementType.values.firstWhere((element) => element.name == formInput['measurementName']),
          tookAt: DateTime(
            int.parse(tookAtArr[0]),
            int.parse(tookAtArr[1]),
            int.parse(tookAtArr[2]),
          ),
        );
        storageNotes.add(newNote);
        break;
      case APIMethods.update:
        int currentNoteIdx = storageNotes.indexWhere((note) => note.id == noteId);
        storageNotes[currentNoteIdx] = NoteModel(
          id: noteId,
          student: studentModelShort,
          measurementName: formInput['measurementName'],
          measurementValue: formInput['measurementValue'],
          measurementType: BodyMeasurementType.values.firstWhere((element) => element.name == formInput['measurementName']),
          tookAt: DateTime(
            int.parse(tookAtArr[0]),
            int.parse(tookAtArr[1]),
            int.parse(tookAtArr[2]),
          ),
        );
        break;
      default:
        break;
    }
    GetStorage().remove(StorageKeys.allNotes);
    GetStorage().write(
      StorageKeys.allNotes,
      json.decode(json.encode(storageNotes)),
    );
  }

  void userUpdate(
    BuildContext context,
    String noteId,
    StudentModelShort student,
    String name,
    double value,
    String tookAt,
    Function refreshList,
    Function refreshDetails,
  ) async {
    final authKey = GetStorage().read('authKey') ?? '';
    final formInput = <String, dynamic>{
      'id': noteId,
      'studentId': student.id,
      'measurementName': name,
      'measurementValue': value,
      'tookAt': tookAt,
    };
    final response = await http.put(
      Uri.parse('${Constants.apiEndpoint}/students_notes/my'),
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
        noteId,
        student,
        formInput,
      );
      refreshList();
      refreshDetails();
      showSuccessSnackBar(context, 'note updated successfully');
    }
  }

  void userCreate(
    BuildContext context,
    StudentModelShort student,
    String name,
    double value,
    String tookAt,
    Function refreshList,
  ) async {
    final authKey = GetStorage().read('authKey') ?? '';
    final formInput = <String, dynamic>{
      'studentId': student.id,
      'measurementName': name,
      'measurementValue': value,
      'tookAt': tookAt,
    };
    final response = await http.post(
      Uri.parse('${Constants.apiEndpoint}/students_notes/my'),
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
        student,
        formInput,
      );
      refreshList();
      showSuccessSnackBar(context, 'Note created successfully');
    }
  }

  Future<void> userGetAll() async {
    final authKey = GetStorage().read('authKey') ?? '';
    final response = await http.get(
      Uri.parse('${Constants.apiEndpoint}/students_notes/my'),
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
      GetStorage().write(StorageKeys.allNotes, responseBody);
    }
  }
}
