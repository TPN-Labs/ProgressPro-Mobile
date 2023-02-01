import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:progressp/config/constants.dart';
import 'package:progressp/config/textstyle.dart';
import 'package:progressp/controller/student/student_controller.dart';
import 'package:progressp/model/student/student_model.dart';
import 'package:progressp/view/student/add_student_screen.dart';
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
            color: Theme.of(context).textTheme.headline6!.color,
          ),
        ),
        title: Text(
          'All students',
          style: Theme.of(context).textTheme.headline6!.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
          textAlign: TextAlign.center,
        ),
      ),
      body: Container(
        color: Theme.of(context).backgroundColor,
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
                    onTap: () {
                      Get.to(
                        () => AddStudentScreen(context, refreshStudentList),
                        transition: Transition.rightToLeft,
                        duration: const Duration(milliseconds: Constants.transitionDuration),
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
                          height: 72,
                          decoration: BoxDecoration(
                            color: Theme.of(context).bottomAppBarColor,
                            border: Border(
                              top: BorderSide(width: 2, color: HexColor(AppTheme.primaryColorString)),
                              bottom: BorderSide(width: 2, color: HexColor(AppTheme.primaryColorString)),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {},
                                child: studentList(
                                  _allStudents[i].fullName,
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
    );
  }
}
