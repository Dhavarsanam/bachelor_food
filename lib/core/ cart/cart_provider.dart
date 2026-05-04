import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String name;
  final String emoji;
  final double price;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.emoji,
    required this.price,
    this.quantity = 1,
  });

  double get subtotal => price * quantity;
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get totalCount =>
      _items.fold(0, (s, i) => s + i.quantity);

  double get totalAmount =>
      _items.fold(0.0, (s, i) => s + i.subtotal);

  int quantityOf(String id) {
    final match = _items.where((i) => i.id == id);
    return match.isEmpty ? 0 : match.first.quantity;
  }

  void add(String id, String name, String emoji, double price) {
    final idx = _items.indexWhere((i) => i.id == id);
    if (idx >= 0) {
      _items[idx].quantity++;
    } else {
      _items.add(CartItem(
          id: id, name: name, emoji: emoji, price: price));
    }
    notifyListeners();
  }

  void increment(String id) {
    final idx = _items.indexWhere((i) => i.id == id);
    if (idx >= 0) {
      _items[idx].quantity++;
      notifyListeners();
    }
  }

  void decrement(String id) {
    final idx = _items.indexWhere((i) => i.id == id);
    if (idx < 0) return;
    if (_items[idx].quantity > 1) {
      _items[idx].quantity--;
    } else {
      _items.removeAt(idx);
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}