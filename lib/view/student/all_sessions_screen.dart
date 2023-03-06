import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:progressp/config/constants.dart';
import 'package:progressp/config/textstyle.dart';
import 'package:progressp/controller/student/session_controller.dart';
import 'package:progressp/model/student/session_model.dart';
import 'package:progressp/view/student/add_session_screen.dart';
import 'package:progressp/view/student/view_session_screen.dart';
import 'package:progressp/widget/custom_button.dart';
import 'package:progressp/widget/custom_session_list.dart';

class AllSessionsScreen extends StatefulWidget {
  const AllSessionsScreen({Key? key}) : super(key: key);

  @override
  State<AllSessionsScreen> createState() => _AllSessionsScreenState();
}

class _AllSessionsScreenState extends State<AllSessionsScreen> {
  final _apiSessionController = APISessionController();

  late List<SessionModel> _allSessions;

  bool _areSessionsLoaded = false;

  Future<void> refreshSessionList() async {
    setState(() {
      _areSessionsLoaded = false;
    });
    _apiSessionController.userGetAll();
    setState(() {
      _allSessions = _apiSessionController.getAllSessions()..sort((a, b) => a.status.compareTo(b.status));
      _areSessionsLoaded = true;
    });
  }

  @override
  void initState() {
    refreshSessionList();
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
          l10n.session_details_title,
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
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: Get.width / 3,
                    child: CustomButton(
                      title: l10n.session_create,
                      type: ButtonChildType.text,
                      onTap: () {
                        Get.to(
                          () => AddSessionScreen(context, null, refreshSessionList, null),
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
              if (_areSessionsLoaded == true) ...[
                Expanded(
                  child: RefreshIndicator(
                    backgroundColor: Theme.of(context).backgroundColor,
                    onRefresh: refreshSessionList,
                    child: ListView(
                      physics: const ClampingScrollPhysics(),
                      padding: EdgeInsets.zero,
                      children: [
                        const SizedBox(height: 10),
                        for (var i = 0; i < _allSessions.length; i++) ...[
                          Container(
                            height: 85,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: HexColor(AppTheme.primaryColorString).withOpacity(0.2),
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
                                      () => ViewSessionScreen(
                                        context,
                                        refreshSessionList,
                                        _allSessions[i],
                                      ),
                                      transition: Transition.rightToLeft,
                                      duration: const Duration(
                                        milliseconds: Constants.transitionDuration,
                                      ),
                                    );
                                  },
                                  child: sessionList(
                                    context,
                                    '${l10n.session_no_1} ${_allSessions[i].unit}',
                                    _allSessions[i].statusEnum,
                                    _allSessions[i].student,
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
