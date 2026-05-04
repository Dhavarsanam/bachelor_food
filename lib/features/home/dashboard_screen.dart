import 'package:bachelor_foods/features/cart/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bachelor_foods/features/coins/coin_service.dart';
import 'package:bachelor_foods/features/coins/coin_history_screen.dart';
import 'package:bachelor_foods/features/auth/screens/account_screen.dart';

// ─────────────────────────────────────────────
//  Navigation Helper
// ─────────────────────────────────────────────
class NavigationHelper {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static void navigateToDashboard(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const DashboardScreen()),
          (route) => false,
    );
  }
}

// ─────────────────────────────────────────────
//  Main App
// ─────────────────────────────────────────────
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, themeMode, _) {
        return MaterialApp(
          title: 'Bachelor Foods',
          navigatorKey: NavigationHelper.navigatorKey,
          theme: ThemeData.light().copyWith(
            primaryColor: const Color(0xFFFF6B2C),
            scaffoldBackgroundColor: const Color(0xFFF8F9FA),
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFFF6B2C),
              secondary: Color(0xFFFF6B2C),
            ),
          ),
          darkTheme: ThemeData.dark().copyWith(
            primaryColor: const Color(0xFFFF6B2C),
            scaffoldBackgroundColor: const Color(0xFF121212),
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFFF6B2C),
              secondary: Color(0xFFFF6B2C),
            ),
          ),
          themeMode: themeMode,
          home: const DashboardScreen(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
//  Theme Notifier
// ─────────────────────────────────────────────
class ThemeNotifier extends ValueNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.light);

  bool get isDark => value == ThemeMode.dark;

  void setLight() => value = ThemeMode.light;
  void setDark() => value = ThemeMode.dark;
}

final themeNotifier = ThemeNotifier();

// ─────────────────────────────────────────────
//  Colors
// ─────────────────────────────────────────────
const _kOrange = Color(0xFFFF6B2C);
const _kOrangeDark = Color(0xFFE84C0B);
const _kOrangeLight = Color(0xFFFFF0EB);
const _kOrangeExtraLight = Color(0xFFFFF7F0);
const _kCoinGold = Color(0xFFFFD700);
const _kCoinAmber = Color(0xFFFFC107);

// ─────────────────────────────────────────────
//  Mock Data
// ─────────────────────────────────────────────
class Hotel {
  final String id;
  final String name;
  final String imageUrl;
  final String rating;
  final String deliveryTime;
  final String cuisine;

  const Hotel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.deliveryTime,
    required this.cuisine,
  });
}

const _hotels = [
  Hotel(
    id: '1',
    name: 'Spice Garden',
    imageUrl: 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4',
    rating: '4.5',
    deliveryTime: '25-30 min',
    cuisine: 'North Indian, Chinese',
  ),
  Hotel(
    id: '2',
    name: 'Biryani House',
    imageUrl: 'https://images.unsplash.com/photo-1563379091339-03b21ab4a5f8',
    rating: '4.7',
    deliveryTime: '30-35 min',
    cuisine: 'Biryani, Mughlai',
  ),
  Hotel(
    id: '3',
    name: 'Pizza Piazza',
    imageUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591',
    rating: '4.6',
    deliveryTime: '20-25 min',
    cuisine: 'Italian, Fast Food',
  ),
  Hotel(
    id: '4',
    name: 'Roll Express',
    imageUrl: 'https://images.unsplash.com/photo-1626700051175-6818013e1d4f',
    rating: '4.4',
    deliveryTime: '15-20 min',
    cuisine: 'Street Food, Rolls',
  ),
];

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

const _allFoodItems = [
  FoodItem(name: 'Masala Omelette',     category: 'Breakfast', emoji: '🍳', price: 89,  rating: 4.5, time: '15 min', isBestseller: true),
  FoodItem(name: 'Poha',                category: 'Breakfast', emoji: '🥣', price: 59,  rating: 4.3, time: '10 min'),
  FoodItem(name: 'Idli Sambar',         category: 'Breakfast', emoji: '🫓', price: 69,  rating: 4.7, time: '12 min', isBestseller: true),
  FoodItem(name: 'Aloo Paratha',        category: 'Breakfast', emoji: '🫔', price: 99,  rating: 4.6, time: '20 min'),
  FoodItem(name: 'Upma',                category: 'Breakfast', emoji: '🥘', price: 55,  rating: 4.2, time: '10 min'),
  FoodItem(name: 'Pancakes',            category: 'Breakfast', emoji: '🥞', price: 129, rating: 4.7, time: '18 min'),
  FoodItem(name: 'French Toast',        category: 'Breakfast', emoji: '🍞', price: 109, rating: 4.4, time: '15 min'),
  FoodItem(name: 'Smoothie Bowl',       category: 'Breakfast', emoji: '🥣', price: 149, rating: 4.6, time: '10 min'),
  FoodItem(name: 'Chicken Biryani',     category: 'Lunch',     emoji: '🍛', price: 199, rating: 4.8, time: '30 min', isBestseller: true),
  FoodItem(name: 'Dal Tadka + Rice',    category: 'Lunch',     emoji: '🍚', price: 129, rating: 4.5, time: '25 min'),
  FoodItem(name: 'Paneer Butter Masala',category: 'Lunch',     emoji: '🧀', price: 169, rating: 4.6, time: '25 min', isBestseller: true),
  FoodItem(name: 'Veg Thali',           category: 'Lunch',     emoji: '🍱', price: 149, rating: 4.4, time: '20 min'),
  FoodItem(name: 'Chicken Curry',       category: 'Lunch',     emoji: '🍗', price: 189, rating: 4.7, time: '30 min'),
  FoodItem(name: 'Egg Curry',           category: 'Lunch',     emoji: '🥚', price: 119, rating: 4.3, time: '20 min'),
  FoodItem(name: 'Fish Fry',            category: 'Lunch',     emoji: '🐟', price: 209, rating: 4.6, time: '25 min'),
  FoodItem(name: 'Mutton Curry',        category: 'Lunch',     emoji: '🥩', price: 279, rating: 4.8, time: '35 min'),
  FoodItem(name: 'Samosa',              category: 'Snacks/Bakery', emoji: '🥟', price: 20,  rating: 4.5, time: '5 min', isBestseller: true),
  FoodItem(name: 'Vada Pav',            category: 'Snacks/Bakery', emoji: '🍔', price: 30,  rating: 4.6, time: '5 min'),
  FoodItem(name: 'Pav Bhaji',           category: 'Snacks/Bakery', emoji: '🍞', price: 89,  rating: 4.7, time: '12 min', isBestseller: true),
  FoodItem(name: 'Croissant',           category: 'Snacks/Bakery', emoji: '🥐', price: 79,  rating: 4.4, time: '3 min'),
  FoodItem(name: 'Chocolate Muffin',    category: 'Snacks/Bakery', emoji: '🧁', price: 69,  rating: 4.3, time: '2 min'),
  FoodItem(name: 'Garlic Bread',        category: 'Snacks/Bakery', emoji: '🥖', price: 99,  rating: 4.5, time: '8 min'),
  FoodItem(name: 'Spring Rolls',        category: 'Snacks/Bakery', emoji: '🌯', price: 89,  rating: 4.2, time: '10 min'),
  FoodItem(name: 'Onion Rings',         category: 'Snacks/Bakery', emoji: '🧅', price: 79,  rating: 4.1, time: '8 min'),
  FoodItem(name: 'Tandoori Chicken',    category: 'Dinner',    emoji: '🍖', price: 259, rating: 4.9, time: '35 min', isBestseller: true),
  FoodItem(name: 'Butter Naan + Gravy', category: 'Dinner',    emoji: '🫓', price: 179, rating: 4.6, time: '25 min'),
  FoodItem(name: 'Fish Curry',          category: 'Dinner',    emoji: '🐟', price: 229, rating: 4.5, time: '30 min'),
  FoodItem(name: 'Mutton Rogan Josh',   category: 'Dinner',    emoji: '🥩', price: 299, rating: 4.8, time: '40 min', isBestseller: true),
  FoodItem(name: 'Veg Biryani',         category: 'Dinner',    emoji: '🌾', price: 159, rating: 4.3, time: '25 min'),
  FoodItem(name: 'Chicken Steak',       category: 'Dinner',    emoji: '🥩', price: 349, rating: 4.7, time: '30 min'),
  FoodItem(name: 'Grilled Sandwich',    category: 'Dinner',    emoji: '🥪', price: 149, rating: 4.4, time: '15 min'),
  FoodItem(name: 'Pasta Alfredo',       category: 'Dinner',    emoji: '🍝', price: 189, rating: 4.5, time: '20 min'),
];

// ─────────────────────────────────────────────
//  CategoryItem Widget
// ─────────────────────────────────────────────
class CategoryItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? backgroundColor;
  final double? size;

  const CategoryItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor,
    this.backgroundColor,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final double itemSize = size ?? 80;
    final Color iconClr = iconColor ?? _kOrange;
    final Color bgClr = backgroundColor ?? iconClr.withOpacity(0.1);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: itemSize,
            height: itemSize,
            decoration: BoxDecoration(
              color: bgClr,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              size: itemSize * 0.45,
              color: iconClr,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2C3E50),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  CategoryScreen
// ─────────────────────────────────────────────
class CategoryScreen extends StatefulWidget {
  final String categoryName;
  final Color? categoryColor;
  final IconData? categoryIcon;

  const CategoryScreen({
    super.key,
    required this.categoryName,
    this.categoryColor,
    this.categoryIcon,
  });

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late List<FoodItem> _foodItems;
  final Map<int, int> _cartQuantities = {};

  @override
  void initState() {
    super.initState();
    _foodItems = _allFoodItems.where((item) => item.category == widget.categoryName).toList();
  }

  void _addToCart(int index) {
    final item = _foodItems[index];
    setState(() {
      _cartQuantities[index] = (_cartQuantities[index] ?? 0) + 1;
    });
    // ✅ Sync with globalCart so CartScreen shows items
    globalCartAdd(item.name, item.emoji, item.price);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added ${item.name} to cart'),
        backgroundColor: widget.categoryColor ?? _kOrange,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _removeFromCart(int index) {
    final item = _foodItems[index];
    setState(() {
      if ((_cartQuantities[index] ?? 0) > 0) {
        _cartQuantities[index] = _cartQuantities[index]! - 1;
        if (_cartQuantities[index] == 0) {
          _cartQuantities.remove(index);
        }
      }
    });
    // ✅ Sync with globalCart
    globalCartDecrement(item.name);
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = widget.categoryColor ?? _kOrange;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Row(
          children: [
            if (widget.categoryIcon != null)
              Icon(widget.categoryIcon, color: Colors.white, size: 24),
            if (widget.categoryIcon != null) const SizedBox(width: 10),
            Text(
              widget.categoryName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartScreen()),
                  );
                },
                icon: const Icon(Icons.shopping_cart_outlined),
              ),
              if (_cartQuantities.isNotEmpty)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: themeColor, width: 2),
                    ),
                    child: Text(
                      _cartQuantities.values.reduce((a, b) => a + b).toString(),
                      style: TextStyle(
                        color: themeColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _foodItems.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🍽️', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text(
              'No items found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Check back later for delicious options!',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.grey[400] : Colors.grey[500],
              ),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        itemCount: _foodItems.length,
        itemBuilder: (context, index) {
          final item = _foodItems[index];
          final quantity = _cartQuantities[index] ?? 0;

          return _FoodItemCard(
            item: item,
            themeColor: themeColor,
            quantity: quantity,
            onAdd: () => _addToCart(index),
            onRemove: () => _removeFromCart(index),
            isDark: isDark,
          );
        },
      ),
    );
  }
}

class _FoodItemCard extends StatelessWidget {
  final FoodItem item;
  final Color themeColor;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final bool isDark;

  const _FoodItemCard({
    required this.item,
    required this.themeColor,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final textSecondary = isDark ? Colors.grey[400] : Colors.grey[600];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: themeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      item.emoji,
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (item.isBestseller)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: themeColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                '🔥 POPULAR',
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.star_rounded, color: Colors.amber[600], size: 14),
                          const SizedBox(width: 4),
                          Text(
                            item.rating.toString(),
                            style: TextStyle(
                              fontSize: 12,
                              color: textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(Icons.access_time_rounded, color: textSecondary, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            item.time,
                            style: TextStyle(
                              fontSize: 12,
                              color: textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '₹${item.price.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: themeColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: themeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (quantity > 0)
                        IconButton(
                          onPressed: onRemove,
                          icon: const Icon(Icons.remove, size: 18),
                          color: themeColor,
                          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                          padding: EdgeInsets.zero,
                        ),
                      if (quantity > 0)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            quantity.toString(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: themeColor,
                            ),
                          ),
                        ),
                      IconButton(
                        onPressed: onAdd,
                        icon: Icon(quantity > 0 ? Icons.add : Icons.add_shopping_cart, size: 18),
                        color: themeColor,
                        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  DashboardScreen
// ─────────────────────────────────────────────
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeContent(),
    CartContent(),
    SubscriptionContent(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: _buildBottomNav(isDark),
    );
  }

  Widget _buildBottomNav(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_rounded,
                label: 'Home',
                isSelected: _currentIndex == 0,
                onTap: () {
                  setState(() {
                    _currentIndex = 0;
                  });
                  // Clear navigation stack when home button is pressed
                  // This ensures we're always on the main dashboard
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),
              _NavItem(
                icon: Icons.shopping_cart_rounded,
                label: 'Cart',
                isSelected: _currentIndex == 1,
                onTap: () => setState(() => _currentIndex = 1),
              ),
              _NavItem(
                icon: Icons.card_membership_rounded,
                label: 'Subscription',
                isSelected: _currentIndex == 2,
                onTap: () => setState(() => _currentIndex = 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Nav Item ─────────────────────────────────
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? _kOrange : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: _kOrange.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? Colors.white : Colors.grey, size: 22),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  HomeContent (Main Dashboard UI)
// ─────────────────────────────────────────────
class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  static const String _userInitials = 'AK';
  bool _isSubscribed = true;
  int _coinBalance = 0;

  @override
  void initState() {
    super.initState();
    _loadCoins();
  }

  Future<void> _loadCoins() async {
    final subbed = await CoinService.isSubscribed();
    final bal = await CoinService.getBalance();
    if (mounted) setState(() { _isSubscribed = subbed; _coinBalance = bal; });
  }

  final List<Map<String, dynamic>> _categories = const [
    {'name': 'Breakfast', 'icon': Icons.wb_sunny, 'color': Color(0xFFFFA726)},
    {'name': 'Lunch', 'icon': Icons.lunch_dining, 'color': Color(0xFF66BB6A)},
    {'name': 'Snacks/Bakery', 'icon': Icons.bakery_dining, 'color': Color(0xFFEF5350)},
    {'name': 'Dinner', 'icon': Icons.nights_stay, 'color': Color(0xFF7E57C2)},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA);
    final textPrimary = isDark ? Colors.white : const Color(0xFF1A1A1A);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: _buildAppBar(context, isDark),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            _buildWelcomeBanner(isDark, context),

            const SizedBox(height: 24),

            // Categories Section - TOP
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '🍕 Categories',
                style: TextStyle(
                  color: textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.1,
                ),
              ),
            ),

            const SizedBox(height: 16),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.0,
              ),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return CategoryItem(
                  icon: category['icon'] as IconData,
                  title: category['name'] as String,
                  iconColor: category['color'] as Color,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryScreen(
                          categoryName: category['name'] as String,
                          categoryColor: category['color'] as Color,
                          categoryIcon: category['icon'] as IconData,
                        ),
                      ),
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 32),

            // Hotels Section - BELOW Categories
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '🏨 Popular Hotels',
                    style: TextStyle(
                      color: textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.1,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: _kOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'View All',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              height: 270,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                physics: const BouncingScrollPhysics(),
                itemCount: _hotels.length,
                itemBuilder: (context, index) {
                  final hotelItem = _hotels[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: _HotelCard(
                      hotel: hotelItem,
                      isDark: isDark,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HotelDetailScreen(hotel: hotelItem),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isDark) {
    return AppBar(
      backgroundColor: _kOrange,
      elevation: 0,
      automaticallyImplyLeading: false,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: _kOrange,
        statusBarIconBrightness: Brightness.light,
      ),
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bachelor Foods',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 18,
              letterSpacing: 0.2,
            ),
          ),
          SizedBox(height: 2),
          Row(
            children: [
              Icon(Icons.location_on_rounded, color: Colors.white70, size: 12),
              SizedBox(width: 2),
              Text(
                'Delivering to: Home',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        if (_isSubscribed)
          GestureDetector(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CoinHistoryScreen()),
              );
              _loadCoins();
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: _kCoinGold.withValues(alpha: 0.60),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [_kCoinGold, _kCoinAmber],
                      ),
                    ),
                    child: const Icon(
                      Icons.monetization_on_rounded,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Earn Coins',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          height: 1.1,
                        ),
                      ),
                      Text(
                        '$_coinBalance pts',
                        style: const TextStyle(
                          color: _kCoinGold,
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AccountScreen()),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFF9F6B), Color(0xFFFF6B2C)],
              ),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.80),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                _userInitials,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeBanner(bool isDark, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF2A1500), const Color(0xFF1A0A00)]
              : [const Color(0xFFFF8C42), _kOrangeDark],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _kOrange.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good Morning! 👋',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'What would you\nlike to eat today?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.20),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.30)),
                  ),
                  child: const Text(
                    '🚀  30 min delivery',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Text('🍽️', style: TextStyle(fontSize: 52)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  HotelDetailScreen
// ─────────────────────────────────────────────
class HotelDetailScreen extends StatelessWidget {
  final Hotel hotel;

  const HotelDetailScreen({super.key, required this.hotel});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? Colors.white : const Color(0xFF1A1A1A);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(hotel.name),
        backgroundColor: _kOrange,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(hotel.imageUrl),
                fit: BoxFit.cover,
                onError: (exception, stackTrace) => const AssetImage('assets/placeholder.png') as ImageProvider,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hotel.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Color(0xFFF39C12), size: 18),
                      const SizedBox(width: 4),
                      Text(
                        hotel.rating,
                        style: TextStyle(fontSize: 16, color: textPrimary),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.access_time_rounded, color: Colors.grey, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        hotel.deliveryTime,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    hotel.cuisine,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Menu',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: const Text('🍽️', style: TextStyle(fontSize: 28)),
                            title: Text('Sample Item ${index + 1}'),
                            subtitle: Text('₹${(index + 1) * 50}'),
                            trailing: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _kOrange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text('Add'),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Hotel Card
// ─────────────────────────────────────────────
class _HotelCard extends StatelessWidget {
  final Hotel hotel;
  final bool isDark;
  final VoidCallback onTap;

  const _HotelCard({
    required this.hotel,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final textMid = isDark ? const Color(0xFF999999) : const Color(0xFF6B6B6B);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 210,
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Stack(
                children: [
                  Image.network(
                    hotel.imageUrl,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 140,
                        width: double.infinity,
                        color: _kOrangeExtraLight,
                        child: Center(
                          child: Text(
                            hotel.name[0],
                            style: const TextStyle(fontSize: 56, color: _kOrange),
                          ),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded, color: Color(0xFFF39C12), size: 12),
                          const SizedBox(width: 4),
                          Text(
                            hotel.rating,
                            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hotel.name,
                    style: TextStyle(
                      color: textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.access_time_rounded, color: Colors.grey, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        hotel.deliveryTime,
                        style: TextStyle(color: textMid, fontSize: 11),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hotel.cuisine,
                    style: TextStyle(color: textMid, fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Profile Bottom Sheet
// ─────────────────────────────────────────────
class _ProfileBottomSheet extends StatelessWidget {
  final bool isDark;

  const _ProfileBottomSheet({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final textMid = isDark ? const Color(0xFF999999) : const Color(0xFF6B6B6B);

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withValues(alpha: 0.20) : Colors.grey.withValues(alpha: 0.30),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFFF9F6B), _kOrange],
                  ),
                  border: Border.all(
                    color: _kOrangeLight,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _kOrange.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'AK',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Arjun Kumar',
                style: TextStyle(
                  color: textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'arjun.kumar@email.com',
                style: TextStyle(color: textMid, fontSize: 14),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: _kOrangeExtraLight,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: _kOrange.withValues(alpha: 0.2)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.card_membership_rounded, color: _kOrange, size: 16),
                    SizedBox(width: 8),
                    Text(
                      'Premium Subscriber',
                      style: TextStyle(
                        color: _kOrange,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2A2A2A) : _kOrangeExtraLight,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _kCoinGold.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [_kCoinGold, _kCoinAmber],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _kCoinGold.withValues(alpha: 0.4),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.monetization_on_rounded, color: Colors.white, size: 26),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Coin Balance', style: TextStyle(color: textMid, fontSize: 13)),
                        Text(
                          '340 pts',
                          style: TextStyle(
                            color: textPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [_kCoinAmber, _kCoinGold],
                        ),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: _kCoinGold.withValues(alpha: 0.3),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: const Text(
                        'Earn More',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Cart Tab Content
// ─────────────────────────────────────────────
// ✅ CartContent now shows the real CartScreen
class CartContent extends StatelessWidget {
  const CartContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const CartScreen();
  }
}

// ─────────────────────────────────────────────
//  Subscription Tab Content
// ─────────────────────────────────────────────
// ─────────────────────────────────────────────
//  Subscription Data Models
// ─────────────────────────────────────────────
class _SubscriptionPlan {
  final String title;
  final String emoji;
  final double weeklyPrice;
  final double monthlyPrice;
  final String description;
  final List<String> includes;

  const _SubscriptionPlan({
    required this.title,
    required this.emoji,
    required this.weeklyPrice,
    required this.monthlyPrice,
    required this.description,
    required this.includes,
  });
}

const _breakfastPlans = [
  _SubscriptionPlan(
    title: 'Basic Breakfast',
    emoji: '🍳',
    weeklyPrice: 400,
    monthlyPrice: 1400,
    description: 'Simple & filling morning meals',
    includes: ['Idli / Dosa', 'Sambar 130g', 'Chutney 100g'],
  ),
  _SubscriptionPlan(
    title: 'South Indian Combo',
    emoji: '🥘',
    weeklyPrice: 550,
    monthlyPrice: 1900,
    description: 'Authentic south indian flavors',
    includes: ['Pongal / Upma', 'Sambar 150g', 'Coconut Chutney', 'Filter Coffee'],
  ),
  _SubscriptionPlan(
    title: 'Healthy Start',
    emoji: '🥗',
    weeklyPrice: 650,
    monthlyPrice: 2300,
    description: 'Nutritious & balanced breakfast',
    includes: ['Oats Porridge / Poha', 'Fruit Bowl', 'Boiled Eggs × 2', 'Green Tea'],
  ),
];

const _lunchPlans = [
  _SubscriptionPlan(
    title: 'Basic Meals',
    emoji: '🍱',
    weeklyPrice: 700,
    monthlyPrice: 2500,
    description: 'Home-style wholesome lunch',
    includes: ['Rice 300g', 'Dal / Sambar', 'Vegetable Curry', 'Papad'],
  ),
  _SubscriptionPlan(
    title: 'Full Thali',
    emoji: '🥙',
    weeklyPrice: 950,
    monthlyPrice: 3400,
    description: 'Complete balanced thali',
    includes: ['Rice + 2 Chapati', 'Dal + Sabzi', 'Curd', 'Pickle', 'Sweet'],
  ),
  _SubscriptionPlan(
    title: 'Non-Veg Combo',
    emoji: '🍗',
    weeklyPrice: 1100,
    monthlyPrice: 3900,
    description: 'Protein rich non-veg meals',
    includes: ['Rice 300g', 'Chicken / Fish Curry', 'Dal', 'Rasam', 'Curd'],
  ),
];

const _dinnerPlans = [
  _SubscriptionPlan(
    title: 'Light Dinner',
    emoji: '🫓',
    weeklyPrice: 500,
    monthlyPrice: 1800,
    description: 'Light & easy on digestion',
    includes: ['Chapati × 3', 'Dal Fry', 'Vegetable Sabzi'],
  ),
  _SubscriptionPlan(
    title: 'Comfort Dinner',
    emoji: '🍲',
    weeklyPrice: 750,
    monthlyPrice: 2700,
    description: 'Warm & comforting night meals',
    includes: ['Rice / Chapati × 2', 'Paneer / Egg Curry', 'Dal', 'Salad'],
  ),
  _SubscriptionPlan(
    title: 'Premium Dinner',
    emoji: '🥘',
    weeklyPrice: 1000,
    monthlyPrice: 3600,
    description: 'Restaurant quality dinner',
    includes: ['Biryani / Pulao', 'Gravy Curry', 'Raita', 'Papad', 'Dessert'],
  ),
];

// Weekly schedule per meal type
const _weeklySchedule = {
  'Breakfast': [
    {'day': 'Monday', 'items': 'Rava Idly × 4 pcs\nSambar | 130g\nTomato Chutney | 100g'},
    {'day': 'Tuesday', 'items': 'Masala Dosa × 2\nSambar | 150g\nCoconut Chutney | 100g'},
    {'day': 'Wednesday', 'items': 'Poha | 250g\nMixture | 50g\nTea / Coffee'},
    {'day': 'Thursday', 'items': 'Idly × 4 pcs\nSambar | 130g\nGreen Chutney | 80g'},
    {'day': 'Friday', 'items': 'Upma | 250g\nPeanut Chutney | 80g\nFilter Coffee'},
    {'day': 'Saturday', 'items': 'Pongal | 250g\nSambar | 150g\nCoconut Chutney | 100g'},
    {'day': 'Sunday', 'items': 'Bread Toast × 4\nOmelette × 1\nButter | 20g'},
  ],
  'Lunch': [
    {'day': 'Monday', 'items': 'Rice 300g\nDal Fry\nAloo Sabzi\nPapad'},
    {'day': 'Tuesday', 'items': 'Rice 300g\nRasam\nCabbage Poriyal\nCurd'},
    {'day': 'Wednesday', 'items': 'Chapati × 3\nPaneer Butter Masala\nDal'},
    {'day': 'Thursday', 'items': 'Rice 300g\nSambar\nBrinjal Curry\nPapad'},
    {'day': 'Friday', 'items': 'Chapati × 2\nRice 200g\nMixed Veg Curry\nCurd'},
    {'day': 'Saturday', 'items': 'Veg Biryani 350g\nRaita\nPapad\nPickle'},
    {'day': 'Sunday', 'items': 'Special Thali\nRice + Chapati × 2\nDal + Sabzi + Sweet'},
  ],
  'Dinner': [
    {'day': 'Monday', 'items': 'Chapati × 3\nDal Tadka\nAloo Jeera'},
    {'day': 'Tuesday', 'items': 'Rice 250g\nRasam\nPoriyal\nCurd'},
    {'day': 'Wednesday', 'items': 'Chapati × 2\nPaneer Sabzi\nDal'},
    {'day': 'Thursday', 'items': 'Khichdi 300g\nCurd\nPapad\nPickle'},
    {'day': 'Friday', 'items': 'Chapati × 3\nChhole\nRaita'},
    {'day': 'Saturday', 'items': 'Pulao 300g\nRaita\nPapad\nSalad'},
    {'day': 'Sunday', 'items': 'Special Dinner\nRice / Chapati\nCurry + Sweet'},
  ],
};

class SubscriptionContent extends StatefulWidget {
  const SubscriptionContent({super.key});

  @override
  State<SubscriptionContent> createState() => _SubscriptionContentState();
}

class _SubscriptionContentState extends State<SubscriptionContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _planType = 'Weekly'; // Weekly | Monthly
  DateTime? _startDate;
  DateTime? _endDate;
  String _activeTab = 'Breakfast';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      final tabs = ['Breakfast', 'Lunch', 'Dinner'];
      setState(() => _activeTab = tabs[_tabController.index]);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<_SubscriptionPlan> get _currentPlans {
    switch (_activeTab) {
      case 'Lunch': return _lunchPlans;
      case 'Dinner': return _dinnerPlans;
      default: return _breakfastPlans;
    }
  }

  Future<void> _pickDate(bool isStart) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? now : (_startDate ?? now).add(const Duration(days: 7)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: _kOrange,
            onPrimary: Colors.white,
            surface: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          // Auto set end date
          _endDate = picked.add(Duration(days: _planType == 'Weekly' ? 7 : 30));
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _showWeeklySchedule(_SubscriptionPlan plan) {
    final schedule = _weeklySchedule[_activeTab] ?? [];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.92,
        minChildSize: 0.4,
        builder: (_, ctrl) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  children: [
                    Text(plan.emoji, style: const TextStyle(fontSize: 28)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(plan.title,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: _kOrangeDark)),
                          Text('Weekly Schedule',
                              style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.separated(
                  controller: ctrl,
                  padding: const EdgeInsets.all(16),
                  itemCount: schedule.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) {
                    final day = schedule[i];
                    // Calculate date if start date selected
                    String dateStr = '';
                    if (_startDate != null) {
                      final d = _startDate!.add(Duration(days: i));
                      dateStr = '${d.day}/${d.month}';
                    }
                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: i % 2 == 0 ? const Color(0xFFFFF0EB) : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: i % 2 == 0 ? _kOrange.withValues(alpha: 0.2) : Colors.grey.shade200,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 80,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(day['day']!,
                                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: _kOrangeDark)),
                                if (dateStr.isNotEmpty)
                                  Text(dateStr,
                                      style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Text(day['items']!,
                                style: const TextStyle(fontSize: 12.5, height: 1.6, color: Color(0xFF444444))),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _orderNow(_SubscriptionPlan plan) {
    if (_startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select a start date first!'),
          backgroundColor: _kOrange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }
    final price = _planType == 'Weekly' ? plan.weeklyPrice : plan.monthlyPrice;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Text(plan.emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 8),
            Expanded(child: Text(plan.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800))),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InfoRow('Plan', _planType),
            _InfoRow('Meal', _activeTab),
            _InfoRow('Start', '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}'),
            if (_endDate != null)
              _InfoRow('End', '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF0EB),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Amount', style: TextStyle(fontWeight: FontWeight.w700, color: _kOrangeDark)),
                  Text('₹${price.toStringAsFixed(0)}',
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: _kOrange)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('🎉 ${plan.title} subscription confirmed!'),
                  backgroundColor: _kOrange,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _kOrange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Confirm Order', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5);
    final cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textP = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final textS = isDark ? const Color(0xFF999999) : const Color(0xFF6B6B6B);
    final divColor = isDark ? Colors.white12 : const Color(0xFFE8E8E8);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: _kOrange,
        title: const Text('Subscription',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 20)),
        automaticallyImplyLeading: false,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: _kOrange,
          statusBarIconBrightness: Brightness.light,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: _kOrange,
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white60,
              labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, letterSpacing: 0.5),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
              tabs: const [
                Tab(text: 'BREAKFAST'),
                Tab(text: 'LUNCH'),
                Tab(text: 'DINNER'),
              ],
            ),
          ),
        ),
      ),

      body: Column(
        children: [
          // ── Plan Type + Date Picker Card ──────
          Container(
            margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: divColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Weekly / Monthly toggle
                Row(
                  children: [
                    _PlanTypeChip(
                      label: 'Weekly',
                      isSelected: _planType == 'Weekly',
                      onTap: () => setState(() => _planType = 'Weekly'),
                    ),
                    const SizedBox(width: 12),
                    _PlanTypeChip(
                      label: 'Monthly',
                      isSelected: _planType == 'Monthly',
                      onTap: () => setState(() => _planType = 'Monthly'),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                // Date pickers
                Row(
                  children: [
                    Expanded(
                      child: _DatePickerBox(
                        label: 'Start Date',
                        date: _startDate,
                        onTap: () => _pickDate(true),
                        textP: textP,
                        textS: textS,
                        divColor: divColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _DatePickerBox(
                        label: 'End Date',
                        date: _endDate,
                        onTap: () => _pickDate(false),
                        textP: textP,
                        textS: textS,
                        divColor: divColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Menu label ───────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
            child: Row(
              children: [
                Text('Menu Plans',
                  style: TextStyle(
                    color: textP,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0EB),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(_planType,
                      style: const TextStyle(color: _kOrange, fontSize: 11, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),

          // ── Plan Cards ────────────────────────
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: ['Breakfast', 'Lunch', 'Dinner'].map((mealType) {
                final plans = mealType == 'Breakfast'
                    ? _breakfastPlans
                    : mealType == 'Lunch'
                    ? _lunchPlans
                    : _dinnerPlans;
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 100),
                  itemCount: plans.length,
                  itemBuilder: (_, i) => _PlanCard(
                    plan: plans[i],
                    planType: _planType,
                    cardBg: cardBg,
                    textP: textP,
                    textS: textS,
                    divColor: divColor,
                    onViewMenu: () => _showWeeklySchedule(plans[i]),
                    onOrderNow: () => _orderNow(plans[i]),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Info Row (for dialog) ─────────────────────
class _InfoRow extends StatelessWidget {
  final String label, value;
  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
        ],
      ),
    );
  }
}

// ── Plan Type Chip ────────────────────────────
class _PlanTypeChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _PlanTypeChip({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20, height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: isSelected ? _kOrange : Colors.grey.shade400, width: 2),
            ),
            child: isSelected
                ? Center(
              child: Container(
                width: 10, height: 10,
                decoration: const BoxDecoration(color: _kOrange, shape: BoxShape.circle),
              ),
            )
                : null,
          ),
          const SizedBox(width: 6),
          Text(label,
              style: TextStyle(
                color: isSelected ? _kOrange : Colors.grey.shade600,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 14,
              )),
        ],
      ),
    );
  }
}

// ── Date Picker Box ───────────────────────────
class _DatePickerBox extends StatelessWidget {
  final String label;
  final DateTime? date;
  final VoidCallback onTap;
  final Color textP, textS, divColor;
  const _DatePickerBox({
    required this.label, required this.date, required this.onTap,
    required this.textP, required this.textS, required this.divColor,
  });

  @override
  Widget build(BuildContext context) {
    final hasDate = date != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: hasDate ? _kOrange : divColor, width: hasDate ? 1.5 : 1),
          borderRadius: BorderRadius.circular(10),
          color: hasDate ? const Color(0xFFFFF0EB) : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today_rounded,
                size: 16, color: hasDate ? _kOrange : textS),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: TextStyle(fontSize: 10, color: textS, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 2),
                  Text(
                    hasDate
                        ? '${date!.day}/${date!.month}/${date!.year}'
                        : 'Select',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: hasDate ? _kOrange : textS,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Plan Card ─────────────────────────────────
class _PlanCard extends StatelessWidget {
  final _SubscriptionPlan plan;
  final String planType;
  final Color cardBg, textP, textS, divColor;
  final VoidCallback onViewMenu, onOrderNow;

  const _PlanCard({
    required this.plan, required this.planType,
    required this.cardBg, required this.textP, required this.textS, required this.divColor,
    required this.onViewMenu, required this.onOrderNow,
  });

  @override
  Widget build(BuildContext context) {
    final price = planType == 'Weekly' ? plan.weeklyPrice : plan.monthlyPrice;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: divColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Header ──
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0EB),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Container(
                  width: 52, height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _kOrange.withValues(alpha: 0.2)),
                  ),
                  child: Center(child: Text(plan.emoji, style: const TextStyle(fontSize: 26))),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(plan.title,
                          style: const TextStyle(
                            color: _kOrangeDark,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          )),
                      const SizedBox(height: 2),
                      Text(plan.description,
                          style: TextStyle(
                            color: _kOrange.withValues(alpha: 0.7),
                            fontSize: 12,
                          )),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('₹${price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: _kOrange,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        )),
                    Text('/ $planType',
                        style: TextStyle(
                          color: _kOrange.withValues(alpha: 0.6),
                          fontSize: 11,
                        )),
                  ],
                ),
              ],
            ),
          ),

          // ── Includes ──
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Includes:',
                    style: TextStyle(
                        color: textS, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6, runSpacing: 6,
                  children: plan.includes.map((item) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: divColor),
                    ),
                    child: Text(item,
                        style: TextStyle(fontSize: 11, color: textP, fontWeight: FontWeight.w500)),
                  )).toList(),
                ),
              ],
            ),
          ),

          // ── Buttons ──
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onViewMenu,
                    icon: const Icon(Icons.calendar_month_rounded, size: 16, color: _kOrange),
                    label: const Text('View Menu',
                        style: TextStyle(color: _kOrange, fontWeight: FontWeight.w700, fontSize: 13)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: _kOrange, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onOrderNow,
                    icon: const Icon(Icons.shopping_bag_rounded, size: 16, color: Colors.white),
                    label: const Text('Order Now',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _kOrange,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}