import 'package:flutter/material.dart';

import '../../../../helper/color.dart';
import '../../../../helper/custom_app_bar.dart';
import '../../../../helper/custom_icons.dart';
import '../../../../helper/custom_text_field.dart';
import '../../../../helper/global_sized_box.dart';
import '../../../../helper/text_controller_focus_node.dart';
import '../../../../helper/validation.dart';
import '../../../../helper/widget_button.dart';
import '../../../../helper/widget_string.dart';
import '../view_model/update_expense_view_model.dart';

class UpdateExpenseData extends StatefulWidget {
  const UpdateExpenseData({super.key, required this.expenseKey});

  final String expenseKey;

  @override
  State<UpdateExpenseData> createState() => _UpdateExpenseDataState();
}

class _UpdateExpenseDataState extends State<UpdateExpenseData> {
  final _formKey = GlobalKey<FormState>();
  late UpdateExpenseModel updateExpenseModel;
  bool isButtonActive = false;
  var isLoading = false;

  @override
  void initState() {
    super.initState();
    updateExpenseModel = UpdateExpenseModel(context);
    updateExpenseModel.getExpenseData(widget.expenseKey);
    updateExpenseModel.getCurrentDateTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBar(
        title: updateExpenseTitleText,
        leadingOnPressed: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(children: [
                const GlobalSizedBox(height: 10),
                CustomTextField(
                    onChanged: (value) {
                      setState(() {
                        isButtonActive = true;
                      });
                    },
                    controller: expenseNameController,
                    focusNode: expenseNameFocusNode,
                    labelText: expenseTitleText,
                    hintText: enterExpenseText,
                    prefixIcon: AppIcons.expenseNameIcon,
                    validator: validateTitle),
                const GlobalSizedBox(),
                CustomTextField(
                    onChanged: (value) {
                      setState(() {
                        isButtonActive = true;
                      });
                    },
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
                    onChanged: (value) {
                      setState(() {
                        isButtonActive = true;
                      });
                    },
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    controller: userDescController,
                    focusNode: userDescFocusNode,
                    labelText: descriptionText,
                    hintText: enterDescriptionText,
                    prefixIcon: AppIcons.description,
                    validator: validateDescription),
                const GlobalSizedBox(),
                CustomButton(
                    Onpressed: isButtonActive
                        ? () {
                            if (_formKey.currentState!.validate()) {
                              setState(
                                () {
                                  amount = int.parse(userAmountController.text);
                                  expenseName = expenseNameController.text;
                                  description = userDescController.text;
                                  isLoading = true;
                                },
                              );
                              updateExpenseModel
                                  .updateExpense(widget.expenseKey);
                              isButtonActive = false;
                            }
                          }
                        : null,
                    Loading: isLoading,
                    Display_Name: updateButtonText),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
