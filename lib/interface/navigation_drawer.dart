import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hds_overlay/interface/routes.dart';

final navigationDrawer = Drawer(
  child: ListView(
    // Important: Remove any padding from the ListView.
    padding: EdgeInsets.zero,
    children: <Widget>[
      DrawerHeader(
        child: Text(
          'HDS',
          style: TextStyle(color: Colors.white),
        ),
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/icon.png')),
          color: Colors.grey,
        ),
      ),
      ListTile(
        title: Text('Overlay'),
        onTap: () {
          if (Get.currentRoute != Routes.overlay) {
            Get.toNamed(Routes.overlay);
          } else {
            Get.back();
          }
        },
      ),
      ListTile(
        title: Text('Settings'),
        onTap: () {
          if (Get.currentRoute != Routes.settings) {
            Get.toNamed(Routes.settings);
          } else {
            Get.back();
          }
        },
      ),
    ],
  ),
);
