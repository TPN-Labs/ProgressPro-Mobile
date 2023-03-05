import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:progressp/controller/student/session_controller.dart';
import 'package:progressp/model/student/session_model.dart';
import 'package:progressp/config/constants.dart';
import 'package:progressp/config/textstyle.dart';
import 'package:progressp/model/student/student_model.dart';
import 'package:progressp/widget/custom_button.dart';
import 'package:progressp/widget/custom_student_picker.dart';
import 'package:progressp/widget/custom_textformfield.dart';

class AddSessionScreen extends StatefulWidget {
  final BuildContext parentContext;
  final SessionModel? sessionData;
  final Function mainRefreshFunction;
  final Function? secondRefreshFunction;

  const AddSessionScreen(
    this.parentContext,
    this.sessionData,
    this.mainRefreshFunction,
    this.secondRefreshFunction, {
    Key? key,
  }) : super(key: key);

  @override
  State<AddSessionScreen> createState() => _AddSessionScreenState();
}

class _AddSessionScreenState extends State<AddSessionScreen> {
  final _apiSessionController = APISessionController();
  final _newSessionController = Get.put(SessionController());

  StudentModelShort? _selectedStudent;

  @override
  void initState() {
    if (widget.sessionData != null) {
      _newSessionController.meetingsController.value.text = widget.sessionData!.meetings.toString();
      _newSessionController.priceController.value.text = widget.sessionData!.price.toString();
      _selectedStudent = StudentModelShort(id: widget.sessionData!.student.id, fullName: widget.sessionData!.student.fullName);
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
            widget.sessionData != null ? l10n.student_edit_title : l10n.student_create_title,
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
                    padding: Constants.defaultScreenPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Student',
                          style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                fontSize: 18,
                              ),
                        ),
                        const SizedBox(height: 18),
                        _selectedStudent == null
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
                                      _onPressedShowStudentDialog();
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 16.0),
                                        child: Text(
                                          'Selecteaza Student',
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
                                      _onPressedShowStudentDialog();
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
                                          _selectedStudent!.fullName,
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
                          'Numarul de intalniri',
                          style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                fontSize: 18,
                              ),
                        ),
                        const SizedBox(height: 18),
                        CustomTextFormField(
                          prefix: Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: Icon(
                              Icons.calendar_month,
                              color: Theme.of(context).shadowColor,
                              size: Constants.iconSize,
                            ),
                          ),
                          inputType: const TextInputType.numberWithOptions(
                            signed: true,
                            decimal: false,
                          ),
                          hintText: 'Numarul de intalniri',
                          textEditingController: _newSessionController.meetingsController.value,
                          capitalization: TextCapitalization.none,
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'Price',
                          style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                fontSize: 18,
                              ),
                        ),
                        const SizedBox(height: 18),
                        CustomTextFormField(
                          prefix: Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: Icon(
                              Icons.attach_money,
                              color: Theme.of(context).shadowColor,
                              size: Constants.iconSize,
                            ),
                          ),
                          hintText: 'Pret',
                          limit: [
                            LengthLimitingTextInputFormatter(10),
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9,]'),
                            )
                          ],
                          textEditingController: _newSessionController.priceController.value,
                          capitalization: TextCapitalization.none,
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
                type: ButtonChildType.text,
                onTap: () {
                  widget.sessionData == null
                      ? _apiSessionController.userCreate(
                          context,
                          _selectedStudent!,
                          int.parse(_newSessionController.meetingsController.value.text),
                          int.parse(_newSessionController.priceController.value.text),
                          widget.mainRefreshFunction,
                        )
                      : _apiSessionController.userUpdate(
                          context,
                          widget.sessionData!.id,
                          _selectedStudent!,
                          int.parse(_newSessionController.meetingsController.value.text),
                          int.parse(_newSessionController.priceController.value.text),
                          widget.sessionData!.status,
                          widget.mainRefreshFunction,
                          widget.secondRefreshFunction!,
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onPressedShowStudentDialog() async {
    final student = await showStudentPickerDialog(
      context,
    );
    if (student != null) {
      setState(() {
        _selectedStudent = student;
      });
    }
  }
}
