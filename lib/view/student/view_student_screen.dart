import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:progressp/config/constants.dart';
import 'package:progressp/config/textstyle.dart';
import 'package:progressp/controller/student/student_controller.dart';
import 'package:progressp/model/student/student_model.dart';
import 'package:progressp/view/student/add_student_screen.dart';
import 'package:progressp/widget/custom_button.dart';

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

  late StudentModel? _studentModel;
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
      _studentModel = allStudents[currentStudentIdx];
    });
  }

  @override
  void initState() {
    setState(() {
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
        backgroundColor: Theme.of(context).bottomAppBarColor,
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
        color: Theme.of(context).backgroundColor,
        child: Padding(
          padding: Constants.defaultScreenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 150,
                    width: Get.width - 50,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/avatars/avatar_${_studentModel!.avatar % 15}.png',
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: Get.width / 6,
                          child: CustomButton(
                            icon: Icons.edit,
                            type: ButtonChildType.icon,
                            bgColor: Colors.cyan,
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
                        const SizedBox(height: 20),
                        SizedBox(
                          width: Get.width / 6,
                          child: CustomButton(
                            icon: Icons.delete,
                            type: ButtonChildType.icon,
                            bgColor: Colors.red,
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
                  ),
                ],
              ),
              const SizedBox(height: 20),
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
                      const SizedBox(height: 25),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [for (var i = 0; i < 2; i++) upcomingMeeting(context)],
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget upcomingMeeting(
  BuildContext context,
) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Container(
      height: 96,
      width: Get.width,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).shadowColor,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
        color: HexColor(AppTheme.primaryColorString).withOpacity(0.2),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
        ),
        child: Row(
          children: [
            Container(
              height: 64,
              width: 48,
              decoration: BoxDecoration(
                color: HexColor(AppTheme.primaryColorString),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '22',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Jan',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  ' 9:00 am - 11:00 am',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600),
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}
