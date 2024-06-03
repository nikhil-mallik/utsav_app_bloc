// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../helper/color.dart';
import '../../../../helper/custom_app_bar.dart';
import '../../../../helper/custom_dropdown.dart';
import '../../../../helper/custom_flushbar.dart';
import '../../../../helper/custom_icons.dart';
import '../../../../helper/custom_text_field.dart';
import '../../../../helper/global_sized_box.dart';
import '../../../../helper/text_controller_focus_node.dart';
import '../../../../helper/validation.dart';
import '../../../../helper/widget_button.dart';
import '../../../../helper/widget_string.dart';
import '../view_model/insert_celebration_view_model.dart';

class InsertCeleData extends StatefulWidget {
  const InsertCeleData({super.key});

  @override
  State<InsertCeleData> createState() => _InsertCeleDataState();
}

class _InsertCeleDataState extends State<InsertCeleData> {
  _InsertCeleDataState() {
    _selectedVal = _items.isNotEmpty ? _items[0] : null;
  }

  final _formKey = GlobalKey<FormState>();

  late InsertCelebrationViewModel insertCelebrationViewModel;
  bool isButtonActive = true;
  final _isLoading = false;

  String? _selectedVal = "";
  List<String> _items = [];

  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    insertCelebrationViewModel = InsertCelebrationViewModel(context);
    insertCelebrationViewModel.fetchFirestoreId(_selectedVal);
    Utils.clearAllTextFields();
    insertCelebrationViewModel.fetchData().then((value) {
      setState(() {
        _items = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBar(
          title: addCelebrationTitleText,
          leadingOnPressed: () => Navigator.pop(context)),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const GlobalSizedBox(height: 10),
                CustomDropdown(
                    value: _selectedVal,
                    onChanged: (value) {
                      setState(() {
                        _selectedVal = value!;
                        insertCelebrationViewModel
                            .fetchFirestoreId(_selectedVal);
                      });
                    },
                    items: _items),
                const SizedBox(height: 30),
                CustomTextField(
                  controller: userCelNameController,
                  focusNode: userCelNameFocusNode,
                  labelText: celebrationTitleText,
                  hintText: enterCelebrationText,
                  prefixIcon: AppIcons.headTitleIcon,
                  validator: validateTitle,
                ),
                const GlobalSizedBox(),
                CustomTextField(
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  controller: userCelDescController,
                  focusNode: userDescFocusNode,
                  labelText: descriptionText,
                  hintText: enterDescriptionText,
                  prefixIcon: AppIcons.description,
                  validator: validateDescription,
                ),
                const GlobalSizedBox(),
                CustomTextField(
                  keyboardType: TextInputType.datetime,
                  controller: userTimeInput,
                  focusNode: userTimeInputFocusNode,
                  labelText: enterTimeText,
                  hintText: '',
                  prefixIcon: AppIcons.setTimeIcon,
                  readOnly: true,
                  onTap: () => selectTime(),
                  validator: validateTime,
                ),
                const GlobalSizedBox(),
                CustomTextField(
                  keyboardType: TextInputType.datetime,
                  controller: dateCtl,
                  focusNode: dateCtlFocusNode,
                  labelText: celebrationDateText,
                  hintText: pickDateText,
                  prefixIcon: AppIcons.calDateIcon,
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  validator: validateDate,
                ),
                const GlobalSizedBox(),
                CustomButton(
                    Onpressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          celRoom = userCelNameController.text;
                          celDescription = userCelDescController.text;
                          dateMonth = dateCtl.text;
                          timeSamay = userTimeInput.text;
                          isButtonActive = false;
                        });
                        insertCelebrationViewModel.insertCelebration();
                      }
                    },
                    Display_Name: addButtonText,
                    Loading: _isLoading)
              ],
            ),
          ),
        ),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(
        () {
          _selectedDate = picked;
          dateCtl.text = DateFormat.yMMMMd().format(_selectedDate);
        },
      );
    }
  }

  void selectTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );
    if (pickedTime != null) {
      //output 10:51 PM
      DateTime parsedTime =
          DateFormat.jm().parse(pickedTime.format(context).toString());
      //converting to DateTime so that we can further format on different pattern.
      //output 1970-01-01 22:53:00.000
      String formattedTime = DateFormat('h:mm a').format(parsedTime);
      // String formattedTime =  DateFormat('h:mm a').format(parsedTime);
      if (kDebugMode) {
        print(formattedTime);
      } //output 14:59:00
      setState(() {
        userTimeInput.text = formattedTime; //set the value of text field.
      });
    } else {
      debugPrint("Time is not selected");
    }
  }
}
