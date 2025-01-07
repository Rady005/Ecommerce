import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'allitemdisplay.dart';

class SelectedList {
  List<Product> selectedList = [];

  // Add product to selected list and notify listeners
  Future<void> addProductToSelectedList(Product product) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Load existing selected list
      String? existingSelectedListString = prefs.getString('selectedList');
      List<Product> existingSelectedList = [];

      if (existingSelectedListString != null) {
        List<dynamic> decodedList = jsonDecode(existingSelectedListString);
        existingSelectedList = decodedList.map((e) => Product.fromJson(e)).toList();
      }

      // Add new product if not already in the list
      if (!existingSelectedList.any((item) => item.name == product.name)) {
        existingSelectedList.add(product);
      }

      // Save updated selected list
      await prefs.setString('selectedList', jsonEncode(existingSelectedList));

      // Update in-memory selected list
      selectedList = existingSelectedList;
    } catch (e) {
      // print("Error adding product to selected list: $e");
    }
  }

  // Remove product from selected list
  Future<void> removeProductFromSelectedList(Product product) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Load existing selected list
      String? existingSelectedListString = prefs.getString('selectedList');
      List<Product> existingSelectedList = [];

      if (existingSelectedListString != null) {
        List<dynamic> decodedList = jsonDecode(existingSelectedListString);
        existingSelectedList = decodedList.map((e) => Product.fromJson(e)).toList();
      }

      // Remove product if it exists in the list
      existingSelectedList.removeWhere((item) => item.name == product.name);

      // Save updated selected list
      await prefs.setString('selectedList', jsonEncode(existingSelectedList));

      // Update in-memory selected list
      selectedList = existingSelectedList;
    } catch (e) {
      // print("Error removing product from selected list: $e");
    }
  }

  Future<void> saveSelectedList() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String updatedSelectedListString = jsonEncode(selectedList);
      await prefs.setString('selectedList', updatedSelectedListString);
    } catch (e) {
      // print("Error saving selected list: $e");
    }
  }

  Future<void> loadSelectedList() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? selectedListString = prefs.getString('selectedList');
      if (selectedListString != null) {
        List<dynamic> decodedList = jsonDecode(selectedListString);
        selectedList = decodedList.map((e) => Product.fromJson(e)).toList();
      } else {
        selectedList = [];
      }
    } catch (e) {
      // print("Error loading selected list: $e");
    }
  }
}