// ignore_for_file: unnecessary_new, prefer_equal_for_default_values, unnecessary_const, empty_catches, unnecessary_string_interpolations, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progressp/controller/student/student_controller.dart';

import 'package:progressp/model/student/student_model.dart';
import 'package:progressp/widget/custom_search.dart';

Future<List<StudentModelShort>> getStudents(BuildContext context) async {
  final APIStudentController apiStudentController = Get.put(APIStudentController());
  return apiStudentController
      .getAllStudents()
      .map(
        (e) => StudentModelShort(
          id: e.id,
          fullName: e.fullName,
        ),
      )
      .toList();
}

Future<StudentModelShort> getStudentById(BuildContext context, String studentId) async {
  final list = await getStudents(context);
  return list.firstWhere((element) => element.id == studentId);
}

Future<StudentModelShort?> showStudentPickerDialog(
  BuildContext context, {
  double cornerRadius = 16,
  bool focusSearchBox = false,
}) {
  return showDialog<StudentModelShort?>(
    context: context,
    barrierColor: Theme.of(context).backgroundColor,
    barrierDismissible: true,
    builder: (_) => Dialog(
      elevation: 0,
      insetPadding: const EdgeInsets.only(
        left: 10,
        right: 10,
        bottom: 60,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(cornerRadius),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 6.0),
            child: InkWell(onTap: () => Navigator.pop(context), child: const Icon(Icons.arrow_back)),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: StudentPickerWidget(
              onSelected: (country) => Navigator.of(context).pop(country),
            ),
          ),
        ],
      ),
    ),
  );
}

const TextStyle _defaultItemTextStyle = const TextStyle(fontSize: 16);
const TextStyle _defaultSearchInputStyle = const TextStyle(fontSize: 16);
const String _kDefaultSearchHintText = 'Search country name, code';

class StudentPickerWidget extends StatefulWidget {
  final ValueChanged<StudentModelShort>? onSelected;

  final TextStyle itemTextStyle;

  final TextStyle searchInputStyle;

  final InputDecoration? searchInputDecoration;

  final double flagIconSize;

  final bool showSeparator;

  final bool focusSearchBox;

  final String searchHintText;

  const StudentPickerWidget({
    Key? key,
    this.onSelected,
    this.itemTextStyle = _defaultItemTextStyle,
    this.searchInputStyle = _defaultSearchInputStyle,
    this.searchInputDecoration,
    this.searchHintText = _kDefaultSearchHintText,
    this.flagIconSize = 32,
    this.showSeparator = true,
    this.focusSearchBox = false,
  }) : super(key: key);

  @override
  _StudentPickerWidgetState createState() => _StudentPickerWidgetState();
}

class _StudentPickerWidgetState extends State<StudentPickerWidget> {
  List<StudentModelShort> _list = [];
  List<StudentModelShort> _filteredList = [];
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  bool _isLoading = false;
  StudentModelShort? _currentStudent;

  void _onSearch(text) {
    if (text == null || text.isEmpty) {
      setState(() {
        _filteredList.clear();
        _filteredList.addAll(_list);
      });
    } else {
      setState(() {
        _filteredList = _list.where((element) => element.fullName.toLowerCase().contains(text.toString().toLowerCase())).map((e) => e).toList();
      });
    }
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    });
    loadList();
    super.initState();
  }

  void loadList() async {
    setState(() {
      _isLoading = true;
    });
    _list = await getStudents(context);
    try {
      _currentStudent = _list.first;
      final student = _currentStudent;
      if (student != null) {
        _list.removeWhere((element) => element.id == student.id);
        _list.insert(0, student);
      }
    } catch (e) {
    } finally {
      setState(() {
        _filteredList = _list.map((e) => e).toList();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height,
      color: Theme.of(context).backgroundColor,
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 16,
          ),
          Container(
            height: 56,
            decoration: BoxDecoration(
              color: Theme.of(context).shadowColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: CustomSearchField(
                color: Theme.of(context).bottomAppBarColor,
                onChanged: _onSearch,
                controller: _controller,
                capitalization: TextCapitalization.words,
                hintText: '',
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: const CircularProgressIndicator())
                : Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 0.9,
                          spreadRadius: 1,
                          color: Theme.of(context).shadowColor,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(12),
                      color: Theme.of(context).backgroundColor,
                    ),
                    child: ListView.separated(
                      physics: const ClampingScrollPhysics(),
                      padding: const EdgeInsets.only(top: 10),
                      controller: _scrollController,
                      itemCount: _filteredList.length,
                      separatorBuilder: (_, index) => widget.showSeparator
                          ? Divider(
                              thickness: 1,
                              color: Theme.of(context).shadowColor,
                            )
                          : Container(),
                      itemBuilder: (_, index) {
                        return InkWell(
                          focusColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: () {
                            widget.onSelected?.call(_filteredList[index]);
                            // Navigator.of(context).pop();
                          },
                          child: SizedBox(
                            height: 56,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 8.0, left: 10.0, right: 8.0, top: 5.0),
                                  child: Icon(
                                    Icons.person,
                                    size: 32,
                                  ),
                                ),
                                Text(
                                  _filteredList[index].fullName,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).shadowColor,
                                    fontSize: 24,
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }
}
