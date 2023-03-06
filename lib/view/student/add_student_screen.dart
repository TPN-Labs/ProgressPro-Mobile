import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:progressp/controller/student/student_controller.dart';
import 'package:progressp/model/student/student_model.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:progressp/config/constants.dart';
import 'package:progressp/config/textstyle.dart';
import 'package:progressp/widget/custom_button.dart';
import 'package:progressp/widget/custom_textformfield.dart';

class AddStudentScreen extends StatefulWidget {
  final BuildContext parentContext;
  final StudentModel? studentData;
  final Function mainRefreshFunction;
  final Function? secondRefreshFunction;

  const AddStudentScreen(
    this.parentContext,
    this.studentData,
    this.mainRefreshFunction,
    this.secondRefreshFunction, {
    Key? key,
  }) : super(key: key);

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _apiStudentController = APIStudentController();
  final _newStudentController = Get.put(StudentController());

  int _studentGender = 0;
  int _studentAvatar = 0;
  String _studentMeetOn = DateTime.now().toString();

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      _studentMeetOn = args.value.toString().substring(0, 10);
    });
  }

  @override
  void initState() {
    if (widget.studentData != null) {
      _newStudentController.fullNameController.value.text = widget.studentData!.fullName;
      _newStudentController.heightController.value.text = widget.studentData!.height.toString();
      _studentGender = widget.studentData!.gender;
      _studentAvatar = widget.studentData!.avatar;
      _studentMeetOn = widget.studentData!.knownFrom.toString().substring(0, 10);
    } else {
      _studentMeetOn = Constants.formatDate(DateTime.now());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
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
            widget.studentData != null ? l10n.student_edit_title : l10n.student_create_title,
            style: Theme.of(context).textTheme.headline6!.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ),
        body: Container(
          color: Theme.of(context).bottomAppBarTheme.color,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 28),
              Expanded(
                child: ListView(
                  children: [
                    Padding(
                      padding: Constants.defaultScreenPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.student_modal_fullname,
                            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 18),
                          CustomTextFormField(
                            prefix: Padding(
                              padding: const EdgeInsets.only(top: 10, bottom: 10),
                              child: Icon(
                                Icons.person,
                                color: Theme.of(context).shadowColor,
                                size: Constants.iconSize,
                              ),
                            ),
                            hintText: l10n.student_modal_fullname,
                            textEditingController: _newStudentController.fullNameController.value,
                            capitalization: TextCapitalization.none,
                          ),
                          const SizedBox(height: 18),
                          Text(
                            l10n.student_modal_height,
                            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 18),
                          CustomTextFormField(
                            prefix: Padding(
                              padding: const EdgeInsets.only(top: 10, bottom: 10),
                              child: Icon(
                                Icons.height,
                                color: Theme.of(context).shadowColor,
                                size: Constants.iconSize,
                              ),
                            ),
                            inputType: const TextInputType.numberWithOptions(
                              signed: false,
                              decimal: true,
                            ),
                            limit: [
                              LengthLimitingTextInputFormatter(10),
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9.,]'),
                              )
                            ],
                            hintText: '${l10n.student_modal_height} (${l10n.student_modal_height_cm})',
                            textEditingController: _newStudentController.heightController.value,
                            capitalization: TextCapitalization.none,
                          ),
                          const SizedBox(height: 18),
                          Text(
                            l10n.student_modal_gender,
                            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 18),
                          SizedBox(
                            width: Get.width,
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _studentGender = 1;
                                    });
                                  },
                                  child: genderContainer(
                                    context,
                                    l10n.student_modal_gender_male,
                                    Icon(
                                      Icons.male,
                                      color: _studentGender == 1 ? Colors.white : Theme.of(context).textTheme.headline6!.color,
                                      size: 36,
                                    ),
                                    _studentGender == 1,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _studentGender = 2;
                                    });
                                  },
                                  child: genderContainer(
                                    context,
                                    l10n.student_modal_gender_female,
                                    Icon(
                                      Icons.female,
                                      color: _studentGender == 2 ? Colors.white : Theme.of(context).textTheme.headline6!.color,
                                      size: 36,
                                    ),
                                    _studentGender == 2,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      _studentGender = 3;
                                    });
                                  },
                                  child: genderContainer(
                                    context,
                                    l10n.student_modal_gender_other,
                                    Icon(
                                      Icons.transgender,
                                      color: _studentGender == 3 ? Colors.white : Theme.of(context).textTheme.headline6!.color,
                                      size: 36,
                                    ),
                                    _studentGender == 3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            l10n.student_modal_avatar,
                            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 18),
                          SizedBox(
                            width: Get.width,
                            height: 100,
                            child: Scrollbar(
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: [
                                  Row(
                                    children: [
                                      for (var i = 0; i < 15; i++) ...[
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              _studentAvatar = i;
                                            });
                                          },
                                          child: avatarContainer(
                                            context,
                                            i,
                                            _studentAvatar == i,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                      ]
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            l10n.student_modal_first_meet,
                            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).shadowColor,
                                  blurRadius: 2,
                                ),
                              ],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: SfDateRangePicker(
                                onSelectionChanged: _onSelectionChanged,
                                initialSelectedDate: widget.studentData == null
                                    ? DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
                                    : widget.studentData!.knownFrom,
                                selectionMode: DateRangePickerSelectionMode.single,
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: CustomButton(
                  title: l10n.student_modal_send,
                  type: ButtonChildType.text,
                  showBorder: false,
                  onTap: () {
                    widget.studentData == null
                        ? _apiStudentController.userCreate(
                      context,
                      _newStudentController.fullNameController.value.text,
                      _studentGender,
                      double.parse(
                        _newStudentController.heightController.value.text,
                      ),
                      _studentAvatar,
                      _studentMeetOn,
                      widget.mainRefreshFunction,
                    )
                        : _apiStudentController.userUpdate(
                      context,
                      widget.studentData!.id,
                      _newStudentController.fullNameController.value.text,
                      _studentGender,
                      double.parse(
                        _newStudentController.heightController.value.text,
                      ),
                      _studentAvatar,
                      _studentMeetOn,
                      widget.mainRefreshFunction,
                      widget.secondRefreshFunction!,
                    );
                  },
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}

Widget genderContainer(
  BuildContext context,
  String? title,
  Icon icon,
  bool isSelected,
) {
  return Container(
    width: (Get.width - 80) / 3,
    height: 100,
    decoration: BoxDecoration(
      color: isSelected != false ? HexColor(AppTheme.primaryColorString) : Theme.of(context).bottomAppBarTheme.color,
      borderRadius: BorderRadius.circular(100),
      border: Border.all(
        color: Theme.of(context).shadowColor,
        width: 1.5,
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [icon],
        ),
        const SizedBox(height: 14),
        Text(
          title!,
          style: Theme.of(context).textTheme.caption!.copyWith(
                fontSize: 14,
                color: isSelected != false ? Colors.white : Theme.of(context).shadowColor,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    ),
  );
}

Widget avatarContainer(
  BuildContext context,
  int avatarId,
  bool isSelected,
) {
  return Container(
    width: (Get.width - 80) / 3,
    decoration: BoxDecoration(
      color: isSelected != false ? HexColor(AppTheme.primaryColorString).withOpacity(0.5) : Theme.of(context).bottomAppBarTheme.color,
      borderRadius: BorderRadius.circular(100),
      border: Border.all(
        color: Theme.of(context).shadowColor,
        width: 1.5,
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 85,
              width: 85,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/avatars/avatar_${avatarId % 15}.png',
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
