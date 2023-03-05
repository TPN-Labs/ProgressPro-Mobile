import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:progressp/config/constants.dart';
import 'package:progressp/config/textstyle.dart';
import 'package:progressp/controller/student/session_controller.dart';
import 'package:progressp/model/student/session_model.dart';
import 'package:progressp/view/student/add_session_screen.dart';
import 'package:progressp/widget/custom_button.dart';

class ViewSessionScreen extends StatefulWidget {
  final BuildContext parentContext;
  final Function refreshFunction;
  final SessionModel sessionModel;

  const ViewSessionScreen(
    this.parentContext,
    this.refreshFunction,
    this.sessionModel, {
    Key? key,
  }) : super(key: key);

  @override
  State<ViewSessionScreen> createState() => _ViewSessionScreenState();
}

class _ViewSessionScreenState extends State<ViewSessionScreen> {
  final APISessionController _apiSessionController = Get.put(APISessionController());

  late SessionModel? _sessionModel;
  late bool _isDeleted = false;

  void refreshSessionDetails() {
    if (_isDeleted) return;
    List<SessionModel>? allStudents = _apiSessionController.getAllSessions();
    int currentStudentIdx = allStudents.indexWhere((student) => student.id == widget.sessionModel.id);
    setState(() {
      _sessionModel = allStudents[currentStudentIdx];
    });
  }

  @override
  void initState() {
    setState(() {
      _sessionModel = null;
    });
    refreshSessionDetails();
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
                    height: 70,
                    width: 150,
                    decoration: BoxDecoration(
                      color: _sessionModel!.statusEnum.color,
                      borderRadius: BorderRadius.circular(70),
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      _sessionModel!.statusEnum.icon,
                      color: Colors.white,
                      size: 42,
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
                            "Student",
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          Text(
                            _sessionModel!.student.fullName,
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
                            "Nume",
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          Text(
                            'Sesiunea ${_sessionModel!.unit}',
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
                            "Pret",
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          Text(
                            _sessionModel!.price.toString(),
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
                            "Total intalniri",
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            _sessionModel!.meetings.toString(),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: Get.width / 3 - 15,
                    child: CustomButton(
                      icon: SessionStatus.paid.icon,
                      type: ButtonChildType.icon,
                      bgColor: SessionStatus.paid.color,
                      onTap: () {
                        _apiSessionController.userUpdate(
                          context,
                          _sessionModel!.id,
                          _sessionModel!.student,
                          _sessionModel!.meetings,
                          _sessionModel!.price,
                          SessionStatus.paid.value,
                          widget.refreshFunction,
                          widget.refreshFunction,
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: Get.width / 3 - 15,
                    child: CustomButton(
                      icon: SessionStatus.closed.icon,
                      type: ButtonChildType.icon,
                      bgColor: SessionStatus.closed.color,
                      onTap: () {
                        _apiSessionController.userUpdate(
                          context,
                          _sessionModel!.id,
                          _sessionModel!.student,
                          _sessionModel!.meetings,
                          _sessionModel!.price,
                          SessionStatus.closed.value,
                          widget.refreshFunction,
                          widget.refreshFunction,
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    width: Get.width / 3 - 15,
                    child: CustomButton(
                      icon: SessionStatus.archived.icon,
                      type: ButtonChildType.icon,
                      bgColor: SessionStatus.archived.color,
                      onTap: () {
                        _apiSessionController.userUpdate(
                          context,
                          _sessionModel!.id,
                          _sessionModel!.student,
                          _sessionModel!.meetings,
                          _sessionModel!.price,
                          SessionStatus.archived.value,
                          widget.refreshFunction,
                          widget.refreshFunction,
                        );
                      },
                    ),
                  ),
                ],
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
