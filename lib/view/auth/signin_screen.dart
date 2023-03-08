import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:progressp/config/constants.dart';
import 'package:progressp/config/images.dart';
import 'package:progressp/controller/user/auth_controller.dart';
import 'package:progressp/view/auth/signup_screen.dart';
import 'package:progressp/widget/custom_button.dart';
import 'package:progressp/widget/custom_textformfield.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _loginController = Get.put(LoginController());
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
            color: Theme.of(context).textTheme.titleLarge!.color,
          ),
        ),
        title: Text(
          l10n.signin_title,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          height: Get.height - 100,
          color: Theme.of(context).bottomAppBarTheme.color,
          child: Padding(
            padding: Constants.defaultScreenPadding,
            child: Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  height: 300,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        DefaultImages.singInImage,
                      ),
                    ),
                  ),
                ),
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
                  hintText: l10n.signin_user,
                  inputType: TextInputType.text,
                  textEditingController: _loginController.userInputController.value,
                  capitalization: TextCapitalization.none,
                  limit: [
                    LengthLimitingTextInputFormatter(30),
                  ],
                ),
                const SizedBox(height: 25),
                CustomTextFormField(
                  sufix: InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      _loginController.isVisible.value = !_loginController.isVisible.value;
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Icon(
                        Icons.remove_red_eye_rounded,
                        color: Theme.of(context).shadowColor,
                        size: Constants.iconSize,
                      ),
                    ),
                  ),
                  prefix: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Icon(
                      Icons.key,
                      color: Theme.of(context).shadowColor,
                      size: Constants.iconSize,
                    ),
                  ),
                  hintText: l10n.signin_pass,
                  obscure: _loginController.isVisible.value == true ? false : true,
                  textEditingController: _loginController.passwordController.value,
                  capitalization: TextCapitalization.none,
                  limit: [
                    FilteringTextInputFormatter.singleLineFormatter,
                  ],
                  inputType: TextInputType.visiblePassword,
                ),
                const SizedBox(height: 28),
                CustomButton(
                  title: l10n.signin_button,
                  type: ButtonChildType.text,
                  showBorder: false,
                  onTap: () {
                    _apiAuthController.sendLogin(
                      context,
                      _loginController.userInputController.value.text,
                      _loginController.passwordController.value.text,
                    );
                  },
                ),
                const SizedBox(height: 28),
                InkWell(
                  onTap: () {
                    Get.to(
                      const SignUpScreen(),
                      transition: Transition.rightToLeft,
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.signin_notice,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        l10n.signin_register,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        )
      ),
    );
  }
}
