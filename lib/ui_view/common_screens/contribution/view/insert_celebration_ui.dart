import 'package:flutter/material.dart';

import '../../../../helper/color.dart';
import '../../../../helper/custom_app_bar.dart';
import '../../../../helper/custom_dropdown.dart';
import '../../../../helper/custom_flushbar.dart';
import '../../../../helper/custom_icons.dart';
import '../../../../helper/custom_text_field.dart';
import '../../../../helper/global_sized_box.dart';
import '../../../../helper/text_controller_focus_node.dart';
import '../../../../helper/validation.dart';
import '../../../../helper/widget_string.dart';
import '../view_model/insert_contribution_view_model.dart';

class InsertPaymentData extends StatefulWidget {
  const InsertPaymentData({super.key});

  @override
  State<InsertPaymentData> createState() => _InsertPaymentDataState();
}

class _InsertPaymentDataState extends State<InsertPaymentData> {
  final _formKey = GlobalKey<FormState>();
  bool isButtonActive = true;
  late InsertContributionViewModel insertCelebrationViewModel;
  String? _selectedVal = "";
  List<String> _items = [];

  _InsertPaymentDataState() {
    _selectedVal = _items.isNotEmpty ? _items[0] : null;
  }

  @override
  void initState() {
    super.initState();
    insertCelebrationViewModel = InsertContributionViewModel(context);
    insertCelebrationViewModel.getCurrentDateTime();
    insertCelebrationViewModel.fetchFirestoreId(_selectedVal);
    Utils.clearAllTextFields();
    insertCelebrationViewModel.fetchRoomDataList().then((value) {
      setState(() {
        _items = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: addContributionLabelText,
        leadingOnPressed: () => Navigator.pop(context),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(children: [
              const GlobalSizedBox(height: 10),
              CustomDropdown(
                  value: _selectedVal,
                  items: _items,
                  onChanged: (value) {
                    setState(() {
                      _selectedVal = value!;
                      insertCelebrationViewModel.fetchFirestoreId(_selectedVal);
                    });
                  }),
              const GlobalSizedBox(),
              CustomTextField(
                  controller: contributionNameController,
                  focusNode: contributionNameFocusNode,
                  labelText: contributionTitleText,
                  hintText: enterContributionText,
                  prefixIcon: AppIcons.contributionname,
                  validator: validateTitle),
              const GlobalSizedBox(),
              CustomTextField(
                  controller: userAmountController,
                  focusNode: userAmountFocusNode,
                  labelText: amountLabelText,
                  hintText: enterAmountText,
                  prefixIcon: AppIcons.currencyRupeeIcon,
                  maxLength: 6,
                  keyboardType: TextInputType.number,
                  validator: validateAmount),
              const GlobalSizedBox(),
              CustomTextField(
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  controller: userDescController,
                  focusNode: userDescFocusNode,
                  labelText: descriptionText,
                  hintText: enterDescriptionText,
                  prefixIcon: AppIcons.description,
                  validator: validateDescription),
              const GlobalSizedBox(),
              MaterialButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      roomName = _selectedVal!;
                      amount = int.parse(userAmountController.text);
                      name = userNameController.text;
                      description = userDescController.text;
                      contributionName = contributionNameController.text;
                      datectl = formattedDate;
                    });
                    insertCelebrationViewModel.insertContribution();
                  }
                },
                color: AppColors.submitbuttonColor,
                textColor: AppColors.textColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32)),
                child: Text(contributeButtonText,
                    style: const TextStyle(fontWeight: FontWeight.w500)),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
