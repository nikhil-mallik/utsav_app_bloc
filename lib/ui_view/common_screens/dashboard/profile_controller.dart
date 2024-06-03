// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../helper/color.dart';
import '../../../helper/custom_flushbar.dart';

class ProfileController with ChangeNotifier {
  // Text editing controllers for various user profile fields
  final userNameController = TextEditingController();
  final userAgeController = TextEditingController();
  final userEmailController = TextEditingController();
  final userNumberController = TextEditingController();
  final userGenderController = TextEditingController();

  // Focus nodes for various user profile fields
  final nameFocusNode = FocusNode();
  final ageFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final numberFocusNode = FocusNode();
  final genderFocusNode = FocusNode();

// Flag to track whether the button is active
  bool isButtonActive = false;

  // Reference to the Firestore collection 'Users'
  final ref = FirebaseFirestore.instance.collection('Users');

  FirebaseStorage storage = FirebaseStorage.instance;

  // Image picker instance
  final picker = ImagePicker();

  // Variable to store image link
  var imagelink;

  // Variable to store picked image file
  XFile? _image;

  // Getter for the picked image file
  XFile? get image => _image;

  // Variable to track loading state
  bool _loading = false;

  // Getter for loading state
  bool get loading => _loading;

  // Function to set loading state
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  // Function to pick image from gallery
  Future pickGalleryImage(BuildContext context) async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );

    if (pickedFile != null) {
      _image = XFile(pickedFile.path);
      uploadImage(context);
      notifyListeners();
    }
  }

  // Function to pick image from camera
  Future pickCameraImage(BuildContext context) async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 100,
    );

    if (pickedFile != null) {
      _image = XFile(pickedFile.path);
      uploadImage(context);
      notifyListeners();
    }
  }

  // Function to show image picker dialog
  void pickImage(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            height: 168,
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                    pickCameraImage(context);
                    Navigator.pop(context);
                  },
                  leading: const Icon(
                    Icons.camera_alt_outlined,
                    color: AppColors.dividerColor,
                  ),
                  title: const Text('Camera'),
                ),
                ListTile(
                  onTap: () {
                    pickGalleryImage(context);
                    Navigator.pop(context);
                  },
                  leading: const Icon(
                    Icons.image,
                    color: AppColors.dividerColor,
                  ),
                  title: const Text('Gallery'),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  leading: const Icon(
                    Icons.cancel_outlined,
                    color: AppColors.dividerColor,
                  ),
                  title: const Text('Cancel'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Function to upload image to Firebase storage
  void uploadImage(BuildContext context) async {
    setLoading(true);
    Reference storageref = FirebaseStorage.instance.ref(
      '/u_img${FirebaseAuth.instance.currentUser!.uid}',
    );

    UploadTask uploadTask = storageref.putFile(File(image!.path).absolute);

    await Future.value(uploadTask);

    final newUrl = await storageref.getDownloadURL();
    ref
        .doc(
      FirebaseAuth.instance.currentUser!.uid.toString(),
    )
        .update({'u_img': newUrl.toString()}).then(
      (value) {
        Utils.customFlushBar(context, 'Profile updated');
        setLoading(false);
        _image = null;
      },
    ).onError(
      (error, stackTrace) {
        setLoading(false);
        Utils.customFlushBar(
          context,
          error.toString(),
        );
      },
    );
  }

  // Function to show image in dialog
  void showImage(context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Hero(
            tag: imageUrl,
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }
}
