import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeServices {
  GetStorage storage = GetStorage();

  Future<void> saveData(bool isDark) {
    return storage.write('isDark', isDark);
  }

  bool getData() {
    return storage.read<bool>('isDark') ?? false;
  }

  ThemeMode get theme => getData() ? ThemeMode.dark : ThemeMode.light;

  changeTheme() {
    Get.changeThemeMode(getData() ? ThemeMode.dark : ThemeMode.light);
    saveData(!getData());
  }
}
