import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:progressp/config/constants.dart';
import 'package:progressp/controller/student/note_controller.dart';
import 'package:progressp/model/student/note_model.dart';
import 'package:progressp/model/student/student_model.dart';
import 'package:progressp/view/student/add_note_screen.dart';
import 'package:progressp/widget/custom_button.dart';
import 'package:progressp/widget/custom_measurement.dart';

class AllNotesScreen extends StatefulWidget {
  final StudentModel studentModel;

  const AllNotesScreen(this.studentModel, {Key? key}) : super(key: key);

  @override
  State<AllNotesScreen> createState() => _AllNotesScreenState();
}

class _AllNotesScreenState extends State<AllNotesScreen> {
  final _apiNotesController = APINoteController();

  Map<BodyMeasurementType, NoteModel> _notesByMeasurement = {};

  bool _areNotesLoaded = false;
  int _allMeasurements = 0;

  NoteModel? getNoteForMeasurement(List<NoteModel> allNotes, BodyMeasurementType measurementType) {
    return allNotes.firstWhereOrNull((e) => e.measurementName.toLowerCase() == measurementType.name);
  }

  Future<void> refreshNoteList() async {
    setState(() {
      _areNotesLoaded = false;
    });
    List<NoteModel> allNotes = _apiNotesController.getAllNotesForStudent(widget.studentModel.id);
    if (allNotes.isEmpty) {
      await _apiNotesController.userGetAll();
      allNotes = _apiNotesController.getAllNotesForStudent(widget.studentModel.id);
    }
    final Map<BodyMeasurementType, NoteModel> notesByMeasurement = {};
    int allMeasurements = 0;
    for (var e in availableMeasurements[widget.studentModel.gender]!) {
      NoteModel? note = getNoteForMeasurement(allNotes, e);
      notesByMeasurement[e] = note ??
          NoteModel(
            id: 'id',
            measurementName: '',
            measurementValue: -13,
            tookAt: DateTime(1970, 01, 01),
            student: StudentModelShort(id: 'id', fullName: 'No Model', avatar: 0),
          );
      if (note != null) {
        allMeasurements = allMeasurements + 1;
      }
    }
    setState(() {
      _notesByMeasurement = notesByMeasurement;
      _areNotesLoaded = true;
      _allMeasurements = allMeasurements;
    });
  }

  @override
  void initState() {
    refreshNoteList();
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
          "Toate notitele",
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
          textAlign: TextAlign.center,
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: Get.width / 3,
                    child: CustomButton(
                      title: 'Adauga',
                      type: ButtonChildType.text,
                      showBorder: false,
                      onTap: () {
                        Get.to(
                          () => AddNoteScreen(
                            context,
                            widget.studentModel,
                            null,
                            refreshNoteList,
                            null,
                          ),
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
              const SizedBox(height: 10),
              if (_areNotesLoaded == true) ...[
                if (_allMeasurements > 0) ...[
                  Expanded(
                    child: RefreshIndicator(
                      backgroundColor: Theme.of(context).bottomAppBarTheme.color,
                      onRefresh: refreshNoteList,
                      child: ListView(
                        physics: const ClampingScrollPhysics(),
                        padding: EdgeInsets.zero,
                        children: [
                          const SizedBox(height: 5),
                          for (var i = 0; i < _notesByMeasurement.keys.length; i++) ...[
                            if (_notesByMeasurement[_notesByMeasurement.keys.elementAt(i)]!.measurementValue != -13) ...[
                              measurementContainer(
                                context,
                                _notesByMeasurement.keys.elementAt(i),
                                _notesByMeasurement.keys.elementAt(i).name.capitalize!,
                                _notesByMeasurement[_notesByMeasurement.keys.elementAt(i)]!.measurementValue.toString(),
                                _notesByMeasurement[_notesByMeasurement.keys.elementAt(i)]!.tookAt.day.toString(),
                                Constants()
                                    .convertMonthNumber(_notesByMeasurement[_notesByMeasurement.keys.elementAt(i)]!.tookAt.month)
                                    .capitalizeFirst!
                                    .substring(0, 3),
                              ),
                              const SizedBox(height: 15),
                            ]
                          ],
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  SizedBox(
                    height: Get.height - 350,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Card(
                          elevation: 0,
                          child: Container(
                            height: 150,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              border: Border.all(
                                color: Theme.of(context).shadowColor,
                                width: 3,
                              ),
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 50, right: 50),
                                child: Text(
                                  'Momentan nu ai introdus masuratori, acestea vor aparea aici pe masura ce sunt introduse',
                                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]
              ] else ...[
                SizedBox(
                  height: Get.height - 350,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SpinKitWave(
                        color: Theme.of(context).shadowColor,
                        size: 50.0,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
