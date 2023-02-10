import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/model/place.dart';
import 'package:http/http.dart' as http;

class Places with ChangeNotifier {
  List<Place> _items = [];
  String query = '';
  String nextToken = '';
  bool loading = false;
  List<Place> get items {
    return [..._items];
  }

  void setLoading(val) {
    loading = val;
    notifyListeners();
  }

  void queryText(text) {
    query = text;
    setLoading(true);
    fetchShopList();
    notifyListeners();
  }

  Future<void> fetchShopList() async {
    try {
      const String apiKey = 'AIzaSyAW_rkAQ8XJLmNIJWJ7qzNtIPzYw7246b8';
      const type = 'restaurant';
      const location = ' in Bangkok กรุงเทพ';
      const baseURL =
          'https://maps.googleapis.com/maps/api/place/textsearch/json';
      final url = Uri.parse(
          '$baseURL?query=$query$location&key=$apiKey&type=$type&next_page_token=$nextToken');
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final listData = extractedData['results'] as List<dynamic>;
      final List<Place> loadedPlace = [];
      listData.forEach((element) {
        loadedPlace.add(Place(
          id: UniqueKey(),
          name: element['name'],
          icon: element['icon'],
          iconBgColor: element['icon_background_color'],
          address: element['formatted_address'],
        ));
      });
      _items = loadedPlace;
      nextToken = extractedData['next_page_token'];
      notifyListeners();
    } catch (error) {
      throw error;
    } finally {
      setLoading(false);
    }
  }
}
