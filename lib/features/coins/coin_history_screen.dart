import 'package:flutter/material.dart';
import 'coin_service.dart';

// ─────────────────────────────────────────────
//  Constants (match app palette)
// ─────────────────────────────────────────────
const _kOrange    = Color(0xFFFF6B2C);
const _kCoinGold  = Color(0xFFFFD700);
const _kCoinAmber = Color(0xFFFFC107);

// ─────────────────────────────────────────────
//  CoinHistoryScreen
// ─────────────────────────────────────────────
class CoinHistoryScreen extends StatefulWidget {
  const CoinHistoryScreen({super.key});

  @override
  State<CoinHistoryScreen> createState() => _CoinHistoryScreenState();
}

class _CoinHistoryScreenState extends State<CoinHistoryScreen> {
  int _balance = 0;
  List<CoinEntry> _history = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final b = await CoinService.getBalance();
    final h = await CoinService.getHistory();
    if (mounted) setState(() { _balance = b; _history = h; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg      = isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA);
    final cardBg  = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textP   = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final textS   = isDark ? Colors.white60 : const Color(0xFF6B6B6B);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: _kOrange,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Coins',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: _kOrange))
          : Column(
        children: [
          // ── Balance banner ──────────────────
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [_kCoinAmber, _kCoinGold],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.monetization_on_rounded,
                    color: Colors.white, size: 48),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Available Balance',
                        style: TextStyle(
                            color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
                    Text(
                      '$_balance Coins',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          height: 1.1),
                    ),
                    Text(
                      '= ₹$_balance discount value',
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Info chip ───────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _InfoChip(
                  icon: Icons.add_circle_outline_rounded,
                  label: '₹100 spent = 10 coins',
                  color: Colors.green,
                ),
                const SizedBox(width: 8),
                _InfoChip(
                  icon: Icons.remove_circle_outline_rounded,
                  label: '1 coin = ₹1 off',
                  color: _kOrange,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── History header ──────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text('Transaction History',
                    style: TextStyle(
                        color: textP, fontSize: 16, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // ── History list ────────────────────
          Expanded(
            child: _history.isEmpty
                ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.history_rounded,
                      size: 56, color: Colors.grey),
                  const SizedBox(height: 12),
                  Text('No transactions yet',
                      style: TextStyle(color: textS, fontSize: 14)),
                ],
              ),
            )
                : ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _history.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final e = _history[i];
                final isEarn = e.coins > 0;
                return Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: isDark
                            ? Colors.white10
                            : const Color(0xFFE8E8E8)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isEarn
                              ? Colors.green.withValues(alpha: 0.12)
                              : _kOrange.withValues(alpha: 0.12),
                        ),
                        child: Icon(
                          isEarn
                              ? Icons.add_rounded
                              : Icons.remove_rounded,
                          color: isEarn ? Colors.green : _kOrange,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(e.label,
                                style: TextStyle(
                                    color: textP,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14)),
                            const SizedBox(height: 2),
                            Text(e.date,
                                style: TextStyle(
                                    color: textS, fontSize: 12)),
                          ],
                        ),
                      ),
                      Text(
                        isEarn ? '+${e.coins}' : '${e.coins}',
                        style: TextStyle(
                          color: isEarn ? Colors.green : _kOrange,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.monetization_on_rounded,
                          color: _kCoinAmber, size: 16),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _InfoChip({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.30)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  color: color, fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}