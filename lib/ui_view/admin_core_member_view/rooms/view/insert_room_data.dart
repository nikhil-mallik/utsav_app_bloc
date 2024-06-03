import 'package:flutter/material.dart';

import '../../../../helper/color.dart';
import '../../../../helper/custom_app_bar.dart';
import '../../../../helper/custom_flushbar.dart';
import '../../../../helper/custom_icons.dart';
import '../../../../helper/custom_text_field.dart';
import '../../../../helper/global_sized_box.dart';
import '../../../../helper/text_controller_focus_node.dart';
import '../../../../helper/validation.dart';
import '../../../../helper/widget_button.dart';
import '../../../../helper/widget_string.dart';
import '../view_model/insert_room_view_model.dart';

class InsertRoomData extends StatefulWidget {
  const InsertRoomData({super.key});

  @override
  State<InsertRoomData> createState() => _InsertRoomDataState();
}

class _InsertRoomDataState extends State<InsertRoomData> {
  final _formKey = GlobalKey<FormState>();
  late InsertRoomViewModel insertRoomViewModel;
  bool isButtonActive = true;
  final _isLoading = false;

  @override
  void initState() {
    super.initState();
    insertRoomViewModel = InsertRoomViewModel(context);
    Utils.clearAllTextFields();
    insertRoomViewModel.getCurrentDateTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBar(
          title: addRoomLabelText,
          leadingOnPressed: () => Navigator.pop(context)),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              const GlobalSizedBox(height: 10),
              CustomTextField(
                controller: userRoomNameController,
                focusNode: userRoomNameFocusNode,
                labelText: roomTitleText,
                hintText: enterRoomTitleText,
                prefixIcon: AppIcons.headTitleIcon,
                validator: validateTitle,
              ),
              const GlobalSizedBox(),
              CustomTextField(
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                controller: userRoomDescController,
                focusNode: userRoomDescFocusNode,
                labelText: descriptionText,
                hintText: enterDescriptionText,
                prefixIcon: AppIcons.description,
                validator: validateDescription,
              ),
              const GlobalSizedBox(),
              CustomButton(
                  Onpressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        room = userRoomNameController.text;
                        description = userRoomDescController.text;
                        dateMonth = formattedDate;
                        isButtonActive = false;
                      });
                      insertRoomViewModel.insertRoom();
                    }
                  },
                  Display_Name: addButtonText,
                  Loading: _isLoading),
            ]),
          ),
        ),
      ),
    );
  }
}
