import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:progressp/config/constants.dart';
import 'package:progressp/config/textstyle.dart';
import 'package:progressp/controller/user/auth_controller.dart';
import 'package:progressp/view/auth/signin_screen.dart';
import 'package:progressp/widget/custom_button.dart';
import 'package:progressp/widget/custom_textformfield.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _signUpController = Get.put(SignUpController());
  final _apiAuthController = Get.put(APIAuthController());

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
              color: Theme.of(context).textTheme.headline6!.color,
            ),
          ),
          title: Text(
            l10n.signup_title,
            style: Theme.of(context).textTheme.headline6!.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ),
        body: SingleChildScrollView(
          reverse: true,
          child: Padding(
            padding: Constants.defaultScreenPadding,
            child: Column(
              children: [
                const SizedBox(height: 20),
                CustomTextFormField(
                  prefix: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Icon(
                      Icons.person,
                      color: Theme.of(context).shadowColor,
                      size: Constants.iconSize,
                    ),
                  ),
                  hintText: l10n.signup_user,
                  inputType: TextInputType.text,
                  textEditingController: _signUpController.usernameController.value,
                  capitalization: TextCapitalization.none,
                ),
                const SizedBox(height: 25),
                CustomTextFormField(
                  prefix: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Icon(
                      Icons.mail,
                      color: Theme.of(context).shadowColor,
                      size: Constants.iconSize,
                    ),
                  ),
                  hintText: l10n.signup_email,
                  inputType: TextInputType.emailAddress,
                  textEditingController: _signUpController.emailController.value,
                  capitalization: TextCapitalization.none,
                ),
                const SizedBox(height: 25),
                CustomTextFormField(
                  prefix: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Icon(
                      Icons.key,
                      color: Theme.of(context).shadowColor,
                      size: Constants.iconSize,
                    ),
                  ),
                  hintText: l10n.signup_pass,
                  textEditingController: _signUpController.passwordController.value,
                  obscure: _signUpController.isVisible.value == true ? false : true,
                  inputType: TextInputType.visiblePassword,
                  capitalization: TextCapitalization.none,
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      focusColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        setState(() {
                          _signUpController.isAgree.value = !_signUpController.isAgree.value;
                        });
                      },
                      child: Container(
                        height: 24,
                        width: 24,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xffDCDBE0),
                            width: 2,
                          ),
                          color: _signUpController.isAgree.value
                              ? HexColor(AppTheme.primaryColorString)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.check,
                          size: 15,
                          color: _signUpController.isAgree.value ? Colors.white : Colors.transparent,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: '${l10n.signup_notice_1} ',
                              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Theme.of(context).shadowColor,
                                  ),
                            ),
                            TextSpan(
                              text: '${l10n.signup_terms} ',
                              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: HexColor(AppTheme.primaryColorString),
                                  ),
                            ),
                            TextSpan(
                              text: '${l10n.signup_notice_2} ',
                              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Theme.of(context).shadowColor,
                                  ),
                            ),
                            TextSpan(
                              text: '${l10n.signup_cookies} ',
                              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: HexColor(AppTheme.primaryColorString),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 28),
                CustomButton(
                  title: l10n.signup_button,
                  type: ButtonChildType.text,
                  showBorder: false,
                  onTap: () {
                    _apiAuthController.sendRegister(
                      context,
                      _signUpController.usernameController.value.text,
                      _signUpController.emailController.value.text,
                      _signUpController.passwordController.value.text,
                    );
                  },
                ),
                InkWell(
                  onTap: () {
                    Get.to(
                      const SignInScreen(),
                      transition: Transition.rightToLeft,
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.signup_already_acc,
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        l10n.signup_login,
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
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
        ));
  }
}
