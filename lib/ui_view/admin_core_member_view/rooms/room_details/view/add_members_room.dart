import 'package:flutter/material.dart';

import '../../../../../helper/color.dart';
import '../../../../../helper/custom_app_bar.dart';
import '../../../../../helper/validation.dart';
import '../../../../../helper/widget_button.dart';
import '../../../../../helper/widget_string.dart';
import '../view_model/add_member_room_view_model.dart';

class AddMemberData extends StatefulWidget {
  final String employeeKey;
  final String roomKey;
  const AddMemberData({
    required this.employeeKey,
    required this.roomKey,
    super.key,
  });

  @override
  State<AddMemberData> createState() => _AddMemberDataState();
}

class _AddMemberDataState extends State<AddMemberData> {
  final _formKey = GlobalKey<FormState>();

  _AddMemberDataState() {
    _selectedMail = _itemsMail.isNotEmpty ? _itemsMail[0] : null;
  }

  late AddMemberRoomViewModel addMemberRoomViewModel;

  final String _selectedVal = "";
  String? _selectedMail = "";
  final _isLoading = false;
  List<String> _itemsMail = [];

  @override
  void initState() {
    super.initState();
    addMemberRoomViewModel = AddMemberRoomViewModel(context);
    addMemberRoomViewModel.getCurrentDateTime();
    addMemberRoomViewModel.fetchFirestoreUserId(_selectedMail);
    addMemberRoomViewModel.fetchFirestoreId(_selectedVal);
    addMemberRoomViewModel.fetchUserEmail().then((valueemail) {
      setState(() {
        _itemsMail = valueemail;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBar(
        title: addMemberLabelText,
        leadingOnPressed: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              DropdownButtonFormField<String>(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  value: _selectedMail,
                  onChanged: (valueemail) {
                    setState(() {
                      _selectedMail = valueemail!;
                      addMemberRoomViewModel
                          .fetchFirestoreUserId(_selectedMail);
                    });
                  },
                  items: _itemsMail.map((String itemMail) {
                    return DropdownMenuItem<String>(
                        value: itemMail, child: Text(itemMail));
                  }).toList(),
                  icon: const Icon(Icons.arrow_drop_down_circle,
                      color: AppColors.appbariconColor),
                  decoration: InputDecoration(
                      labelText: emailLabelText,
                      hintText: selectEmailText,
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)))),
                  validator: validateEmail),
              const SizedBox(height: 30),
              CustomButton(
                  Onpressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        email = _selectedMail!;
                      });
                      addMemberRoomViewModel.dbAddUser(
                          widget.employeeKey, widget.roomKey);
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
