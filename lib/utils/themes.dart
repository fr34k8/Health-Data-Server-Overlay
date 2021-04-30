import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/utils/colors.dart';

class Themes {
  static final light = ThemeData(
    brightness: Brightness.light,
    primarySwatch: createMaterialColor(AppColors.accent),
  );

  static final dark = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: createMaterialColor(AppColors.accent),
  );

  static final sideBarWidth = 304.0;
}
