import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:progressp/config/constants.dart';
import 'package:progressp/controller/student/student_controller.dart';
import 'package:progressp/model/student/student_model.dart';
import 'package:progressp/widget/custom_button.dart';
import 'package:progressp/widget/custom_textformfield.dart';
import 'package:progressp/widget/gender_container.dart';

void showStudentModal({
  required BuildContext context,
  required StudentModel? studentModel,
  required Function mainRefreshFunction,
  required Function? secondRefreshFunction,
}) {
  final l10n = AppLocalizations.of(context)!;
  final apiStudentController = APIStudentController();
  final newStudentController = Get.put(StudentController());

  if(studentModel != null) {
    newStudentController.fullNameController.value.text = studentModel.fullName;
    newStudentController.totalMeetingsController.value.text = studentModel.totalMeetings.toString();
  }

  showModalBottomSheet(
    context: context,
    builder: (BuildContext bottomModalContext) {
      return BottomSheet(
        onClosing: () {},
        builder: (BuildContext context) {
          int studentGender = studentModel != null ? studentModel.gender : 0;
          return StatefulBuilder(
              builder: (BuildContext context, setState) => Container(
                height: 500,
                color: Theme.of(context).bottomAppBarTheme.color,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: Constants.modalPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.student_modal_fullname,
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 10),
                            CustomTextFormField(
                              prefix: Padding(
                                padding: const EdgeInsets.only(top: 10, bottom: 10),
                                child: Icon(
                                  Icons.person,
                                  color: Theme.of(context).shadowColor,
                                  size: Constants.iconSize,
                                ),
                              ),
                              hintText: l10n.student_modal_fullname,
                              textEditingController: newStudentController.fullNameController.value,
                              capitalization: TextCapitalization.none,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              l10n.student_modal_total_meetings,
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 10),
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
                                decimal: false,
                              ),
                              limit: [
                                LengthLimitingTextInputFormatter(10),
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]'),
                                )
                              ],
                              hintText: '',
                              textEditingController: newStudentController.totalMeetingsController.value,
                              capitalization: TextCapitalization.none,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              l10n.student_modal_gender,
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: Get.width,
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        studentGender = 1;
                                      });
                                    },
                                    child: genderContainer(
                                      bottomModalContext,
                                      l10n.student_modal_gender_male,
                                      Icon(
                                        Icons.male,
                                        color: studentGender == 1 ? Colors.white : Theme.of(context).textTheme.titleLarge!.color,
                                        size: 32,
                                      ),
                                      studentGender == 1,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        studentGender = 2;
                                      });
                                    },
                                    child: genderContainer(
                                      bottomModalContext,
                                      l10n.student_modal_gender_female,
                                      Icon(
                                        Icons.female,
                                        color: studentGender == 2 ? Colors.white : Theme.of(context).textTheme.titleLarge!.color,
                                        size: 32,
                                      ),
                                      studentGender == 2,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        studentGender = 3;
                                      });
                                    },
                                    child: genderContainer(
                                      bottomModalContext,
                                      l10n.student_modal_gender_other,
                                      Icon(
                                        Icons.transgender,
                                        color: studentGender == 3 ? Colors.white : Theme.of(context).textTheme.titleLarge!.color,
                                        size: 32,
                                      ),
                                      studentGender == 3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 18),
                          ],
                        ),
                      ),
                      CustomButton(
                        title: l10n.student_modal_send,
                        type: ButtonChildType.text,
                        showBorder: false,
                        onTap: () {
                          studentModel == null
                              ? apiStudentController.userCreate(
                            context,
                            newStudentController.fullNameController.value.text,
                            studentGender,
                            int.parse(newStudentController.totalMeetingsController.value.text),
                            mainRefreshFunction,
                          )
                              : apiStudentController.userUpdate(
                            context,
                            studentModel.id,
                            newStudentController.fullNameController.value.text,
                            studentGender,
                            int.parse(newStudentController.totalMeetingsController.value.text),
                            mainRefreshFunction,
                            secondRefreshFunction!,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              )
          );
        },
      );
    },
  );
}