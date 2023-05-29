import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:progressp/config/constants.dart';
import 'package:progressp/config/textstyle.dart';
import 'package:progressp/controller/student/meeting_controller.dart';
import 'package:progressp/controller/student/student_controller.dart';
import 'package:progressp/model/student/student_model.dart';
import 'package:progressp/view/student/student_modal.dart';
import 'package:progressp/view/student/view_student_screen.dart';
import 'package:progressp/widget/custom_button.dart';
import 'package:progressp/widget/custom_student_list.dart';

class AllStudentsScreen extends StatefulWidget {
  const AllStudentsScreen({Key? key}) : super(key: key);

  @override
  State<AllStudentsScreen> createState() => _AllStudentsScreenState();
}

class _AllStudentsScreenState extends State<AllStudentsScreen> {
  final _apiStudentController = APIStudentController();
  final _apiMeetingController = APIMeetingController();

  late List<StudentModel> _allStudents;

  bool _areStudentsLoaded = false;

  Future<void> refreshStudentList() async {
    setState(() {
      _areStudentsLoaded = false;
    });
    _apiStudentController.userGetAll();
    setState(() {
      _allStudents = _apiStudentController.getAllStudents()
        ..sort((a, b) => a.fullName.compareTo(b.fullName));
      _areStudentsLoaded = true;
    });
  }

  @override
  void initState() {
    refreshStudentList();
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
          l10n.student_all_title,
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
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: Get.width / 3,
                    child: CustomButton(
                      title: l10n.student_create,
                      type: ButtonChildType.text,
                      showBorder: false,
                      onTap: () {
                        showStudentModal(
                          context: context,
                          studentModel: null,
                          mainRefreshFunction: refreshStudentList,
                          secondRefreshFunction: null,
                        );
                      },
                    ),
                  ),
                ],
              ),
              if (_areStudentsLoaded == true) ...[
                Expanded(
                  child: RefreshIndicator(
                    backgroundColor: Theme.of(context).backgroundColor,
                    onRefresh: refreshStudentList,
                    child: ListView(
                      physics: const ClampingScrollPhysics(),
                      padding: EdgeInsets.zero,
                      children: [
                        const SizedBox(height: DefaultMargins.smallMargin),
                        for (var i = 0; i < _allStudents.length; i++) ...[
                          Container(
                            height: 85,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: HexColor(AppTheme.primaryColorString)
                                  .withOpacity(0.2),
                              border: Border.all(
                                color: Theme.of(context).shadowColor,
                                width: 3,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Get.to(
                                      () => ViewStudentScreen(
                                        context,
                                        refreshStudentList,
                                        _allStudents[i],
                                      ),
                                      transition: Transition.rightToLeft,
                                      duration: const Duration(
                                        milliseconds:
                                            Constants.transitionDuration,
                                      ),
                                    );
                                  },
                                  child: studentList(
                                    context,
                                    _allStudents[i].fullName,
                                    i,
                                    _apiMeetingController
                                        .getLatestMeeting(_allStudents[i].id)
                                        ?.endAt,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: DefaultMargins.smallMargin),
                        ],
                      ],
                    ),
                  ),
                ),
              ] else ...[
                SizedBox(
                  height: Get.height - 300,
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
