import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:progressp/config/constants.dart';
import 'package:progressp/config/textstyle.dart';
import 'package:progressp/controller/student/meeting_controller.dart';
import 'package:progressp/controller/student/session_controller.dart';
import 'package:progressp/controller/student/student_controller.dart';
import 'package:progressp/model/student/meeting_model.dart';
import 'package:progressp/model/student/session_model.dart';
import 'package:progressp/model/student/student_model.dart';
import 'package:progressp/view/student/meeting/add_meeting_screen.dart';
import 'package:progressp/view/student/session/add_session_screen.dart';
import 'package:progressp/view/student/view_student_screen.dart';
import 'package:progressp/widget/custom_button.dart';
import 'package:progressp/widget/custom_meeting_list.dart';

class ViewSessionScreen extends StatefulWidget {
  final BuildContext parentContext;
  final Function refreshFunction;
  final SessionModel sessionModel;

  const ViewSessionScreen(
    this.parentContext,
    this.refreshFunction,
    this.sessionModel, {
    Key? key,
  }) : super(key: key);

  @override
  State<ViewSessionScreen> createState() => _ViewSessionScreenState();
}

class _ViewSessionScreenState extends State<ViewSessionScreen> {
  final APIStudentController _apiStudentController = Get.put(APIStudentController());
  final APISessionController _apiSessionController = Get.put(APISessionController());
  final APIMeetingController _apiMeetingController = Get.put(APIMeetingController());

  late SessionModel? _sessionModel;
  late bool _isDeleted = false;
  late List<MeetingModel>? _sessionMeetings;

  void refreshSessionDetails() {
    if (_isDeleted) return;
    List<SessionModel>? allSessions = _apiSessionController.getAllSessions();
    int currentSessionIdx = allSessions.indexWhere((e) => e.id == widget.sessionModel.id);
    setState(() {
      _sessionModel = allSessions[currentSessionIdx];
      _sessionMeetings = getMeetings();
    });
  }

  StudentModel getStudentModel(String studentId) {
    List<StudentModel>? allStudents = _apiStudentController.getAllStudents();
    return allStudents.firstWhere((e) => e.id == studentId);
  }

  String getStatusName(int status, AppLocalizations l10n) {
    switch (status) {
      case 1:
        return l10n.session_status_active;
      case 2:
        return l10n.session_status_paid;
      case 3:
        return l10n.session_status_closed;
      case 4:
        return l10n.session_status_archived;
    }
    return '';
  }

  List<MeetingModel> getMeetings() {
    List<MeetingModel> allMeetings = _apiMeetingController.getAllMeetings();
    allMeetings = allMeetings.where((e) => e.session.id == widget.sessionModel.id).toList();
    return allMeetings..sort((a, b) => b.startAt.toString().compareTo(a.startAt.toString()));
  }

  @override
  void initState() {
    setState(() {
      _sessionModel = null;
      _sessionMeetings = getMeetings();
    });
    refreshSessionDetails();
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
          l10n.session_details_title,
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
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: Get.width / 4 - 15,
                    height: 60,
                    child: CustomButton(
                      icon: Icons.edit,
                      type: ButtonChildType.icon,
                      bgColor: Colors.cyan,
                      showBorder: false,
                      onTap: () {
                        Get.to(
                          () => AddSessionScreen(context, _sessionModel, widget.refreshFunction, refreshSessionDetails),
                          transition: Transition.rightToLeft,
                          duration: const Duration(
                            milliseconds: Constants.transitionDuration,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: Get.width / 4 - 15,
                    height: 60,
                    child: CustomButton(
                      icon: SessionStatus.started.icon,
                      type: ButtonChildType.icon,
                      bgColor: SessionStatus.started.color,
                      showBorder: widget.sessionModel.status == SessionStatus.started.value,
                      onTap: () {
                        if (widget.sessionModel.status != SessionStatus.started.value) {
                          _apiSessionController.userUpdate(
                            context,
                            _sessionModel!.id,
                            _sessionModel!.student,
                            _sessionModel!.meetings,
                            _sessionModel!.price,
                            SessionStatus.started.value,
                            widget.refreshFunction,
                            widget.refreshFunction,
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: Get.width / 4 - 15,
                    height: 60,
                    child: CustomButton(
                      icon: SessionStatus.paid.icon,
                      type: ButtonChildType.icon,
                      bgColor: SessionStatus.paid.color,
                      showBorder: widget.sessionModel.status == SessionStatus.paid.value,
                      onTap: () {
                        if (widget.sessionModel.status != SessionStatus.paid.value) {
                          _apiSessionController.userUpdate(
                            context,
                            _sessionModel!.id,
                            _sessionModel!.student,
                            _sessionModel!.meetings,
                            _sessionModel!.price,
                            SessionStatus.paid.value,
                            widget.refreshFunction,
                            widget.refreshFunction,
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: Get.width / 4 - 15,
                    height: 60,
                    child: CustomButton(
                      icon: SessionStatus.closed.icon,
                      type: ButtonChildType.icon,
                      bgColor: SessionStatus.closed.color,
                      showBorder: widget.sessionModel.status == SessionStatus.closed.value,
                      onTap: () {
                        if (widget.sessionModel.status != SessionStatus.closed.value) {
                          _apiSessionController.userUpdate(
                            context,
                            _sessionModel!.id,
                            _sessionModel!.student,
                            _sessionModel!.meetings,
                            _sessionModel!.price,
                            SessionStatus.closed.value,
                            widget.refreshFunction,
                            widget.refreshFunction,
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
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
                          InkWell(
                            onTap: () {
                              Get.to(
                                () => ViewStudentScreen(
                                  context,
                                  refreshSessionDetails,
                                  getStudentModel(_sessionModel!.student.id),
                                ),
                                transition: Transition.rightToLeft,
                                duration: const Duration(
                                  milliseconds: Constants.transitionDuration,
                                ),
                              );
                            },
                            child: Container(
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
                                    'assets/avatars/avatar_${_sessionModel!.student.avatar % 15}.png',
                                  ),
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
                            'Student',
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          Text(
                            _sessionModel!.student.fullName,
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
                            l10n.session_details_status,
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          Text(
                            getStatusName(_sessionModel!.status, l10n),
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
                            l10n.session_details_name,
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          Text(
                            '${l10n.session_no_2} ${_sessionModel!.unit}',
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
                            l10n.session_modal_price,
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          Text(
                            _sessionModel!.price.toString(),
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
                            l10n.session_modal_meetings,
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          Text(
                            '${_sessionMeetings!.length} / ${_sessionModel!.meetings}',
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
                              () => AddMeetingScreen(context, _sessionMeetings!.elementAt(i), refreshSessionDetails, widget.refreshFunction),
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
