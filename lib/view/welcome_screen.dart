import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:progressp/config/constants.dart';
import 'package:progressp/config/images.dart';
import 'package:progressp/view/auth/signin_screen.dart';
import 'package:progressp/view/auth/signup_screen.dart';
import 'package:progressp/widget/custom_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
        color: Theme.of(context).bottomAppBarTheme.color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top + 30),
            Container(
              height: 300,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    DefaultImages.welcomeImage,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.welcome,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 34,
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              l10n.welcome_headline,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 16,
                    height: 1.4,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Padding(
              padding: Constants.defaultScreenPadding,
              child: CustomButton(
                title: l10n.welcome_login,
                type: ButtonChildType.text,
                showBorder: false,
                onTap: () {
                  Get.to(
                    () => const SignInScreen(),
                    transition: Transition.rightToLeft,
                  );
                },
              ),
            ),
            const Expanded(
              child: SizedBox(
                height: 40,
              ),
            ),
            InkWell(
              onTap: () {
                Get.to(
                  () => const SignUpScreen(),
                  transition: Transition.rightToLeft,
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.welcome_no_account,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    l10n.welcome_register,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
