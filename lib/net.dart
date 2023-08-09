import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'HomePage.dart';



class UpdateConvertorUtil {
  // Add a new UpdateConvertor instance to the list in SharedPreferences
  static Future<void> addUpdateConvertor(UpdateConvertor update) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> updateList = prefs.getStringList('update_list') ?? [];
    updateList.add(jsonEncode(update.toJson()));
    await prefs.setStringList('update_list', updateList);
  }

  // Get the list of UpdateConvertor instances from SharedPreferences
  static Future<List<UpdateConvertor>> getUpdateConvertorList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> updateList = prefs.getStringList('update_list') ?? [];
    return updateList.map((jsonString) {
      Map<String, dynamic> updateMap = jsonDecode(jsonString);
      return UpdateConvertor.fromJson(updateMap);
    }).toList();
  }

  // Remove a specific UpdateConvertor instance from the list in SharedPreferences
  static Future<void> removeUpdateConvertor(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> updateList = prefs.getStringList('update_list') ?? [];
    if (index >= 0 && index < updateList.length) {
      updateList.removeAt(index);
      await prefs.setStringList('update_list', updateList);
    }
  }
}

class BranchNewConvertorUtil {
  // Add a new UpdateConvertor instance to the list in SharedPreferences
  static Future<void> addUpdateConvertor(BranchNewConvertor update) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> updateList = prefs.getStringList('news_list') ?? [];
    updateList.add(jsonEncode(update.toJson()));
    await prefs.setStringList('news_list', updateList);
  }

  // Get the list of UpdateConvertor instances from SharedPreferences
  static Future<List<BranchNewConvertor>> getUpdateConvertorList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> updateList = prefs.getStringList('news_list') ?? [];
    return updateList.map((jsonString) {
      Map<String, dynamic> updateMap = jsonDecode(jsonString);
      return BranchNewConvertor.fromJson(updateMap);
    }).toList();
  }

  // Remove a specific UpdateConvertor instance from the list in SharedPreferences
  static Future<void> removeUpdateConvertor(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> updateList = prefs.getStringList('news_list') ?? [];
    if (index >= 0 && index < updateList.length) {
      updateList.removeAt(index);
      await prefs.setStringList('news_list', updateList);
    }
  }
}
