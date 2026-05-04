import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:bachelor_foods/core/models/user_model.dart';

class UserStorageHelper {
  static const _fileName = 'user_profile.json';

  static Future<File?> _getFile() async {
    try {
      if (kIsWeb) return null;
      final dir = Directory.systemTemp;
      return File('${dir.path}/$_fileName');
    } catch (_) {
      return null;
    }
  }

  static Future<void> saveUser(UserModel user) async {
    try {
      final file = await _getFile();
      await file?.writeAsString(user.toJson());
    } catch (_) {}
  }

  static Future<UserModel?> getUser() async {
    try {
      final file = await _getFile();
      if (file == null || !await file.exists()) return null;
      final data = await file.readAsString();
      return UserModel.fromJson(data);
    } catch (_) {
      return null;
    }
  }

  static Future<bool> userExists() async {
    try {
      final file = await _getFile();
      if (file == null) return false;
      return await file.exists();
    } catch (_) {
      return false;
    }
  }

  static Future<void> clearUser() async {
    try {
      final file = await _getFile();
      if (file != null && await file.exists()) {
        await file.delete();
      }
    } catch (_) {}
  }
}