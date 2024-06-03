import 'package:flutter/material.dart';

import '../../../../helper/color.dart';
import '../../../../helper/custom_app_bar.dart';
import '../../../../helper/custom_icons.dart';
import '../../../../helper/text_controller_focus_node.dart';
import '../../../../helper/widget_button.dart';
import '../../../../helper/widget_string.dart';
import '../view_model/update_role_view_model.dart';

class UpdateRoleData extends StatefulWidget {
  const UpdateRoleData({
    super.key,
    required this.userKey,
  });

  final String userKey;

  @override
  State<UpdateRoleData> createState() => _UpdateRoleDataState();
}

class _UpdateRoleDataState extends State<UpdateRoleData> {
  late UpdateRoleViewModel updateRoleViewModel;
  final _formKey = GlobalKey<FormState>();

  late String? _selectedVal; // Initialize it as null

  var _isLoading = false;
  bool isButtonActive = false;

  @override
  void initState() {
    super.initState();
    updateRoleViewModel = UpdateRoleViewModel(context);
    updateRoleViewModel.getRoleData(widget.userKey);
    _selectedVal = updateRoleViewModel.roleList.isNotEmpty
        ? updateRoleViewModel.roleList[0]
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBar(
        title: updateRoleLabelText,
        leadingOnPressed: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              const SizedBox(height: 10),
              DropdownButtonFormField(
                value: _selectedVal,
                items: updateRoleViewModel.roleList
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ),
                    )
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedVal = val!;
                    updateRoleViewModel.fetchRoleId(_selectedVal);
                    isButtonActive = true;
                  });
                },
                icon: const Icon(Icons.arrow_drop_down_circle,
                    color: AppColors.circletextColor),
                decoration: InputDecoration(
                  labelText: roleLabelText,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    isButtonActive = true;
                  });
                },
                enabled: false,
                autofocus: false,
                controller: userNameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  labelText: nameLabelText,
                  hintText: enterNameText,
                  prefixIcon: const Icon(AppIcons.userNameIcon),
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    isButtonActive = true;
                  });
                },
                enabled: false,
                autofocus: false,
                controller: userEmailController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  labelText: email,
                  hintText: enterEmailText,
                  prefixIcon: const Icon(AppIcons.userMailIcon),
                ),
              ),
              const SizedBox(height: 30),
              CustomButton(
                  Onpressed: isButtonActive
                      ? () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              name = userNameController.text;
                              email = userEmailController.text;
                              isButtonActive = false;
                              _isLoading = true;
                            });
                            updateRoleViewModel.dbUpdateUser(widget.userKey);
                          }
                        }
                      : null,
                  Loading: _isLoading,
                  Display_Name: updateButtonText),
            ]),
          ),
        ),
      ),
    );
  }
}
