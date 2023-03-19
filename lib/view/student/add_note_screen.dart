import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:progressp/controller/student/note_controller.dart';
import 'package:progressp/model/student/note_model.dart';
import 'package:progressp/config/constants.dart';
import 'package:progressp/config/textstyle.dart';
import 'package:progressp/model/student/student_model.dart';
import 'package:progressp/utils/date_range_picker_style.dart';
import 'package:progressp/widget/custom_button.dart';
import 'package:progressp/widget/custom_textformfield.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AddNoteScreen extends StatefulWidget {
  final BuildContext parentContext;
  final StudentModel student;
  final NoteModel? noteData;
  final Function mainRefreshFunction;
  final Function? secondRefreshFunction;

  const AddNoteScreen(
    this.parentContext,
    this.student,
    this.noteData,
    this.mainRefreshFunction,
    this.secondRefreshFunction, {
    Key? key,
  }) : super(key: key);

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _apiNoteController = APINoteController();
  final _newNoteController = Get.put(NoteController());
  final DateRangePickerStyle _pickerStyle = DateRangePickerStyle();

  late BodyMeasurementType _selectedMeasurement;
  late List<BodyMeasurementType> _allMeasurements;
  int _bodyMeasurement = -1;
  String _noteTookAt = DateTime.now().toString();

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      _noteTookAt = args.value.toString().substring(0, 10);
    });
  }
  
  @override
  void initState() {
    if (widget.noteData != null) {
      _newNoteController.valueController.value.text = widget.noteData!.measurementValue.toString();
      _noteTookAt = widget.noteData!.tookAt.toString().substring(0, 10);
      _bodyMeasurement = BodyMeasurementType.values.firstWhere((element) => element.name == widget.noteData!.measurementName).value;
      _selectedMeasurement = BodyMeasurementType.values.firstWhere((element) => element.name == widget.noteData!.measurementName);
    }
    _allMeasurements = availableMeasurements[widget.student.gender]!;
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
              color: Theme.of(context).textTheme.titleLarge!.color,
            ),
          ),
          title: Text(
            widget.noteData != null ? 'Editeaza notita' : 'Adauga notita',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
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
                            'Tip masuratoare',
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 18),
                          SizedBox(
                            width: Get.width,
                            height: 100,
                            child: Scrollbar(
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  Row(
                                    children: [
                                      for (var i = 0; i < _allMeasurements.length; i++) ...[
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              _bodyMeasurement = i;
                                              _selectedMeasurement = _allMeasurements.elementAt(i);
                                            });
                                          },
                                          child: measurementItem(
                                            context,
                                            _allMeasurements.elementAt(i),
                                            _bodyMeasurement == i,
                                            l10n,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                      ]
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            'Valoare',
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 18),
                          CustomTextFormField(
                            prefix: Padding(
                              padding: const EdgeInsets.only(top: 10, bottom: 10),
                              child: Icon(
                                Icons.electric_meter_outlined,
                                color: Theme.of(context).shadowColor,
                                size: Constants.iconSize,
                              ),
                            ),
                            inputType: TextInputType.number,
                            hintText: 'Valoare masuratoare',
                            limit: [
                              LengthLimitingTextInputFormatter(10),
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9,]'),
                              )
                            ],
                            textEditingController: _newNoteController.valueController.value,
                            capitalization: TextCapitalization.none,
                          ),
                          const SizedBox(height: 18),
                          Text(
                            'Masurat la',
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 18),
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
                                monthViewSettings: _pickerStyle.monthViewSettings(context, WeekStart.monday),
                                monthCellStyle: _pickerStyle.monthCellStyle(context),
                                selectionTextStyle: _pickerStyle.selectionTextStyle(context),
                                onSelectionChanged: _onSelectionChanged,
                                initialSelectedDate: widget.noteData == null
                                    ? DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
                                    : widget.noteData!.tookAt,
                                selectionMode: DateRangePickerSelectionMode.single,
                              ),
                            ),
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
                  title: 'Trimite',
                  type: ButtonChildType.text,
                  showBorder: false,
                  onTap: () {
                    widget.noteData == null
                        ? _apiNoteController.userCreate(
                      context,
                      StudentModelShort(
                        id: widget.student.id,
                        fullName: widget.student.fullName,
                        avatar: widget.student.avatar,
                      ),
                      _selectedMeasurement.name,
                      double.parse(
                        _newNoteController.valueController.value.text,
                      ),
                      _noteTookAt,
                      widget.mainRefreshFunction,
                    )
                        : _apiNoteController.userUpdate(
                      context,
                      widget.noteData!.id,
                      StudentModelShort(
                        id: widget.student!.id,
                        fullName: widget.student!.fullName,
                        avatar: widget.student!.avatar,
                      ),
                      _selectedMeasurement.name,
                      double.parse(
                        _newNoteController.valueController.value.text,
                      ),
                      _noteTookAt,
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
}

Widget measurementItem(
    BuildContext context,
    BodyMeasurementType measurementType,
    bool isSelected,
    AppLocalizations l10n,
    ) {

  String getMeasurementName(int type) {
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

  return Container(
    width: (Get.width - 80) / 3,
    decoration: BoxDecoration(
      color: isSelected != false ? HexColor(AppTheme.primaryColorString).withOpacity(0.5) : Theme.of(context).bottomAppBarTheme.color,
      borderRadius: BorderRadius.circular(100),
      border: Border.all(
        color: Theme.of(context).shadowColor,
        width: 1.5,
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              measurementType.icon,
              color: Theme.of(context).shadowColor,
              size: Constants.iconSize,
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          getMeasurementName(measurementType.value),
          style: Theme.of(context).textTheme.caption!.copyWith(
            fontSize: 14,
            color: isSelected != false ? Colors.white : Theme.of(context).shadowColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}
