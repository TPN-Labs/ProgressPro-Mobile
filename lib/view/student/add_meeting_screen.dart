import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:progressp/controller/student/meeting_controller.dart';
import 'package:progressp/controller/student/session_controller.dart';
import 'package:progressp/model/student/meeting_model.dart';
import 'package:progressp/config/constants.dart';
import 'package:progressp/config/textstyle.dart';
import 'package:progressp/model/student/session_model.dart';
import 'package:progressp/model/student/student_model.dart';
import 'package:progressp/widget/custom_button.dart';
import 'package:progressp/widget/custom_session_picker.dart';
import 'package:progressp/widget/custom_student_picker.dart';
import 'package:progressp/widget/custom_textformfield.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AddMeetingScreen extends StatefulWidget {
  final BuildContext parentContext;
  final MeetingModel? meetingData;
  final Function mainRefreshFunction;
  final Function? secondRefreshFunction;

  const AddMeetingScreen(
    this.parentContext,
    this.meetingData,
    this.mainRefreshFunction,
    this.secondRefreshFunction, {
    Key? key,
  }) : super(key: key);

  @override
  State<AddMeetingScreen> createState() => _AddMeetingScreenState();
}

class _AddMeetingScreenState extends State<AddMeetingScreen> {
  final _apiSessionController = APISessionController();
  final _apiMeetingController = APIMeetingController();

  SessionModel? _selectedSession;

  DateTime? _meetingDate;
  TimeOfDay? _meetingStart;
  TimeOfDay? _meetingEnd;

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      _meetingDate = DateTime(
        int.parse(args.value.toString().substring(0, 4)),
        int.parse(args.value.toString().substring(5, 7)),
        int.parse(args.value.toString().substring(8, 10)),
      );
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

  void _selectEndTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
      context: context,
      initialEntryMode: TimePickerEntryMode.inputOnly,
      initialTime: TimeOfDay(hour: DateTime.now().hour + 1, minute: 0),
    );
    if (newTime != null) {
      setState(() {
        _meetingEnd = newTime;
      });
    }
  }

  @override
  void initState() {
    if (widget.meetingData != null) {
      _selectedSession = _apiSessionController.getById(widget.meetingData!.session.id);
      _meetingStart = TimeOfDay(hour: widget.meetingData!.startAt.hour, minute: widget.meetingData!.startAt.minute);
      _meetingEnd = TimeOfDay(hour: widget.meetingData!.endAt.hour, minute: widget.meetingData!.endAt.minute);
    } else {
      _meetingDate = DateTime.now();
      _meetingStart = TimeOfDay(hour: DateTime.now().hour, minute: 0);
      _meetingEnd = TimeOfDay(hour: DateTime.now().hour + 1, minute: 0);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).bottomAppBarTheme.color,
          elevation: 0,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Theme.of(context).textTheme.headline6!.color,
            ),
          ),
          title: Text(
            widget.meetingData != null ? 'l10n.session_edit_title' : 'l10n.session_create_title',
            style: Theme.of(context).textTheme.headline6!.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ),
        body: Container(
          color: Theme.of(context).bottomAppBarTheme.color,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 28),
              Expanded(
                child: ListView(
                  children: [
                    Padding(
                      padding: Constants.defaultScreenPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sesiune',
                            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                  fontSize: 18,
                                ),
                          ),
                          const SizedBox(height: 18),
                          _selectedSession == null
                              ? Container(
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).selectedRowColor,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Theme.of(context).shadowColor,
                                        blurRadius: 2,
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: InkWell(
                                    focusColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    onTap: () {
                                      setState(() {
                                        _onPressedShowSessionDialog();
                                      });
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 16.0),
                                          child: Text(
                                            'Selecteaza o sesiune',
                                            style: Theme.of(context).textTheme.bodyText2!.copyWith(fontWeight: FontWeight.w400, fontSize: 16),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 16.0),
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                            size: 22,
                                            color: HexColor(AppTheme.primaryColorString),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).selectedRowColor,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Theme.of(context).shadowColor,
                                        blurRadius: 2,
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: InkWell(
                                    focusColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    onTap: () {
                                      setState(() {
                                        _onPressedShowSessionDialog();
                                      });
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 8.0, left: 15.0, top: 8.0),
                                          child: Icon(
                                            Icons.person,
                                            color: Theme.of(Get.context!).textTheme.headline6!.color!,
                                            size: 28,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            '#${_selectedSession!.unit} (${_selectedSession!.student.fullName})',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: const TextStyle(
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 16.0),
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                            size: 22,
                                            color: HexColor(AppTheme.primaryColorString),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                          const SizedBox(height: 18),
                          Text(
                            'Data',
                            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                  fontSize: 18,
                                ),
                          ),
                          const SizedBox(height: 18),
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).selectedRowColor,
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
                                onSelectionChanged: _onSelectionChanged,
                                initialDisplayDate: widget.meetingData == null
                                    ? DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
                                    : DateTime(
                                        widget.meetingData!.startAt.year,
                                        widget.meetingData!.startAt.month,
                                        widget.meetingData!.startAt.day,
                                      ),
                                initialSelectedDate: widget.meetingData == null
                                    ? DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
                                    : DateTime(
                                        widget.meetingData!.startAt.year,
                                        widget.meetingData!.startAt.month,
                                        widget.meetingData!.startAt.day,
                                      ),
                                selectionMode: DateRangePickerSelectionMode.single,
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Ora inceput',
                                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                      fontSize: 18,
                                    ),
                              ),
                              Text(
                                'Ora final',
                                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                      fontSize: 18,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 56,
                                width: Get.width / 2 - 30,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).selectedRowColor,
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
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left: 16.0),
                                              child: Text(
                                                'Selecteaza ora inceput',
                                                style: Theme.of(context).textTheme.bodyText2!.copyWith(fontWeight: FontWeight.w400, fontSize: 16),
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
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(bottom: 8.0, left: 15.0, top: 8.0),
                                              child: Icon(
                                                Icons.access_time,
                                                color: Theme.of(Get.context!).textTheme.headline6!.color!,
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
                                  color: Theme.of(context).selectedRowColor,
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
                                        onTap: _selectEndTime,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(left: 16.0),
                                              child: Text(
                                                'Selecteaza ora final',
                                                style: Theme.of(context).textTheme.bodyText2!.copyWith(fontWeight: FontWeight.w400, fontSize: 16),
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
                                        onTap: _selectEndTime,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(bottom: 8.0, left: 15.0, top: 8.0),
                                              child: Icon(
                                                Icons.access_time,
                                                color: Theme.of(Get.context!).textTheme.headline6!.color!,
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
                          const SizedBox(height: 18),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: CustomButton(
                  title: 'Trimite',
                  type: ButtonChildType.text,
                  onTap: () {
                    widget.meetingData == null
                        ? _apiMeetingController.userCreate(
                            context,
                            _selectedSession!.student,
                            SessionModelShort(
                              id: _selectedSession!.id,
                              unit: _selectedSession!.unit,
                              status: _selectedSession!.status,
                            ),
                            DateTime(_meetingDate!.year, _meetingDate!.month, _meetingDate!.day, _meetingStart!.hour, _meetingStart!.minute),
                            DateTime(_meetingDate!.year, _meetingDate!.month, _meetingDate!.day, _meetingEnd!.hour, _meetingEnd!.minute),
                            widget.mainRefreshFunction,
                          )
                        : _apiMeetingController.userUpdate(
                            context,
                            widget.meetingData!.id,
                            _selectedSession!.student,
                            SessionModelShort(
                              id: _selectedSession!.id,
                              unit: _selectedSession!.unit,
                              status: _selectedSession!.status,
                            ),
                            DateTime(_meetingDate!.year, _meetingDate!.month, _meetingDate!.day, _meetingStart!.hour, _meetingStart!.minute),
                            DateTime(_meetingDate!.year, _meetingDate!.month, _meetingDate!.day, _meetingEnd!.hour, _meetingEnd!.minute),
                            widget.mainRefreshFunction,
                            widget.secondRefreshFunction!,
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

  void _onPressedShowSessionDialog() async {
    final session = await showSessionPickerDialog(
      context,
    );
    if (session != null) {
      setState(() {
        _selectedSession = session;
      });
    }
  }
}
