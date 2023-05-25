import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:progressp/config/constants.dart';
import 'package:progressp/config/textstyle.dart';
import 'package:progressp/controller/student/meeting_controller.dart';
import 'package:progressp/controller/student/student_controller.dart';
import 'package:progressp/model/student/meeting_model.dart';
import 'package:progressp/model/student/student_model.dart';
import 'package:progressp/utils/date_range_picker_style.dart';
import 'package:progressp/view/student/meeting/add_meeting_screen.dart';
import 'package:progressp/view/student/add_student_screen.dart';
import 'package:progressp/view/student/note/all_notes_screen.dart';
import 'package:progressp/widget/custom_button.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ViewStudentScreen extends StatefulWidget {
  final BuildContext parentContext;
  final Function? refreshFunction;
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
  final DateRangePickerStyle _pickerStyle = DateRangePickerStyle();

  late StudentModel? _studentModel;
  late List<MeetingModel>? _sessionMeetings;
  late bool _isDeleted = false;

  DateTime? _meetingDate;
  TimeOfDay? _meetingStart;
  TimeOfDay? _meetingEnd;

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
    int currentStudentIdx = allStudents
        .indexWhere((student) => student.id == widget.studentModel.id);
    setState(() {
      _sessionMeetings = getMeetings();
      _studentModel = allStudents[currentStudentIdx];
    });
  }

  void _selectStartTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
      context: context,
      initialEntryMode: TimePickerEntryMode.inputOnly,
      initialTime: TimeOfDay(hour: DateTime.now().hour, minute: 0),
    );
    if (newTime != null) {
      setState(() {
        _meetingStart = newTime;
      });
    }
  }

  void _selectStopTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
      context: context,
      initialEntryMode: TimePickerEntryMode.inputOnly,
      initialTime: TimeOfDay(hour: DateTime.now().add(const Duration(hours: 1)).hour, minute: 0),
    );
    if (newTime != null) {
      setState(() {
        _meetingEnd = newTime;
      });
    }
  }

  List<DateTime> _getSelectedDateFromSelection(List<DateTime> selectedDates) {
    List<DateTime> initialDates = _sessionMeetings!.map((e) => e.startAt).toList();
    return selectedDates.where((e) => !initialDates.contains(e)).toList();
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    List<DateTime> selectedDates = _getSelectedDateFromSelection(args.value);
    print(selectedDates);
    if(selectedDates.isNotEmpty) {
      setState(() {
        _meetingDate = DateTime(
          int.parse(selectedDates[0].toString().substring(0, 4)),
          int.parse(selectedDates[0].toString().substring(5, 7)),
          int.parse(selectedDates[0].toString().substring(8, 10)),
        );
      });
    }
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
                    width: Get.width / 2 - 20,
                    child: CustomButton(
                      type: ButtonChildType.text,
                      bgColor: Colors.green,
                      showBorder: false,
                      title: l10n.student_details_add_note,
                      onTap: () {
                        Get.to(
                          () => AllNotesScreen(_studentModel!),
                          transition: Transition.rightToLeft,
                          duration: const Duration(
                            milliseconds: Constants.transitionDuration,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: Get.width / 2 - 20,
                    child: CustomButton(
                      icon: Icons.note,
                      type: ButtonChildType.text,
                      bgColor: Colors.teal,
                      showBorder: false,
                      title: l10n.student_details_edit,
                      onTap: () {
                        Get.to(
                              () => AddStudentScreen(
                            context,
                            _studentModel,
                            widget.refreshFunction!,
                            refreshStudentDetails,
                          ),
                          transition: Transition.rightToLeft,
                          duration: const Duration(milliseconds: Constants.transitionDuration),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: Get.width / 2 - 20,
                    child: CustomButton(
                      icon: Icons.delete,
                      type: ButtonChildType.text,
                      bgColor: Colors.red,
                      showBorder: false,
                      title: l10n.student_details_delete,
                      onTap: () {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext contextDialog) {
                            return AlertDialog(
                              title: Text(l10n.student_details_delete_title),
                              icon: const Icon(Icons.warning_amber_rounded),
                              backgroundColor: Theme.of(contextDialog)
                                  .appBarTheme
                                  .backgroundColor,
                              content: SingleChildScrollView(
                                child: Text(
                                  l10n.student_details_delete_body,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child:
                                  Text(l10n.student_details_delete_close),
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
                                      widget.refreshFunction!,
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
                  color:
                      HexColor(AppTheme.primaryColorString).withOpacity(0.75),
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
                                  color: Theme.of(context)
                                      .bottomAppBarTheme
                                      .color!,
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
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                          ),
                          Text(
                            _studentModel!.fullName,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontSize: 20,
                                  color: Colors.white,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 5, right: 5, top: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).shadowColor,
                                  blurRadius: 2,
                                ),
                              ],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: SfDateRangePicker(
                                headerStyle: _pickerStyle.headerStyle(context),
                                monthViewSettings:
                                    _pickerStyle.monthViewSettings(
                                  context,
                                  WeekStart.monday,
                                ),
                                monthCellStyle: _pickerStyle.monthCellStyle(context),
                                selectionTextStyle: _pickerStyle.selectionTextStyle(context),
                                onSelectionChanged: _onSelectionChanged,
                                selectionMode: DateRangePickerSelectionMode.multiple,
                                initialSelectedDates: _sessionMeetings?.map((e) => e.startAt).toList(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 56,
                                width: Get.width / 2 - 30,
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context).shadowColor,
                                      blurRadius: 2,
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: _meetingStart == null
                                    ? InkWell(
                                        focusColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        splashColor: Colors.transparent,
                                        onTap: _selectStartTime,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 16.0,
                                              ),
                                              child: Text(
                                                'Start',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 16,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : InkWell(
                                        focusColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        splashColor: Colors.transparent,
                                        onTap: _selectStartTime,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 8.0,
                                                left: 15.0,
                                                top: 8.0,
                                              ),
                                              child: Icon(
                                                Icons.access_time,
                                                color: Theme.of(Get.context!)
                                                    .textTheme
                                                    .titleLarge!
                                                    .color!,
                                                size: 28,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                '${_meetingStart!.hour.toString().padLeft(2, '0')}:${_meetingStart!.minute.toString().padLeft(2, '0')}',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                              ),
                              Container(
                                height: 56,
                                width: Get.width / 2 - 30,
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context).shadowColor,
                                      blurRadius: 2,
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: _meetingEnd == null
                                    ? InkWell(
                                        focusColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        splashColor: Colors.transparent,
                                        onTap: _selectStopTime,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 16.0,
                                              ),
                                              child: Text(
                                                'Final',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 16,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : InkWell(
                                        focusColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        splashColor: Colors.transparent,
                                        onTap: _selectStopTime,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 8.0,
                                                left: 15.0,
                                                top: 8.0,
                                              ),
                                              child: Icon(
                                                Icons.access_time,
                                                color: Theme.of(Get.context!)
                                                    .textTheme
                                                    .titleLarge!
                                                    .color!,
                                                size: 28,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                '${_meetingEnd!.hour.toString().padLeft(2, '0')}:${_meetingEnd!.minute.toString().padLeft(2, '0')}',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: CustomButton(
                  title: l10n.meeting_modal_send,
                  type: ButtonChildType.text,
                  showBorder: false,
                  onTap: () {
                    _apiMeetingController.userCreate(
                      context,
                      StudentModelShort(
                        id: _studentModel!.id,
                        fullName: _studentModel!.fullName,
                        avatar: _studentModel!.avatar,
                      ),
                      false,
                      DateTime(_meetingDate!.year, _meetingDate!.month, _meetingDate!.day, _meetingStart!.hour, _meetingStart!.minute),
                      DateTime(_meetingDate!.year, _meetingDate!.month, _meetingDate!.day, _meetingEnd!.hour, _meetingEnd!.minute),
                      widget.refreshFunction!,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
