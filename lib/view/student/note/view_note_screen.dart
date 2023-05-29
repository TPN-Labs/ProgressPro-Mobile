import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:get/get.dart';
import 'package:progressp/config/constants.dart';
import 'package:progressp/controller/student/note_controller.dart';
import 'package:progressp/controller/student/student_controller.dart';
import 'package:progressp/model/student/note_model.dart';
import 'package:progressp/model/student/student_model.dart';
import 'package:progressp/view/student/note/add_note_screen.dart';
import 'package:progressp/widget/custom_note_list.dart';

class ViewNoteScreen extends StatefulWidget {
  final BuildContext parentContext;
  final Function refreshFunction;
  final NoteModel noteModel;

  const ViewNoteScreen(
    this.parentContext,
    this.refreshFunction,
    this.noteModel, {
    Key? key,
  }) : super(key: key);

  @override
  State<ViewNoteScreen> createState() => _ViewNoteScreenState();
}

class _ViewNoteScreenState extends State<ViewNoteScreen> {
  final APINoteController _apiNoteController = Get.put(APINoteController());
  final APIStudentController _apiStudentController = Get.put(APIStudentController());

  late NoteModel? _noteModel;
  late bool _isDeleted = false;
  late List<NoteModel>? _allNotes;

  List<NoteModel> getAllNotes() {
    List<NoteModel> allNotes = _apiNoteController.getAllNotesForStudent(widget.noteModel.student.id);
    allNotes = allNotes.where((e) => e.measurementName == widget.noteModel.measurementName).toList();
    return allNotes..sort((a, b) => b.tookAt.toString().compareTo(a.tookAt.toString()));
  }

  StudentModel getStudentModel(String studentId) {
    List<StudentModel>? allStudents = _apiStudentController.getAllStudents();
    return allStudents.firstWhere((e) => e.id == studentId);
  }

  void refreshNoteDetails() {
    if (_isDeleted) return;
    List<NoteModel> allNotes = _apiNoteController.getAllNotesForStudent(widget.noteModel.student.id);
    int currentNoteIdx = allNotes.indexWhere((e) => e.id == widget.noteModel.id);
    setState(() {
      _noteModel = allNotes[currentNoteIdx];
      _allNotes = getAllNotes();
    });
  }

  String getMeasurementName(int type, AppLocalizations l10n) {
    switch (type) {
      case 1:
        return 'Greutate';
      case 2:
        return 'Talie';
      case 3:
        return 'Fesier';
      case 4:
        return 'Femur';
      case 5:
        return 'Brat';
    }
    return '';
  }

  @override
  void initState() {
    setState(() {
      _noteModel = null;
      _allNotes = getAllNotes();
    });
    refreshNoteDetails();
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
          'Statistici',
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
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: SfCartesianChart(
                      enableAxisAnimation: false,
                      plotAreaBorderWidth: 0,
                      margin: const EdgeInsets.only(left: 2, right: 2),
                      primaryYAxis: NumericAxis(
                        desiredIntervals: 2,
                        plotOffset: 20,
                        axisLabelFormatter: (label) {
                          return ChartAxisLabel(
                            label.value.round().toString(),
                            Theme.of(context).textTheme.bodyMedium!.copyWith(
                                fontSize: 14,
                            ),
                          );
                        },
                        majorTickLines: const MajorTickLines(size: 0),
                        minorGridLines: const MinorGridLines(width: 0),
                        majorGridLines: const MajorGridLines(width: 0.2),
                      ),
                      primaryXAxis: DateTimeAxis(
                        desiredIntervals: 1,
                        plotOffset: 20,
                        dateFormat: DateFormat(DateFormat.YEAR_ABBR_MONTH),
                        majorTickLines: const MajorTickLines(size: 0),
                        minorGridLines: const MinorGridLines(width: 0),
                        majorGridLines: const MajorGridLines(width: 0),
                        labelStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontSize: 14,
                          ),
                      ),
                      series: <ChartSeries>[
                        // Renders line chart
                        LineSeries<NoteModel, DateTime>(
                          dataSource: _allNotes!,
                          xValueMapper: (NoteModel note, _) => note.tookAt,
                          yValueMapper: (NoteModel note, _) => note.measurementValue,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: DefaultMargins.smallMargin),
                ],
              ),
              const SizedBox(height: DefaultMargins.smallMargin),
              Expanded(
                flex: 2,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    if (_allNotes != null) ...[
                      for (var i = 0; i < _allNotes!.length; i++)
                        InkWell(
                          onTap: () {
                            Get.to(
                              () => AddNoteScreen(
                                context,
                                getStudentModel(widget.noteModel.student.id),
                                widget.noteModel,
                                refreshNoteDetails,
                                widget.refreshFunction,
                              ),
                              transition: Transition.rightToLeft,
                              duration: const Duration(
                                milliseconds: Constants.transitionDuration,
                              ),
                            );
                          },
                          child: noteList(
                            context,
                            _allNotes!.elementAt(i),
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
