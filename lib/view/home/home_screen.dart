import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:progressp/config/constants.dart';
import 'package:progressp/config/images.dart';
import 'package:progressp/config/textstyle.dart';
import 'package:progressp/view/student/add_student_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
            width: Get.width,
            color: HexColor(AppTheme.primaryColorString),
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).padding.top + 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {

                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                DefaultImages.user,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    l10n.home_title,
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        height: 48,
                        width: Get.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.white.withOpacity(0.1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: TextFormField(
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hoverColor: Colors.white,
                            ),
                            cursorColor: Colors.white,
                          ),
                        ),
                      ),
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.search,
                          color: HexColor(AppTheme.primaryColorString),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20)
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        l10n.home_quick,
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          circleCard(
                            context,
                            Icons.calendar_month,
                            l10n.home_quick_1,
                            HexColor(AppTheme.primaryColorString),
                          ),
                          circleCard(
                            context,
                            Icons.sports_handball,
                            l10n.home_quick_2,
                            HexColor(AppTheme.primaryColorString),
                          ),
                          circleCard(
                            context,
                            Icons.note,
                            l10n.home_quick_3,
                            HexColor(AppTheme.primaryColorString),
                          ),
                          InkWell(
                            onTap: () {
                              Get.to(
                                () => const AddStudentScreen(),
                                transition: Transition.rightToLeft,
                                duration: const Duration(milliseconds: Constants.transitionDuration),
                              );
                            },
                            child: circleCard(
                              context,
                              Icons.person,
                              l10n.home_quick_4,
                              HexColor(AppTheme.primaryColorString),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 30),
                      InkWell(
                        onTap: () {

                        },
                        child: Text(
                          l10n.home_latest,
                          style: Theme.of(context).textTheme.bodyText2!.copyWith(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          for (var i = 0; i < 3; i++)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 25),
                              child: Container(
                                height: 100,
                                width: Get.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: HexColor(AppTheme.primaryColorString).withOpacity(0.5),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20, right: 20),
                                  child: Row(
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            i == 0
                                                ? 'Mihai M'
                                                : i == 1
                                                    ? 'Adriana R'
                                                    : 'Ciprian P',
                                            style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 24, color: Colors.white),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            i == 0
                                                ? 'Ultima vizita pe: Joi, Sep 29'
                                                : i == 1
                                                    ? 'Ultima vizita pe: Joi, Sep 29'
                                                    : 'Ultima vizita pe: Joi, Sep 29',
                                            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                              fontSize: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget circleCard(BuildContext context, IconData icon, String text, Color color) {
  return Container(
    width: (Get.width - 50) / 4,
    child: Column(
      children: [
        Container(
          height: 64,
          width: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Icon(
              icon,
              size: 40,
              color: HexColor(AppTheme.secondaryColorString),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyText2!.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                height: 1.4,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
