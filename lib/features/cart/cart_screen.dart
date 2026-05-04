import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:bachelor_foods/features/coins/coin_service.dart';

// ─────────────────────────────────────────────
//  Constants
// ─────────────────────────────────────────────
const _kOrange = Color(0xFFFF6B2C);
const _kOrangeLight = Color(0xFFFFF0EB);
const _kOrangeDark = Color(0xFFE84C0B);

// ──────────────────────────────────────────────────────────────────────────────
//  🔑 RAZORPAY KEY — Replace with your actual key from https://dashboard.razorpay.com
//     Test key  → rzp_test_XXXXXXXXXXXXXXXX
//     Live key  → rzp_live_XXXXXXXXXXXXXXXX
// ──────────────────────────────────────────────────────────────────────────────
const _kRazorpayKey = 'rzp_test_XXXXXXXXXXXXXXXX'; // ← REPLACE THIS

// ─────────────────────────────────────────────
//  Global Cart State
// ─────────────────────────────────────────────
class CartEntry {
  final String name;
  final String emoji;
  final double price;
  int quantity;

  CartEntry({
    required this.name,
    required this.emoji,
    required this.price,
    this.quantity = 1,
  });
}

// Global cart list — shared across MenuScreen and CartScreen
final List<CartEntry> globalCart = [];

int get globalCartCount =>
    globalCart.fold(0, (sum, e) => sum + e.quantity);

double get globalCartTotal =>
    globalCart.fold(0.0, (sum, e) => sum + e.price * e.quantity);

void globalCartAdd(String name, String emoji, double price) {
  final idx = globalCart.indexWhere((e) => e.name == name);
  if (idx == -1) {
    globalCart.add(CartEntry(name: name, emoji: emoji, price: price));
  } else {
    globalCart[idx].quantity++;
  }
}

void globalCartDecrement(String name) {
  final idx = globalCart.indexWhere((e) => e.name == name);
  if (idx == -1) return;
  if (globalCart[idx].quantity > 1) {
    globalCart[idx].quantity--;
  } else {
    globalCart.removeAt(idx);
  }
}

// ─────────────────────────────────────────────
//  Time Slots
// ─────────────────────────────────────────────
const _lunchSlots = [
  '11:30 AM', '12:00 PM', '12:30 PM',
  '01:00 PM', '01:30 PM', '02:00 PM',
  '02:30 PM', '03:00 PM', '03:30 PM',
  '04:00 PM', '04:30 PM',
];

// ─────────────────────────────────────────────
//  CartScreen
// ─────────────────────────────────────────────
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // ── Razorpay ────────────────────────────────
  late Razorpay _razorpay;

  bool _isSubscribed = false;
  int _coinBalance = 0;
  int _coinsToRedeem = 0;
  bool _isProcessingPayment = false;

  // Delivery Address
  String _address =
      'Anna Statue, 143A, N Veli St, Near Moon Auto Consultancy, Nelpettai, Simmakkal, Madurai Main, Madurai, Tamil Nadu, 625001, India';
  String _receiverName = 'Your Name';
  String _receiverPhone = '+91 98765 43210';

  // Special instructions
  final _instrCtrl = TextEditingController(text: 'Prefer "Less Spicy"');

  // Time slot
  String? _selectedSlot;

  // Payment
  String _paymentMethod = 'razorpay'; // 'razorpay' | 'cod'

  // Today's date banner
  String get _todayBanner {
    final now = DateTime.now();
    final d = '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}';
    return 'Whoa. You have a healthy Lunch here! ($d) 🌅';
  }

  // Coins earned from this order (preview)
  int get _coinsEarned => ((globalCartTotal / 100) * 10).floor();

  // Payable amount after coin discount
  double get _payableAmount =>
      (globalCartTotal - _coinsToRedeem).clamp(0, double.infinity);

  @override
  void initState() {
    super.initState();
    _loadCoins();
    _initRazorpay();
  }

  // ── Razorpay Init ────────────────────────────
  void _initRazorpay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _onPaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _onPaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _onExternalWallet);
  }

  // ── Razorpay Callbacks ───────────────────────
  void _onPaymentSuccess(PaymentSuccessResponse response) {
    debugPrint('✅ Payment Success: ${response.paymentId}');
    _confirmOrder(paymentId: response.paymentId);
  }

  void _onPaymentError(PaymentFailureResponse response) {
    debugPrint('❌ Payment Error: ${response.code} | ${response.message}');
    if (!mounted) return;
    setState(() => _isProcessingPayment = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment failed: ${response.message ?? "Please try again"}'),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _onExternalWallet(ExternalWalletResponse response) {
    debugPrint('👛 External Wallet: ${response.walletName}');
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Processing via ${response.walletName}...'),
        backgroundColor: _kOrange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  void dispose() {
    _razorpay.clear(); // ✅ Important: release Razorpay resources
    _instrCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadCoins() async {
    final subbed = await CoinService.isSubscribed();
    final bal = await CoinService.getBalance();
    if (mounted) {
      setState(() {
        _isSubscribed = subbed;
        _coinBalance = bal;
      });
    }
  }

  void _add(String name, String emoji, double price) =>
      setState(() => globalCartAdd(name, emoji, price));

  void _decrement(String name) =>
      setState(() => globalCartDecrement(name));

  // ── Place Order ──────────────────────────────
  Future<void> _placeOrder() async {
    if (globalCart.isEmpty) return;

    if (_paymentMethod == 'razorpay') {
      _openRazorpay();
    } else {
      _confirmOrder();
    }
  }

  // ── Open Razorpay Checkout ───────────────────
  void _openRazorpay() {
    setState(() => _isProcessingPayment = true);

    // Amount must be in PAISE (multiply by 100)
    final amountInPaise = (_payableAmount * 100).round();

    final options = <String, dynamic>{
      'key': _kRazorpayKey,
      'amount': amountInPaise,
      'name': 'Bachelor Foods',
      'description': 'Food Order — ${globalCart.length} item(s)',
      'prefill': {
        'contact': _receiverPhone.replaceAll(RegExp(r'[^\d+]'), ''),
        'name': _receiverName,
      },
      'theme': {
        'color': '#FF6B2C', // Orange brand color
      },
      'notes': {
        'address': _address,
        'timeslot': _selectedSlot ?? 'Not selected',
        'instructions': _instrCtrl.text,
      },
      // Uncomment below for UPI intent on Android:
      // 'method': {
      //   'upi': true,
      //   'card': true,
      //   'wallet': true,
      //   'netbanking': true,
      // },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Razorpay open error: $e');
      setState(() => _isProcessingPayment = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open payment: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // ── Confirm Order (after payment / COD) ──────
  Future<void> _confirmOrder({String? paymentId}) async {
    final orderTotal = globalCartTotal;

    if (_coinsToRedeem > 0) {
      await CoinService.redeemCoins(_coinsToRedeem);
    }
    final earned = await CoinService.earnFromOrder(orderTotal);

    setState(() {
      globalCart.clear();
      _isProcessingPayment = false;
    });
    if (!mounted) return;

    final msg = paymentId != null
        ? (earned > 0
        ? '🎉 Payment successful! Earned $earned coins 🪙'
        : '🎉 Payment successful! Order placed.')
        : (earned > 0
        ? '🎉 Order placed! You earned $earned coins 🪙'
        : '🎉 Order placed successfully!');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: _kOrange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
    Navigator.pop(context);
  }

  // ─────────────────────────────────────────────
  //  Build
  // ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5);
    final cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textP = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final textS = isDark ? const Color(0xFF999999) : const Color(0xFF6B6B6B);
    final divider = isDark ? Colors.white12 : const Color(0xFFE8E8E8);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: cardBg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: textP),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Cart',
          style: TextStyle(
            color: textP,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
      ),

      body: globalCart.isEmpty
      // ── Empty state ───────────────────
          ? Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: const Center(
                child: Text('🛒', style: TextStyle(fontSize: 52)),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Your cart is empty',
              style: TextStyle(
                color: textP,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Add items from the menu to get started.',
              style: TextStyle(color: textS, fontSize: 14),
            ),
          ],
        ),
      )

      // ── Full cart UI ─────────────────
          : Stack(
        children: [
          ListView(
            padding: const EdgeInsets.only(bottom: 100),
            children: [
              // ── Banner ──────────────────────
              Container(
                margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: _kOrangeLight,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _kOrange.withValues(alpha: 0.2)),
                ),
                child: Text(
                  _todayBanner,
                  style: const TextStyle(
                    color: _kOrangeDark,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // ── Restaurant header ────────────
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: divider),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: _kOrangeLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text('🍽️', style: TextStyle(fontSize: 28)),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bachelor Foods',
                          style: TextStyle(
                            color: textP,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Your favorite meals, delivered fast',
                          style: TextStyle(
                            color: textS,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ── Items Section ────────────────
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: divider),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Items',
                      style: TextStyle(
                        color: textP,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 14),
                    ...globalCart.map((entry) => _CartItemRow(
                      entry: entry,
                      textP: textP,
                      textS: textS,
                      divider: divider,
                      onAdd: () => _add(entry.name, entry.emoji, entry.price),
                      onDecrement: () => _decrement(entry.name),
                    )),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.add, size: 18, color: _kOrange),
                        label: const Text(
                          'ADD MORE ITEMS',
                          style: TextStyle(
                            color: _kOrange,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: _kOrange, width: 1.5),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ── Special Instructions ─────────
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: divider),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Special Instructions',
                      style: TextStyle(
                        color: textP,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _instrCtrl,
                      maxLines: 2,
                      style: TextStyle(color: textP, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Add special instructions...',
                        hintStyle: TextStyle(color: textS),
                        filled: true,
                        fillColor: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF8F8F8),
                        suffixIcon: const Icon(Icons.add_box_outlined, color: _kOrange),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: divider),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: divider),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: _kOrange, width: 1.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ── Delivery Address ─────────────
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: divider),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Delivery Address',
                          style: TextStyle(
                            color: textP,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _editAddress(context),
                          child: const Text(
                            'Edit Address',
                            style: TextStyle(
                              color: _kOrange,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              decoration: TextDecoration.underline,
                              decorationColor: _kOrange,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            border: Border.all(color: divider),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.location_on_outlined, color: textP, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _address,
                            style: TextStyle(color: textS, fontSize: 13, height: 1.5),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Divider(color: divider, height: 1),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Receiver details for this address',
                              style: TextStyle(color: textS, fontSize: 12),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$_receiverName |\n$_receiverPhone',
                              style: TextStyle(
                                color: textP,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: _kOrange),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          child: const Text(
                            'Ordering For\nSomeone?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _kOrange,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ── Delivery Timeslot ────────────
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: divider),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Delivery Timeslot',
                          style: TextStyle(
                            color: textP,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Lunch',
                          style: TextStyle(color: textS, fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _lunchSlots.map((slot) {
                        final isSelected = _selectedSlot == slot;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedSlot = slot),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? _kOrangeLight : (isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF8F8F8)),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected ? _kOrange : divider,
                                width: isSelected ? 1.5 : 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '🌅',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isSelected ? _kOrange : null,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  slot,
                                  style: TextStyle(
                                    color: isSelected ? _kOrange : textP,
                                    fontSize: 13,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ── Payment Method ───────────────
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: divider),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment Method',
                      style: TextStyle(
                        color: textS,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _PaymentOption(
                      icon: Icons.bolt_rounded,
                      label: 'Pay using Razorpay',
                      sublabel: 'UPI · Cards · Wallets',
                      isSelected: _paymentMethod == 'razorpay',
                      color: const Color(0xFF072654),
                      onTap: () => setState(() => _paymentMethod = 'razorpay'),
                      divider: divider,
                    ),
                    const SizedBox(height: 10),
                    _PaymentOption(
                      icon: Icons.wallet_rounded,
                      label: 'Cash on Delivery',
                      isSelected: _paymentMethod == 'cod',
                      color: textP,
                      onTap: () => setState(() => _paymentMethod = 'cod'),
                      divider: divider,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ── Coins balance ────────────────
              if (_isSubscribed)
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: _kOrangeLight,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: _kOrange.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.monetization_on_rounded,
                            color: Color(0xFFFFC107), size: 22),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Your coin balance  •  $_coinBalance pts',
                            style: const TextStyle(
                              color: _kOrangeDark,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        if (_coinBalance > 0) ...[
                          Expanded(
                            child: Slider(
                              value: _coinsToRedeem.toDouble(),
                              min: 0,
                              max: _coinBalance.toDouble(),
                              divisions: _coinBalance > 0 ? _coinBalance : 1,
                              activeColor: _kOrange,
                              inactiveColor: _kOrange.withValues(alpha: 0.3),
                              onChanged: (v) =>
                                  setState(() => _coinsToRedeem = v.round()),
                            ),
                          ),
                          Text(
                            '-₹$_coinsToRedeem',
                            style: const TextStyle(
                              color: _kOrangeDark,
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                            ),
                          ),
                        ],
                        const SizedBox(width: 8),
                        const Icon(Icons.chevron_right_rounded, color: _kOrange),
                      ],
                    ),
                  ),
                ),

              if (_isSubscribed) const SizedBox(height: 12),

              // ── Coupons ──────────────────────
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: divider),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _kOrange,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.percent_rounded,
                          color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: 14),
                    Text(
                      'View Coupons',
                      style: TextStyle(
                        color: _kOrange,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.chevron_right_rounded, color: _kOrange),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ── Receipt ──────────────────────
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: divider),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Receipt',
                      style: TextStyle(
                        color: _kOrange,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Divider(color: divider, height: 20),
                    ...globalCart.map((e) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${e.emoji} ${e.name} × ${e.quantity}',
                              style: TextStyle(color: textP, fontSize: 13)),
                          Text('₹${(e.price * e.quantity).toStringAsFixed(0)}',
                              style: TextStyle(color: textP, fontSize: 13, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    )),
                    Divider(color: divider, height: 16),
                    if (_isSubscribed) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Earning Coins',
                            style: TextStyle(
                              color: _kOrange,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            '+ $_coinsEarned',
                            style: const TextStyle(
                              color: _kOrange,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                    if (_coinsToRedeem > 0) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Coin Discount',
                              style: TextStyle(color: Colors.green, fontSize: 13, fontWeight: FontWeight.w600)),
                          Text('-₹$_coinsToRedeem',
                              style: const TextStyle(color: Colors.green, fontSize: 13, fontWeight: FontWeight.w700)),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Total Bill',
                              style: TextStyle(
                                color: textP,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.info_outline_rounded,
                                color: textS, size: 14),
                          ],
                        ),
                        Text(
                          '₹${_payableAmount.toStringAsFixed(0)}',
                          style: TextStyle(
                            color: textP,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),
            ],
          ),

          // ── Sticky Bottom Bar ──────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
              decoration: BoxDecoration(
                color: _kOrange,
                boxShadow: [
                  BoxShadow(
                    color: _kOrange.withValues(alpha: 0.4),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Total Payment | ₹${_payableAmount.toStringAsFixed(0)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                            ),
                            children: [
                              const TextSpan(text: 'I accept the '),
                              const TextSpan(
                                text: 'Terms & Conditions',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const TextSpan(text: ' & '),
                              const TextSpan(
                                text: 'Privacy Policy',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _isProcessingPayment ? null : _placeOrder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: _kOrange,
                      disabledBackgroundColor: Colors.white60,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: _isProcessingPayment
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: _kOrange,
                      ),
                    )
                        : Text(
                      _paymentMethod == 'razorpay'
                          ? 'Pay Now'
                          : 'Place Order',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
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

  // ── Edit Address dialog ───────────────────
  void _editAddress(BuildContext context) {
    final addrCtrl = TextEditingController(text: _address);
    final nameCtrl = TextEditingController(text: _receiverName);
    final phoneCtrl = TextEditingController(text: _receiverPhone);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Edit Delivery Address',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 16),
              TextField(
                controller: addrCtrl,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: _kOrange, width: 1.8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: 'Receiver Name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: _kOrange, width: 1.8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneCtrl,
                decoration: InputDecoration(
                  labelText: 'Receiver Phone',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: _kOrange, width: 1.8),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _address = addrCtrl.text.trim();
                      _receiverName = nameCtrl.text.trim();
                      _receiverPhone = phoneCtrl.text.trim();
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _kOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Save Address',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Cart Item Row
// ─────────────────────────────────────────────
class _CartItemRow extends StatelessWidget {
  final CartEntry entry;
  final Color textP, textS, divider;
  final VoidCallback onAdd, onDecrement;

  const _CartItemRow({
    required this.entry,
    required this.textP,
    required this.textS,
    required this.divider,
    required this.onAdd,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 1.5),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.name,
                      style: TextStyle(
                        color: textP,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '₹${entry.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: _kOrange,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: _kOrangeLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(entry.emoji, style: const TextStyle(fontSize: 30)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: _kOrange, width: 1.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _QtyBtn(icon: Icons.remove_rounded, onTap: onDecrement),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Text(
                        '${entry.quantity}',
                        style: const TextStyle(
                          color: _kOrange,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    _QtyBtn(icon: Icons.add_rounded, onTap: onAdd),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Divider(color: divider, height: 1),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Payment Option
// ─────────────────────────────────────────────
class _PaymentOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? sublabel;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;
  final Color divider;

  const _PaymentOption({
    required this.icon,
    required this.label,
    this.sublabel,
    required this.isSelected,
    required this.color,
    required this.onTap,
    required this.divider,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? _kOrange : divider,
            width: isSelected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(10),
          color: isSelected ? _kOrangeLight : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? _kOrange : color, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: isSelected ? _kOrange : color,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  if (sublabel != null)
                    Text(
                      sublabel!,
                      style: TextStyle(
                        color: isSelected ? _kOrange.withValues(alpha: 0.7) : Colors.grey,
                        fontSize: 11,
                      ),
                    ),
                ],
              ),
            ),
            Radio<bool>(
              value: true,
              groupValue: isSelected,
              onChanged: (_) => onTap(),
              activeColor: _kOrange,
            ),
          ],
        ),
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
      child: SizedBox(
        width: 32,
        height: 32,
        child: Icon(icon, color: _kOrange, size: 18),
      ),
    );
  }
}