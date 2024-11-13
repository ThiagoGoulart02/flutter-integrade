import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ItemProvider with ChangeNotifier {
  List items = [];
  int _page = 1;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchItems() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    final url =
        Uri.parse('https://jsonplaceholder.typicode.com/posts?_page=$_page');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List newItems = json.decode(response.body);
      items.addAll(newItems);
      _page++;
    }

    _isLoading = false;
    notifyListeners();
  }
}
