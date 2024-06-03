import 'package:flutter/material.dart';

import '../../../../helper/color.dart';
import '../../../../helper/custom_app_bar.dart';
import '../../../../helper/custom_icons.dart';
import '../../../../helper/custom_text_field.dart';
import '../../../../helper/text_controller_focus_node.dart';
import '../../../../helper/validation.dart';
import '../../../../helper/widget_button.dart';
import '../../../../helper/widget_string.dart';
import '../view_model/update_room_view_model.dart';

class UpdateRoomData extends StatefulWidget {
  final String employeeKey;

  const UpdateRoomData({super.key, required this.employeeKey});

  @override
  State<UpdateRoomData> createState() => _UpdateRoomDataState();
}

class _UpdateRoomDataState extends State<UpdateRoomData> {
  final _formKey = GlobalKey<FormState>();
  late UpdateRoomViewModel updateRoomViewModel;
  bool isButtonActive = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    updateRoomViewModel = UpdateRoomViewModel(context);
    updateRoomViewModel.getCurrentDateTime();
    updateRoomViewModel.getRoomData(widget.employeeKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBar(
          title: updateRoomTitleText,
          leadingOnPressed: () => Navigator.of(context).pop()),
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(children: [
              const SizedBox(height: 10),
              CustomTextField(
                onChanged: (value) {
                  setState(() {
                    isButtonActive = true;
                  });
                },
                controller: userRoomNameController,
                focusNode: userRoomNameFocusNode,
                labelText: roomTitleText,
                hintText: enterRoomTitleText,
                prefixIcon: AppIcons.headTitleIcon,
                validator: validateTitle,
              ),
              const SizedBox(height: 30),
              CustomTextField(
                onChanged: (value) {
                  setState(() {
                    isButtonActive = true;
                  });
                },
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                controller: userRoomDescController,
                focusNode: userRoomDescFocusNode,
                labelText: descriptionText,
                hintText: enterDescriptionText,
                prefixIcon: AppIcons.description,
                validator: validateDescription,
              ),
              const SizedBox(height: 30),
              CustomButton(
                  Onpressed: isButtonActive
                      ? () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              room = userRoomNameController.text;
                              description = userRoomDescController.text;
                              dateMonth = formattedDate;
                              isButtonActive = false;
                              _isLoading = true;
                            });
                            updateRoomViewModel
                                .dbUpdateRoom(widget.employeeKey);
                          }
                        }
                      : null,
                  Display_Name: updateButtonText,
                  Loading: _isLoading),
            ]),
          ),
        ),
      ),
    );
  }
}
