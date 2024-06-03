import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../helper/custom_app_bar.dart';
import '../../../../helper/global_sized_box.dart';
import '../../../../helper/validation.dart';
import '../../../../helper/color.dart';
import '../../../../helper/custom_icons.dart';
import '../../../../helper/widget_string.dart';
import 'profile_controller.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  bool _status = true;
  bool _isFavorite = false;
  final FocusNode myFocusNode = FocusNode();
  ScrollController scrollController = ScrollController();

  _UserProfileState() {
    selectedgender = genderList[0];
  }

  bool isEditable = false; // true-disable,false-enable
// List of gender options
  final genderList = ["Male", "Female", "Transgender"];
  String? selectedgender = "";
  final _formKey = GlobalKey<FormState>();
  var name = "";
  var age = "";
  var email = "";
  var number = "";

  // Controllers for text fields
  final userNameController = TextEditingController();
  final userAgeController = TextEditingController();
  final userEmailController = TextEditingController();
  final userNumberController = TextEditingController();
  final userGenderController = TextEditingController();

  // Focus nodes for text fields
  final userNameFocusNode = FocusNode();
  final userAgeFocusNode = FocusNode();
  final userEmailFocusNode = FocusNode();
  final userNumberFocusNode = FocusNode();
  final userGenderFocusNode = FocusNode();
  bool enableDropdown = false;
  late DocumentReference ref;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref = usersCollection.doc(FirebaseAuth.instance.currentUser!.uid);
    getUsersData();
    _toggleFavorite();
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  // Collection reference to Firestore users collection
  CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('Users');

  // Retrieve user data from Firestore
  void getUsersData() async {
    DocumentSnapshot snapshot = await ref.get();
    Map<String, dynamic> user = snapshot.data() as Map<String, dynamic>;
    userNameController.text = user['u_name'];
    userAgeController.text = user['age'];
    userEmailController.text = user['email'];
    userNumberController.text = user['number'];
    userGenderController.text = user['gender'];
    setState(() {
      selectedgender = user['gender'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      // resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: profileTitleText,
        leadingOnPressed: () => Navigator.pop(context),
      ),
      body: Form(
        key: _formKey,
        child: ChangeNotifierProvider(
          create: (_) => ProfileController(),
          child:
              Consumer<ProfileController>(builder: (context, provider, child) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                child: StreamBuilder(
                  stream: ref.snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasData) {
                      Map<String, dynamic>? map =
                          snapshot.data!.data() as Map<String, dynamic>?;

                      return SingleChildScrollView(
                        child: Column(children: [
                          const GlobalSizedBox(),
                          Stack(alignment: Alignment.bottomCenter, children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                    provider.showImage(context, map!['u_img']);
                                  },
                                  child: Container(
                                    height: 130,
                                    width: 130,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: AppColors.appbarColor,
                                          width: 2),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: provider.image == null
                                          ? map!['u_img'].toString() == ""
                                              ? const Icon(AppIcons.userNameIcon,
                                                  size: 35)
                                              : CachedNetworkImage(
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) =>
                                                      const Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      ),
                                                  imageUrl: map['u_img'])
                                          : Stack(children: [
                                              Image.file(
                                                File(provider.image!.path)
                                                    .absolute,
                                              ),
                                              const Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                            ]),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _isFavorite = !_isFavorite;
                                });
                                provider.pickImage(context);
                              },
                              child: CircleAvatar(
                                radius: 14,
                                backgroundColor: AppColors.dividerColor,
                                child: _isFavorite
                                    ? const Icon(Icons.add,
                                        size: 18, color: AppColors.whiteColor)
                                    : const Icon(Icons.edit,
                                        size: 18, color: AppColors.whiteColor),
                              ),
                            ),
                          ]),
                          const GlobalSizedBox(height: 40),
                          GestureDetector(
                            onTap: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 25.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 25.0),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(personalInformationText,
                                                      style: const TextStyle(
                                                          fontSize: 18.0,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ]),
                                            Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  _status
                                                      ? _getEditIcon()
                                                      : Container()
                                                ]),
                                          ]),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 25.0),
                                      child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Flexible(
                                              child: TextFormField(
                                                  autovalidateMode:
                                                      AutovalidateMode
                                                          .onUserInteraction,
                                                  controller:
                                                      userNameController,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  decoration: InputDecoration(
                                                    labelText: nameLabelText,
                                                    hintText: enterNameText,
                                                    prefixIcon: const Icon(
                                                        AppIcons.userNameIcon),
                                                  ),
                                                  validator: validateName,
                                                  enabled: !_status,
                                                  autofocus: !_status),
                                            ),
                                          ]),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 25.0),
                                      child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Flexible(
                                              child: TextFormField(
                                                  autovalidateMode:
                                                      AutovalidateMode
                                                          .onUserInteraction,
                                                  controller:
                                                      userEmailController,
                                                  keyboardType: TextInputType
                                                      .emailAddress,
                                                  decoration: InputDecoration(
                                                    enabled: false,
                                                    labelText: emailLabelText,
                                                    hintText: enterEmailText,
                                                    prefixIcon: const Icon(
                                                        AppIcons.userMailIcon),
                                                  ),
                                                  validator: validateEmail,
                                                  enabled: false),
                                            ),
                                          ]),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 25.0),
                                      child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Flexible(
                                              child: TextFormField(
                                                  autovalidateMode:
                                                      AutovalidateMode
                                                          .onUserInteraction,
                                                  controller:
                                                      userNumberController,
                                                  keyboardType:
                                                      TextInputType.phone,
                                                  decoration: InputDecoration(
                                                    labelText: mobileLabelText,
                                                    hintText: enterMobileText,
                                                    prefixIcon: const Icon(
                                                      AppIcons.phoneNumberIcon,
                                                    ),
                                                  ),
                                                  maxLength: 10,
                                                  validator: validatePhone,
                                                  enabled: !_status),
                                            ),
                                          ]),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 25.0),
                                      child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Flexible(
                                              flex: 2,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10.0, top: 4.0),
                                                child: TextFormField(
                                                    autovalidateMode:
                                                        AutovalidateMode
                                                            .onUserInteraction,
                                                    controller:
                                                        userAgeController,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration: InputDecoration(
                                                      labelText: ageLabelText,
                                                      hintText: enterAgeText,
                                                      prefixIcon: const Icon(
                                                          AppIcons.userAgeIcon),
                                                    ),
                                                    validator: validateAge,
                                                    enabled: !_status),
                                              ),
                                            ),
                                            Flexible(
                                              flex: 2,
                                              child: DropdownButtonFormField(
                                                value: selectedgender,
                                                items: genderList
                                                    .map(
                                                        (e) => DropdownMenuItem(
                                                              value: e,
                                                              child: Text(e),
                                                            ))
                                                    .toList(),
                                                onChanged: isEditable
                                                    ? (String? value) {
                                                        setState(() {
                                                          selectedgender =
                                                              value!;
                                                        });
                                                      }
                                                    : null,
                                                icon: const Icon(
                                                    Icons
                                                        .arrow_drop_down_circle,
                                                    color: AppColors
                                                        .appbariconColor,
                                                    size: 15),
                                                decoration: InputDecoration(
                                                    labelText: genderLabelText,
                                                    labelStyle: const TextStyle(
                                                        fontSize: 15)),
                                              ),
                                            ),
                                          ]),
                                    ),
                                    !_status
                                        ? _getActionButtons()
                                        : Container(),
                                  ]),
                            ),
                          ),
                        ]),
                      );
                    } else {
                      return Center(child: Text(somethingWentWrong));
                    }
                  },
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _getActionButtons() {
    // Action buttons for saving and canceling changes
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _status = true;
                      isEditable = false;
                      dbAddUser();
                      FocusScope.of(context).requestFocus(FocusNode());
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: AppColors.whiteColor,
                    backgroundColor: AppColors.editbuttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: Text(saveButtonText),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: ElevatedButton(
                  onPressed: () {
                    setState(
                      () {
                        _status = true;
                        isEditable = false;
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: AppColors.whiteColor,
                    backgroundColor: AppColors.alertColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: Text(cancelButtonText),
                ),
              ),
            ),
          ]),
    );
  }

  Widget _getEditIcon() {
    // Edit icon for enabling editing mode
    return GestureDetector(
      child: const CircleAvatar(
        backgroundColor: AppColors.circleColor,
        radius: 14.0,
        child: Icon(Icons.edit, color: AppColors.whiteColor, size: 16.0),
      ),
      onTap: () {
        setState(() {
          _status = false;
          isEditable = isEditable == true ? false : true;
        });
      },
    );
  }

  void dbAddUser() {
    // Method to update user data in Firestore
    if (_formKey.currentState!.validate()) {
      setState(() {
        age = userAgeController.text;
        name = userNameController.text;
        number = userNumberController.text;
      });
      ref.update(
        {
          'u_name': userNameController.text.toString(),
          'number': userNumberController.text.toString(),
          'age': userAgeController.text.toString(),
          'gender': selectedgender.toString(),
          'email': userEmailController.text.toString(),
        },
      );
      usersCollection
          .doc(
        FirebaseAuth.instance.currentUser!.uid.toString(),
      )
          .update(
        {
          'u_name': userNameController.text.toString(),
          'number': userNumberController.text.toString(),
          'age': userAgeController.text.toString(),
          'gender': selectedgender.toString(),
          'email': userEmailController.text.toString(),
        },
      );
      userNumberController.addListener(
        () {
          // Ensure phone number is not longer than 10 digits
          if (userNumberController.text.length > 10) {
            userNumberController.text =
                userNumberController.text.substring(0, 10);
            userNumberController.selection = TextSelection.fromPosition(
                TextPosition(offset: userNumberController.text.length));
          }
        },
      );
      userAgeController.addListener(() {
        // Ensure age is not longer than 2 digits
        if (userAgeController.text.length > 2) {
          userAgeController.text = userAgeController.text.substring(0, 2);
          userAgeController.selection = TextSelection.fromPosition(
              TextPosition(offset: userAgeController.text.length));
        }
      });
    }
  }
}
