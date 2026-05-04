import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../cart/cart_screen.dart';
import 'package:bachelor_foods/features/home/menu_screen.dart';

// ─────────────────────────────────────────────
//  Constants
// ─────────────────────────────────────────────
const _kOrange = Color(0xFFFF6B2C);
const _kOrangeLight = Color(0xFFFFF0EB);

// ─────────────────────────────────────────────
//  Models
// ─────────────────────────────────────────────
class FoodCategory {
  final String id;
  final String label;
  final String emoji;
  final String description;

  const FoodCategory({
    required this.id,
    required this.label,
    required this.emoji,
    required this.description,
  });
}

class FoodItem {
  final String name;
  final String category;
  final String emoji;
  final double price;
  final double rating;
  final String time;
  final bool isBestseller;

  const FoodItem({
    required this.name,
    required this.category,
    required this.emoji,
    required this.price,
    required this.rating,
    required this.time,
    this.isBestseller = false,
  });
}

// ─────────────────────────────────────────────
//  Local Cart Model  ✅ quantity initialized
// ─────────────────────────────────────────────
class _CartEntry {
  final FoodItem item;
  int quantity = 1; // ✅ FIXED: was uninitialized
  _CartEntry({required this.item});
}

// ─────────────────────────────────────────────
//  Mock Food Data
// ─────────────────────────────────────────────
const allFoodItems = [
  // Breakfast
  FoodItem(name: 'Masala Omelette',   category: 'breakfast', emoji: '🍳', price: 89,  rating: 4.5, time: '15 min', isBestseller: true),
  FoodItem(name: 'Poha',              category: 'breakfast', emoji: '🥣', price: 59,  rating: 4.3, time: '10 min'),
  FoodItem(name: 'Idli Sambar',       category: 'breakfast', emoji: '🫓', price: 69,  rating: 4.7, time: '12 min', isBestseller: true),
  FoodItem(name: 'Aloo Paratha',      category: 'breakfast', emoji: '🫔', price: 99,  rating: 4.6, time: '20 min'),
  FoodItem(name: 'Upma',              category: 'breakfast', emoji: '🥘', price: 55,  rating: 4.2, time: '10 min'),
  // Lunch
  FoodItem(name: 'Chicken Biryani',   category: 'lunch',     emoji: '🍛', price: 199, rating: 4.8, time: '30 min', isBestseller: true),
  FoodItem(name: 'Dal Tadka + Rice',  category: 'lunch',     emoji: '🍚', price: 129, rating: 4.5, time: '25 min'),
  FoodItem(name: 'Paneer Masala',     category: 'lunch',     emoji: '🧀', price: 169, rating: 4.6, time: '25 min', isBestseller: true),
  FoodItem(name: 'Veg Thali',         category: 'lunch',     emoji: '🍱', price: 149, rating: 4.4, time: '20 min'),
  FoodItem(name: 'Chicken Curry',     category: 'lunch',     emoji: '🍗', price: 189, rating: 4.7, time: '30 min'),
  // Dinner
  FoodItem(name: 'Tandoori Chicken',  category: 'dinner',    emoji: '🍖', price: 259, rating: 4.9, time: '35 min', isBestseller: true),
  FoodItem(name: 'Butter Naan',       category: 'dinner',    emoji: '🫓', price: 179, rating: 4.6, time: '25 min'),
  FoodItem(name: 'Fish Curry',        category: 'dinner',    emoji: '🐟', price: 229, rating: 4.5, time: '30 min'),
  FoodItem(name: 'Mutton Rogan Josh', category: 'dinner',    emoji: '🥩', price: 299, rating: 4.8, time: '40 min', isBestseller: true),
  FoodItem(name: 'Veg Biryani',       category: 'dinner',    emoji: '🌾', price: 159, rating: 4.3, time: '25 min'),
];

// ─────────────────────────────────────────────
//  MenuScreen
// ─────────────────────────────────────────────
class MenuScreen extends StatefulWidget {
  final FoodCategory category;
  const MenuScreen({super.key, required this.category});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final List<_CartEntry> _cart = [];

  int _totalCount() =>
      _cart.fold(0, (sum, e) => sum + e.quantity);

  double _totalAmount() =>
      _cart.fold(0.0, (sum, e) => sum + e.item.price * e.quantity);

  int _quantityOf(String name) {
    final idx = _cart.indexWhere((e) => e.item.name == name);
    return idx == -1 ? 0 : _cart[idx].quantity;
  }

  void _add(FoodItem item) {
    setState(() {
      final idx = _cart.indexWhere((e) => e.item.name == item.name);
      if (idx == -1) {
        _cart.add(_CartEntry(item: item));
      } else {
        _cart[idx].quantity++;
      }
    });
  }

  void _decrement(FoodItem item) {
    setState(() {
      final idx = _cart.indexWhere((e) => e.item.name == item.name);
      if (idx == -1) return;
      if (_cart[idx].quantity > 1) {
        _cart[idx].quantity--;
      } else {
        _cart.removeAt(idx);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF121212) : const Color(0xFFF8F8F8);
    final items =
    allFoodItems.where((i) => i.category == widget.category.id).toList();

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: _kOrange,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded,
              color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '${widget.category.emoji}  ${widget.category.label}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: _kOrange,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      body: Stack(
        children: [
          // ── Food list ──────────────────────
          ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) => _FoodCard(
              item: items[i],
              isDark: isDark,
              quantity: _quantityOf(items[i].name),
              onAdd: () => _add(items[i]),
              onDecrement: () => _decrement(items[i]),
            ),
          ),

          // ── Sticky "View Cart" button ──────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _totalCount() == 0
                ? const SizedBox.shrink()
                : Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1E1E1E)
                    : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.10),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const CartScreen()),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _kOrange,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 54),
                  elevation: 4,
                  shadowColor: _kOrange.withValues(alpha: 0.4),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                child: Row(
                  children: [
                    // Item count badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${_totalCount()} item${_totalCount() > 1 ? 's' : ''}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      'View Cart',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '₹${_totalAmount().toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Food Card
// ─────────────────────────────────────────────
class _FoodCard extends StatelessWidget {
  final FoodItem item;
  final bool isDark;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onDecrement;

  const _FoodCard({
    required this.item,
    required this.isDark,
    required this.quantity,
    required this.onAdd,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final textMid =
    isDark ? const Color(0xFF999999) : const Color(0xFF6B6B6B);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : const Color(0xFFE8E8E8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // ── Emoji + Bestseller badge ───────
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF2A1500)
                      : _kOrangeLight,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(item.emoji,
                      style: const TextStyle(fontSize: 34)),
                ),
              ),
              if (item.isBestseller)
                Positioned(
                  top: -6,
                  left: -6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: _kOrange,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      '🔥 Best',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(width: 14),

          // ── Details ────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: TextStyle(
                    color: textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        color: Color(0xFFF39C12), size: 14),
                    const SizedBox(width: 3),
                    Text(
                      item.rating.toStringAsFixed(1),
                      style: TextStyle(
                        color: textMid,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.access_time_rounded,
                        color: Colors.grey, size: 13),
                    const SizedBox(width: 3),
                    Text(
                      item.time,
                      style: TextStyle(color: textMid, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '₹${item.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: _kOrange,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),

                    // ── Add button OR Qty stepper ──
                    quantity == 0
                        ? GestureDetector(
                      onTap: onAdd,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: _kOrange,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: _kOrange.withValues(alpha: 0.35),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add_rounded,
                                color: Colors.white, size: 16),
                            SizedBox(width: 4),
                            Text(
                              'Add',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                        : Row(
                      children: [
                        _QtyBtn(
                          icon: Icons.remove_rounded,
                          onTap: onDecrement,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10),
                          child: Text(
                            '$quantity',
                            style: TextStyle(
                              color: textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        _QtyBtn(
                          icon: Icons.add_rounded,
                          onTap: onAdd,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Quantity Button
// ─────────────────────────────────────────────
class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: _kOrange,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }
}