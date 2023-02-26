import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:progressp/config/constants.dart';
import 'package:progressp/config/textstyle.dart';
import 'package:progressp/controller/student/student_controller.dart';
import 'package:progressp/model/student/student_model.dart';
import 'package:progressp/view/student/add_student_screen.dart';
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

  late List<StudentModel> _allStudents;

  bool _areStudentsLoaded = false;

  Future<void> refreshStudentList() async {
    print("dadada");
    setState(() {
      _areStudentsLoaded = false;
    });
    _apiStudentController.userGetAll();
    setState(() {
      _allStudents = _apiStudentController.getAllStudents()..sort((a, b) => a.fullName.compareTo(b.fullName));
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
          'All students',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
          textAlign: TextAlign.center,
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: Get.width / 3,
                    child: CustomButton(
                      title: 'Create',
                      type: ButtonChildType.text,
                      onTap: () {
                        Get.to(
                          () => AddStudentScreen(context, null, refreshStudentList, null),
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
              if (_areStudentsLoaded == true) ...[
                Expanded(
                  child: RefreshIndicator(
                    backgroundColor: Theme.of(context).backgroundColor,
                    onRefresh: refreshStudentList,
                    child: ListView(
                      physics: const ClampingScrollPhysics(),
                      padding: EdgeInsets.zero,
                      children: [
                        const SizedBox(height: 10),
                        for (var i = 0; i < _allStudents.length; i++) ...[
                          Container(
                            height: 110,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: HexColor(AppTheme.primaryColorString).withOpacity(0.8),
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
                                        milliseconds: Constants.transitionDuration,
                                      ),
                                    );
                                  },
                                  child: studentList(
                                    context,
                                    _allStudents[i].fullName,
                                    i,
                                    _allStudents[i].avatar,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
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
