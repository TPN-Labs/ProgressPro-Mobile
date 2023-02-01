import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progressp/controller/student/student_controller.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:progressp/config/constants.dart';
import 'package:progressp/config/textstyle.dart';
import 'package:progressp/widget/custom_button.dart';
import 'package:progressp/widget/custom_textformfield.dart';

class AddStudentScreen extends StatefulWidget {
  final BuildContext parentContext;
  final Function refreshFunction;

  const AddStudentScreen(this.parentContext, this.refreshFunction, {Key? key}) : super(key: key);

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _apiStudentController = APIStudentController();
  final _newStudentController = Get.put(StudentController());

  int _studentGender = 0;
  String _studentMeetOn = DateTime.now().toString();

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      _studentMeetOn = args.value.toString().substring(0, 10);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).bottomAppBarColor,
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
            'Add a new student',
            style: Theme.of(context).textTheme.headline6!.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 28),
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Student fullname',
                          style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                fontSize: 18,
                              ),
                        ),
                        const SizedBox(height: 18),
                        CustomTextFormField(
                          prefix: Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: Icon(
                              Icons.person,
                              color: Theme.of(context).shadowColor,
                              size: Constants.iconSize,
                            ),
                          ),
                          hintText: 'Full name',
                          textEditingController: _newStudentController.fullNameController.value,
                          capitalization: TextCapitalization.none,
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'Student height',
                          style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                fontSize: 18,
                              ),
                        ),
                        const SizedBox(height: 18),
                        CustomTextFormField(
                          prefix: Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: Icon(
                              Icons.height,
                              color: Theme.of(context).shadowColor,
                              size: Constants.iconSize,
                            ),
                          ),
                          inputType: const TextInputType.numberWithOptions(
                            signed: false,
                            decimal: true,
                          ),
                          hintText: 'Student height (in meters)',
                          textEditingController: _newStudentController.heightController.value,
                          capitalization: TextCapitalization.none,
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'Gender',
                          style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                fontSize: 18,
                              ),
                        ),
                        const SizedBox(height: 18),
                        SizedBox(
                          width: Get.width,
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _studentGender = 1;
                                  });
                                },
                                child: genderContainer(
                                  context,
                                  'Male',
                                  Icon(
                                    Icons.male,
                                    color: _studentGender == 1 ? Theme.of(context).bottomAppBarColor : Theme.of(context).textTheme.headline6!.color,
                                    size: 36,
                                  ),
                                  _studentGender == 1,
                                ),
                              ),
                              const SizedBox(width: 16),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _studentGender = 2;
                                  });
                                },
                                child: genderContainer(
                                  context,
                                  'Female',
                                  Icon(
                                    Icons.female,
                                    color: _studentGender == 2 ? Theme.of(context).bottomAppBarColor : Theme.of(context).textTheme.headline6!.color,
                                    size: 36,
                                  ),
                                  _studentGender == 2,
                                ),
                              ),
                              const SizedBox(width: 16),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _studentGender = 3;
                                  });
                                },
                                child: genderContainer(
                                  context,
                                  'Other',
                                  Icon(
                                    Icons.transgender,
                                    color: _studentGender == 3 ? Theme.of(context).bottomAppBarColor : Theme.of(context).textTheme.headline6!.color,
                                    size: 36,
                                  ),
                                  _studentGender == 3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'First meet on',
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
                title: 'Done',
                onTap: () {
                  print(_newStudentController.heightController.value.text);
                  _apiStudentController.userCreate(
                    context,
                    _newStudentController.fullNameController.value.text,
                    _studentGender,
                    double.parse(_newStudentController.heightController.value.text),
                    _studentMeetOn,
                    widget.refreshFunction,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget genderContainer(BuildContext context, String? title, Icon icon, bool isSelected) {
  return Container(
    width: (Get.width - 80) / 3,
    height: 100,
    decoration: BoxDecoration(
      color: isSelected != false ? HexColor(AppTheme.primaryColorString) : Theme.of(context).bottomAppBarColor,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: isSelected != false ? HexColor(AppTheme.primaryColorString) : Theme.of(context).bottomAppBarColor,
          blurRadius: 2,
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [icon],
        ),
        const SizedBox(height: 14),
        Text(
          title!,
          style: Theme.of(context).textTheme.caption!.copyWith(
                fontSize: 14,
                color: isSelected != false ? Theme.of(context).bottomAppBarColor : Theme.of(context).shadowColor,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    ),
  );
}
