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
import '../../../../helper/widget_button.dart';
import '../../../../helper/widget_string.dart';
import '../view_model/insert_expense_view_model.dart';

class InsertExpenseData extends StatefulWidget {
  const InsertExpenseData({super.key});

  @override
  State<InsertExpenseData> createState() => _InsertExpenseDataState();
}

class _InsertExpenseDataState extends State<InsertExpenseData> {
  _InsertExpenseDataState() {
    _selectedVal = _items.isNotEmpty ? _items[0] : null;
  }

  final _formKey = GlobalKey<FormState>();

  bool isButtonActive = true;

  var _isLoading = false;

  String? _selectedVal = "";
  List<String> _items = [];
  late InsertExpenseModel insertExpenseModel;

  @override
  void initState() {
    super.initState();
    insertExpenseModel = InsertExpenseModel(context);
    insertExpenseModel.getCurrentDateTime();
    insertExpenseModel.fetchFirestoreId(_selectedVal);
    Utils.clearAllTextFields();
    insertExpenseModel.fetchRoomDataList().then((value) {
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
          title: addExpenseTitleText,
          leadingOnPressed: () => Navigator.pop(context)),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: [
              const GlobalSizedBox(height: 10),
              CustomDropdown(
                  value: _selectedVal,
                  items: _items,
                  onChanged: (value) {
                    setState(() {
                      _selectedVal = value!;
                      insertExpenseModel.fetchFirestoreId(_selectedVal);
                    });
                  }),
              const GlobalSizedBox(),
              CustomTextField(
                  controller: expenseNameController,
                  focusNode: expenseNameFocusNode,
                  labelText: expenseTitleText,
                  hintText: enterExpenseText,
                  prefixIcon: AppIcons.expenseNameIcon,
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
              CustomButton(
                  Onpressed: isButtonActive
                      ? () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              roomName = _selectedVal!;
                              expenseName = expenseNameController.text;
                              amount = int.parse(userAmountController.text);
                              description = userDescController.text;
                              date = formattedDate;
                            });
                            insertExpenseModel.insertExpense();
                            setState(() {
                              _selectedVal =
                                  _items.isNotEmpty ? _items[0] : null;
                              _isLoading = true;
                              isButtonActive = false;
                            });
                          }
                        }
                      : null,
                  Loading: _isLoading,
                  Display_Name: addButtonText),
            ]),
          ),
        ),
      ),
    );
  }
}
