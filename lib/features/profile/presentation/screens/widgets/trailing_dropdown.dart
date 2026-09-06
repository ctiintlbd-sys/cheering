import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cheering/core/theme/app_theme_colors.dart';

class TrailingDropdown extends StatefulWidget {
  final List<String> items;
  final String initialValue;
  final ValueChanged<String> onChanged;

  const TrailingDropdown({
    super.key,
    required this.items,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<TrailingDropdown> createState() => _TrailingDropdownState();
}

class _TrailingDropdownState extends State<TrailingDropdown> {
  late String selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }

  @override
  void didUpdateWidget(TrailingDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      selectedValue = widget.initialValue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: selectedValue,
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: context.colors.iconSecondary,
          size: 20.r,
        ),
        elevation: 2,
        dropdownColor: context.colors.bgSecondary,
        borderRadius: BorderRadius.circular(12.r),
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: context.colors.textSecondary,
        ),
        onChanged: (String? newValue) {
          if (newValue != null) {
            setState(() {
              selectedValue = newValue;
            });
            widget.onChanged(newValue);
          }
        },
        items: widget.items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: Text(value),
            ),
          );
        }).toList(),
      ),
    );
  }
}
