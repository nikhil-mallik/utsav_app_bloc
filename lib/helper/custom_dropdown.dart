import 'package:flutter/material.dart';

import 'color.dart';
import 'validation.dart';
import 'widget_string.dart';

class CustomDropdown extends StatefulWidget {
  final String? value;
  final void Function(String?) onChanged;
  final List<String> items;

  const CustomDropdown({
    super.key,
    this.value,
    required this.onChanged,
    required this.items,
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      value: widget.value,
      onChanged: widget.onChanged,
      items: widget.items.map((String item) {
        return DropdownMenuItem<String>(value: item, child: Text(item));
      }).toList(),
      icon: const Icon(Icons.arrow_drop_down_circle,
          color: AppColors.appbariconColor),
      decoration: InputDecoration(
        labelText: roomNameText,
        hintText: selectRoomText,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      validator: validateSelectRoom,
    );
  }
}
