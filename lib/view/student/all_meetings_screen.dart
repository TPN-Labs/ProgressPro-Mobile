import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:progressp/config/constants.dart';
import 'package:progressp/controller/student/meeting_controller.dart';
import 'package:progressp/model/student/meeting_model.dart';
import 'package:progressp/view/student/add_meeting_screen.dart';
import 'package:progressp/widget/custom_button.dart';
import 'package:progressp/widget/custom_meeting_list.dart';

class AllMeetingsScreen extends StatefulWidget {
  const AllMeetingsScreen({Key? key}) : super(key: key);

  @override
  State<AllMeetingsScreen> createState() => _AllMeetingsScreenState();
}

class _AllMeetingsScreenState extends State<AllMeetingsScreen> {
  final _apiMeetingController = APIMeetingController();

  late List<MeetingModel> _allMeetings;

  bool _areMeetingsLoaded = false;

  Future<void> refreshMeetingList() async {
    setState(() {
      _areMeetingsLoaded = false;
    });
    _apiMeetingController.userGetAll();
    setState(() {
      _allMeetings = _apiMeetingController.getAllMeetings()..sort((a, b) => b.startAt.toString().compareTo(a.startAt.toString()));
      _areMeetingsLoaded = true;
    });
  }

  @override
  void initState() {
    refreshMeetingList();
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
          'Toate intalnirile',
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
              const SizedBox(height: 15),
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
                          () => AddMeetingScreen(context, null, refreshMeetingList, null),
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
              const SizedBox(height: 15),
              if (_areMeetingsLoaded == true) ...[
                Expanded(
                  child: RefreshIndicator(
                    backgroundColor: Theme.of(context).bottomAppBarTheme.color,
                    onRefresh: refreshMeetingList,
                    child: ListView(
                      physics: const ClampingScrollPhysics(),
                      padding: EdgeInsets.zero,
                      children: [
                        const SizedBox(height: 5),
                        for (var i = 0; i < _allMeetings.length; i++) ...[
                          SizedBox(
                            height: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Get.to(
                                          () => AddMeetingScreen(context, _allMeetings[i], refreshMeetingList, null),
                                      transition: Transition.rightToLeft,
                                      duration: const Duration(
                                        milliseconds: Constants.transitionDuration,
                                      ),
                                    );
                                  },
                                  child: meetingList(
                                    context,
                                    _allMeetings[i],
                                    true,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
