import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:progressp/config/constants.dart';
import 'package:progressp/config/textstyle.dart';
import 'package:progressp/controller/student/meeting_controller.dart';
import 'package:progressp/controller/student/student_controller.dart';
import 'package:progressp/model/student/meeting_model.dart';
import 'package:progressp/model/student/student_model.dart';
import 'package:progressp/view/student/meeting/add_meeting_screen.dart';
import 'package:progressp/view/student/add_student_screen.dart';
import 'package:progressp/view/student/note/all_notes_screen.dart';
import 'package:progressp/widget/custom_button.dart';
import 'package:progressp/widget/custom_meeting_list.dart';

class ViewStudentScreen extends StatefulWidget {
  final BuildContext parentContext;
  final Function refreshFunction;
  final StudentModel studentModel;

  const ViewStudentScreen(
    this.parentContext,
    this.refreshFunction,
    this.studentModel, {
    Key? key,
  }) : super(key: key);

  @override
  State<ViewStudentScreen> createState() => _ViewStudentScreenState();
}

class _ViewStudentScreenState extends State<ViewStudentScreen> {
  final APIStudentController _apiStudentController = Get.put(APIStudentController());
  final APIMeetingController _apiMeetingController = Get.put(APIMeetingController());

  late StudentModel? _studentModel;
  late List<MeetingModel>? _sessionMeetings;
  late bool _isDeleted = false;

  String genderToString(int gender) {
    switch (gender) {
      case 1:
        return 'male';
      case 2:
        return 'female';
      case 3:
        return 'other';
    }
    return 'n/a';
  }

  void refreshStudentDetails() {
    if (_isDeleted) return;
    List<StudentModel>? allStudents = _apiStudentController.getAllStudents();
    int currentStudentIdx = allStudents.indexWhere((student) => student.id == widget.studentModel.id);
    setState(() {
      _sessionMeetings = getMeetings();
      _studentModel = allStudents[currentStudentIdx];
    });
  }

  List<MeetingModel> getMeetings() {
    List<MeetingModel> allMeetings = _apiMeetingController.getAllMeetings();
    allMeetings = allMeetings.where((e) => e.student.id == widget.studentModel.id).toList();
    return allMeetings..sort((a, b) => b.startAt.toString().compareTo(a.startAt.toString()));
  }

  @override
  void initState() {
    setState(() {
      _sessionMeetings = getMeetings();
      _studentModel = null;
    });
    refreshStudentDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).bottomAppBarTheme.color,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Theme.of(context).textTheme.titleLarge!.color,
          ),
        ),
        title: Text(
          l10n.student_details_title,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
        ),
      ),
      body: Container(
        color: Theme.of(context).bottomAppBarTheme.color,
        child: Padding(
          padding: Constants.defaultScreenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: Get.width / 3 - 20,
                    child: CustomButton(
                      icon: Icons.note,
                      type: ButtonChildType.icon,
                      bgColor: Colors.green,
                      showBorder: false,
                      onTap: () {
                        Get.to(
                          () => AllNotesScreen(_studentModel!),
                          transition: Transition.rightToLeft,
                          duration: const Duration(milliseconds: Constants.transitionDuration),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: Get.width / 3 - 20,
                    child: CustomButton(
                      icon: Icons.edit,
                      type: ButtonChildType.icon,
                      bgColor: Colors.cyan,
                      showBorder: false,
                      onTap: () {
                        Get.to(
                          () => AddStudentScreen(
                            context,
                            _studentModel,
                            widget.refreshFunction,
                            refreshStudentDetails,
                          ),
                          transition: Transition.rightToLeft,
                          duration: const Duration(
                            milliseconds: Constants.transitionDuration,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: Get.width / 3 - 20,
                    child: CustomButton(
                      icon: Icons.delete,
                      type: ButtonChildType.icon,
                      bgColor: Colors.red,
                      showBorder: false,
                      onTap: () {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext contextDialog) {
                            return AlertDialog(
                              title: Text(l10n.student_details_delete_title),
                              icon: const Icon(Icons.warning_amber_rounded),
                              backgroundColor: Theme.of(contextDialog).appBarTheme.backgroundColor,
                              content: SingleChildScrollView(
                                child: Text(
                                  l10n.student_details_delete_body,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: Text(l10n.student_details_delete_close),
                                  onPressed: () {
                                    Navigator.of(contextDialog).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text(
                                    l10n.student_details_delete_confirm,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                  onPressed: () {
                                    _apiStudentController.userDelete(
                                      widget.parentContext,
                                      _studentModel!.id,
                                      widget.refreshFunction,
                                    );
                                    Navigator.of(contextDialog).pop();
                                    Navigator.of(context).pop();
                                    setState(() {
                                      _isDeleted = true;
                                    });
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: HexColor(AppTheme.primaryColorString).withOpacity(0.75),
                  border: Border.all(
                    color: Theme.of(context).shadowColor,
                    width: 3,
                  ),
                ),
                child: Padding(
                  padding: Constants.defaultScreenPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).shadowColor,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).bottomAppBarTheme.color!,
                                  blurRadius: 2,
                                ),
                              ],
                              borderRadius: BorderRadius.circular(32),
                              image: DecorationImage(
                                scale: 8,
                                image: AssetImage(
                                  'assets/avatars/avatar_${_studentModel!.avatar % 15}.png',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.student_modal_fullname,
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          Text(
                            _studentModel!.fullName,
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.student_modal_gender,
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          Text(
                            genderToString(_studentModel!.gender),
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.student_modal_height,
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          Text(
                            _studentModel!.height.toString(),
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                flex: 2,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    if (_sessionMeetings != null) ...[
                      for (var i = 0; i < _sessionMeetings!.length; i++)
                        InkWell(
                          onTap: () {
                            Get.to(
                              () => AddMeetingScreen(context, _sessionMeetings!.elementAt(i), refreshStudentDetails, widget.refreshFunction),
                              transition: Transition.rightToLeft,
                              duration: const Duration(
                                milliseconds: Constants.transitionDuration,
                              ),
                            );
                          },
                          child: meetingList(
                            context,
                            _sessionMeetings!.elementAt(i),
                            false,
                          ),
                        ),
                    ],
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
