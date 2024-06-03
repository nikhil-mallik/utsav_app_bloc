import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

// Function to validate email format
String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Enter your email';
  } else if (!EmailValidator.validate(value)) {
    return 'Enter Valid Email';
  }
  return null;
}

// Function to validate if password is empty
String? validateEmptyPassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Enter your password';
  }
  return null;
}

// Function to validate password format
String? validatePassword(String? value) {
  RegExp regex = RegExp(
    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?\d)(?=.*?[!@#&*~]).{6,}$',
  );
  if (value == null || value.isEmpty) {
    return 'Enter your password';
  }
  if (!regex.hasMatch(value)) {
    return "Password must be minimum\n"
        "6 character and at least\n1 Upper Case,\n1 Lower Case,\n1 Digit,\n1 Special Character";
  }
  return null;
}

// Function to validate confirm password
String? validateConfirmPassword(
    String? value, TextEditingController passwordController) {
  RegExp regex = RegExp(
    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?\d)(?=.*?[!@#&*~]).{6,}$',
  );
  if (value == null || value.isEmpty) {
    return 'Enter your password';
  }
  if (value != passwordController.text) {
    return 'Passwords do not match';
  }
  if (!regex.hasMatch(value)) {
    return "Password must be minimum\n"
        "6 character and at least\n1 Upper Case,\n1 Lower Case,\n1 Digit,\n1 Special Character";
  }
  return null;
}

// Function to validate name field
String? validateName(String? value) {
  RegExp nonWhitespaceRegExp = RegExp(r'\S');
  if (value == null || value.isEmpty) {
    return 'Please enter your name';
  }
  if (!nonWhitespaceRegExp.hasMatch(value)) {
    return 'Not valid format';
  }
  if (value.length > 50) {
    return 'Name should be less than 50 Characters';
  }
  return null;
}

// Function to validate room selection
String? validateSelectRoom(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please select a room';
  }
  return null;
}

// Function to validate room field
String? validateRoom(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please select a room';
  }
  return null;
}

// Function to validate title field
String? validateTitle(String? value) {
  RegExp nonWhitespaceRegExp = RegExp(r'\S');
  if (value == null || value.isEmpty) {
    return 'Please enter the title';
  }
  if (!nonWhitespaceRegExp.hasMatch(value)) {
    return 'Not valid format';
  }
  if (value.length > 51) {
    return 'Title should be less than 50 Characters';
  }
  return null;
}

// Function to validate amount field
String? validateAmount(String? value) {
  RegExp digitRegExp = RegExp(r'^[1-9]\d*$');
  if (value == null || value.isEmpty) {
    return 'Please enter the amount';
  }
  if (!digitRegExp.hasMatch(value)) {
    return 'Not valid amount';
  }
  return null;
}

// Function to validate description field
String? validateDescription(String? value) {
  RegExp nonWhitespaceRegExp = RegExp(r'\S');
  if (value == null || value.isEmpty) {
    return 'Please enter the description';
  }
  if (!nonWhitespaceRegExp.hasMatch(value)) {
    return "Not valid format";
  }
  if (value.length < 10) {
    return 'Description must be minimum 10 Characters';
  }
  if (value.length > 301) {
    return 'Description should be less than 300 Characters';
  }
  return null;
}

// Function to validate time field
String? validateTime(String? value) {
  if (value == null || value.isEmpty) {
    return 'Set a time';
  }
  return null;
}

// Function to validate date field
String? validateDate(String? value) {
  if (value == null || value.isEmpty) {
    return 'Pick a date';
  }
  return null;
}

// Function to validate phone number field
String? validatePhone(String? value) {
  RegExp digitRegExp = RegExp(r'\d');
  if (value == null || value.isEmpty) {
    return 'Number can not be empty';
  }
  if (!digitRegExp.hasMatch(value)) {
    return 'No valid format';
  }
  if (value.length > 10) {
    return 'Maximum limit 10 digits';
  }
  if (value.length < 10) {
    return 'Minimum limit 10 digits';
  }
  return null;
}

// Function to validate age field
String? validateAge(String? value) {
  RegExp digitRegExp = RegExp(r'\d');
  if (value == null || value.isEmpty) {
    return 'Enter your age';
  }
  if (!digitRegExp.hasMatch(value)) {
    return 'No valid format';
  }
  if (value.length > 2) {
    return 'Enter valid age';
  }
  return null;
}
