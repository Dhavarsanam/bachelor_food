import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// ─────────────────────────────────────────────
//  CoinEntry — one history record
// ─────────────────────────────────────────────
class CoinEntry {
  final String date;   // 'YYYY-MM-DD'
  final int coins;     // positive = earned, negative = redeemed
  final String label;  // e.g. 'Order ₹350' or 'Redeemed'

  const CoinEntry({
    required this.date,
    required this.coins,
    required this.label,
  });

  Map<String, dynamic> toMap() => {'date': date, 'coins': coins, 'label': label};

  factory CoinEntry.fromMap(Map<String, dynamic> m) =>
      CoinEntry(date: m['date'], coins: m['coins'], label: m['label']);
}

// ─────────────────────────────────────────────
//  CoinService
// ─────────────────────────────────────────────
class CoinService {
  static const _keyBalance  = 'coin_balance';
  static const _keyHistory  = 'coin_history';
  static const _keySubbed   = 'is_subscribed';

  // ── Subscription ─────────────────────────
  static Future<bool> isSubscribed() async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(_keySubbed) ?? true; // default true for demo
  }

  static Future<void> setSubscribed(bool v) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_keySubbed, v);
  }

  // ── Balance ───────────────────────────────
  static Future<int> getBalance() async {
    final p = await SharedPreferences.getInstance();
    return p.getInt(_keyBalance) ?? 0;
  }

  static Future<void> _setBalance(int v, SharedPreferences p) async =>
      await p.setInt(_keyBalance, v);

  // ── History ───────────────────────────────
  static Future<List<CoinEntry>> getHistory() async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getStringList(_keyHistory) ?? [];
    return raw
        .map((s) => CoinEntry.fromMap(jsonDecode(s) as Map<String, dynamic>))
        .toList()
        .reversed
        .toList();
  }

  static Future<void> _addEntry(CoinEntry entry, SharedPreferences p) async {
    final raw = p.getStringList(_keyHistory) ?? [];
    raw.add(jsonEncode(entry.toMap()));
    await p.setStringList(_keyHistory, raw);
  }

  // ── Earn coins after order ─────────────────
  // ₹100 = 10 coins. Only for subscribed users.
  static Future<int> earnFromOrder(double orderAmount) async {
    final subbed = await isSubscribed();
    if (!subbed) return 0;

    final earned = ((orderAmount / 100) * 10).floor();
    if (earned <= 0) return 0;

    final p = await SharedPreferences.getInstance();
    final balance = (p.getInt(_keyBalance) ?? 0) + earned;
    await _setBalance(balance, p);

    final today = _today();
    await _addEntry(
      CoinEntry(
        date: today,
        coins: earned,
        label: 'Order ₹${orderAmount.toStringAsFixed(0)}',
      ),
      p,
    );
    return earned;
  }

  // ── Redeem coins (1 coin = ₹1 discount) ───
  // Returns the actual coins redeemed (capped at balance).
  static Future<int> redeemCoins(int requested) async {
    final p = await SharedPreferences.getInstance();
    final balance = p.getInt(_keyBalance) ?? 0;
    final redeemed = requested > balance ? balance : requested;
    if (redeemed <= 0) return 0;

    await _setBalance(balance - redeemed, p);
    await _addEntry(
      CoinEntry(date: _today(), coins: -redeemed, label: 'Redeemed ₹$redeemed off'),
      p,
    );
    return redeemed;
  }

  static String _today() {
    final n = DateTime.now();
    return '${n.year}-${n.month.toString().padLeft(2, '0')}-${n.day.toString().padLeft(2, '0')}';
  }
}