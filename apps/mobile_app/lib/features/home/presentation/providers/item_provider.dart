import 'package:flutter/material.dart';
import 'package:mobile_app/features/home/data/models/item_model.dart';
import 'package:mobile_app/features/home/data/repositories/item_repository.dart';

class ItemProvider extends ChangeNotifier {
  final ItemRepository _repository = ItemRepository();
  
  List<Item> _items = [];
  bool _isLoading = false;
  String? _error;

  List<Item> get items => _items;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchItems() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _items = await _repository.getItems();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
