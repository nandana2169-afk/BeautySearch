import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:beautyproduct/model/model.dart';

class BeautyProvider with ChangeNotifier {
  ProductModel? _productData;
  bool _isLoading = false;
  String _searchQuery = "";

  String _selectedCategory = "All";

  ProductModel? get productData => _productData;
  bool get isLoading => _isLoading;
  

  List<BeautyCategory> get filteredProducts {
    if (_productData == null) return [];

    List<BeautyCategory> list = _productData!.products;

    if (_selectedCategory != "All") {
      String categoryToMatch = _selectedCategory == "Grocery"
          ? "groceries"
          : _selectedCategory;

      list = list
          .where(
            (product) =>
                product.category.toLowerCase() == categoryToMatch.toLowerCase(),
          )
          .toList();
    }

    if (_searchQuery.isNotEmpty) {
      list = list.where((product) {
        return product.title.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            ) ||
            product.brand.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    return list;
  }

  void updateCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void updateSearch(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> fetchBeautyProducts() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await http.get(
        Uri.parse('https://dummyjson.com/products'),
      );
      if (response.statusCode == 200) {
        _productData = ProductModel.fromJson(json.decode(response.body));
      }
    } catch (e) {
      debugPrint("API Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
