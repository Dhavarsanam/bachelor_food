import 'package:flutter/material.dart';
import 'package:bachelor_foods/features/coins/coin_service.dart';
import 'package:bachelor_foods/features/coins/coin_history_screen.dart';
import 'package:bachelor_foods/core/helpers/user_storage_helper.dart';

// ─────────────────────────────────────────────
//  Constants
// ─────────────────────────────────────────────
const _kOrange     = Color(0xFFFF6B2C);
const _kOrangeLight = Color(0xFFFFF0EB);
const _kBorder     = Color(0xFFE8E8E8);

// ─────────────────────────────────────────────
//  AccountScreen
// ─────────────────────────────────────────────
class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  // Profile fields (loaded from storage / editable)
  String _name        = 'Arjun Kumar';
  String _phone       = '+91 98765 43210';
  String _email       = '';
  String _birthday    = '';
  String _gender      = '';
  bool   _pureVeg     = false;
  bool   _isSubscribed = true;
  int    _coinBalance = 0;

  // Profile completion %
  int get _profileCompletion {
    int filled = 0;
    if (_name.isNotEmpty)     filled++;
    if (_phone.isNotEmpty)    filled++;
    if (_email.isNotEmpty)    filled++;
    if (_birthday.isNotEmpty) filled++;
    if (_gender.isNotEmpty)   filled++;
    return ((filled / 5) * 100).round();
  }

  String get _initials {
    final parts = _name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    if (parts[0].isNotEmpty) return parts[0][0].toUpperCase();
    return 'U';
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final bal    = await CoinService.getBalance();
    final subbed = await CoinService.isSubscribed();
    if (mounted) setState(() { _coinBalance = bal; _isSubscribed = subbed; });
  }

  @override
  Widget build(BuildContext context) {
    final isDark   = Theme.of(context).brightness == Brightness.dark;
    final bg       = isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5);
    final cardBg   = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textP    = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final textS    = isDark ? Colors.white54 : const Color(0xFF6B6B6B);
    final divider  = isDark ? Colors.white12 : _kBorder;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: textP),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Manage Account',
          style: TextStyle(
            color: textP,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Profile card ──────────────────
            Container(
              color: cardBg,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  // Avatar with circular progress
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: CircularProgressIndicator(
                          value: _profileCompletion / 100,
                          strokeWidth: 3,
                          backgroundColor: Colors.grey.withValues(alpha: 0.2),
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.deepOrange),
                        ),
                      ),
                      Container(
                        width: 66,
                        height: 66,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFD6EDD6),
                        ),
                        child: Icon(Icons.person_rounded,
                            color: const Color(0xFF5A3E2B), size: 36),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3D2B1F),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '$_profileCompletion%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () => _openEditProfile(context),
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.deepOrange,
                            ),
                            child: const Icon(Icons.edit_rounded,
                                color: Colors.white, size: 13),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_name,
                            style: TextStyle(
                                color: textP,
                                fontSize: 18,
                                fontWeight: FontWeight.w800)),
                        const SizedBox(height: 4),
                        Text(_phone,
                            style: TextStyle(color: textS, fontSize: 13)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _openEditProfile(context),
                    child: Icon(Icons.edit_outlined, color: textS, size: 22),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // ── Quick actions row ─────────────
            Container(
              color: cardBg,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                children: [
                  _QuickAction(
                    icon: Icons.home_outlined,
                    label: 'Manage\nAddresses',
                    onTap: () {},
                  ),
                  _QuickAction(
                    icon: Icons.favorite_outline_rounded,
                    label: 'Favourite\nKitchens',
                    iconColor: Colors.pinkAccent,
                    onTap: () {},
                  ),
                  _QuickAction(
                    widget: Transform.scale(
                      scale: 0.85,
                      child: Switch(
                        value: _pureVeg,
                        onChanged: (v) => setState(() => _pureVeg = v),
                        activeColor: Colors.green,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                    label: 'Pure Veg',
                    onTap: () => setState(() => _pureVeg = !_pureVeg),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // ── Refer banner ──────────────────
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [Color(0xFFD4EDDA), Color(0xFFB8DFC4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Refer Your Friend',
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                color: Color(0xFF1A1A1A))),
                        const SizedBox(height: 6),
                        const Text(
                          'Refer your friend and gift ₹100.\nEarn ₹50 on their first order.',
                          style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF555555),
                              height: 1.4),
                        ),
                        const SizedBox(height: 4),
                        const Text('T & C Apply',
                            style: TextStyle(
                                fontSize: 10, color: Color(0xFF888888))),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                          ),
                          child: const Text('Invite Your Friend',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 13)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('👥', style: TextStyle(fontSize: 56)),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // ── Menu items list ───────────────
            Container(
              color: cardBg,
              child: Column(
                children: [
                  _MenuItem(
                    icon: Icons.history_edu_rounded,
                    label: 'My Coin History',
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(
                            builder: (_) => const CoinHistoryScreen())),
                  ),
                  _Divider(color: divider),
                  _MenuItem(
                    icon: Icons.shopping_bag_outlined,
                    label: 'Your Orders',
                    onTap: () {},
                  ),
                  _Divider(color: divider),
                  _MenuItem(
                    icon: Icons.headset_mic_outlined,
                    label: 'Help & Support',
                    onTap: () {},
                  ),
                  _Divider(color: divider),
                  _MenuItem(
                    icon: Icons.quiz_outlined,
                    label: "Legal & FAQ's",
                    onTap: () {},
                  ),
                  _Divider(color: divider),
                  _MenuItem(
                    icon: Icons.assignment_return_outlined,
                    label: 'Refund Policy',
                    onTap: () {},
                  ),
                  _Divider(color: divider),
                  _MenuItem(
                    icon: Icons.privacy_tip_outlined,
                    label: 'Privacy Policy',
                    onTap: () {},
                  ),
                  _Divider(color: divider),
                  _MenuItem(
                    icon: Icons.gavel_rounded,
                    label: 'Terms & Conditions',
                    onTap: () {},
                  ),
                  _Divider(color: divider),
                  _MenuItem(
                    icon: Icons.settings_outlined,
                    label: 'Settings',
                    onTap: () {},
                  ),
                  _Divider(color: divider),
                  _MenuItem(
                    icon: Icons.delivery_dining_rounded,
                    label: 'Delivery Areas',
                    onTap: () {},
                  ),
                  _Divider(color: divider),
                  _MenuItem(
                    icon: Icons.logout_rounded,
                    label: 'Log Out',
                    labelColor: Colors.red,
                    iconColor: Colors.red,
                    onTap: () => _confirmLogout(context),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            Text('App Version 1.0.0 (1)',
                style: TextStyle(color: textS, fontSize: 12)),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ── Edit Profile bottom sheet ─────────────
  void _openEditProfile(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _EditProfileSheet(
        name: _name,
        phone: _phone,
        email: _email,
        birthday: _birthday,
        gender: _gender,
        onSave: (name, email, birthday, gender) {
          setState(() {
            _name     = name;
            _email    = email;
            _birthday = birthday;
            _gender   = gender;
          });
        },
      ),
    );
  }

  // ── Logout confirm ────────────────────────
  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Log Out', style: TextStyle(fontWeight: FontWeight.w800)),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (route) => false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Edit Profile Bottom Sheet
// ─────────────────────────────────────────────
class _EditProfileSheet extends StatefulWidget {
  final String name, phone, email, birthday, gender;
  final void Function(String name, String email, String birthday, String gender) onSave;

  const _EditProfileSheet({
    required this.name,
    required this.phone,
    required this.email,
    required this.birthday,
    required this.gender,
    required this.onSave,
  });

  @override
  State<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<_EditProfileSheet> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _birthdayCtrl;
  String _gender = '';

  @override
  void initState() {
    super.initState();
    _nameCtrl     = TextEditingController(text: widget.name);
    _emailCtrl    = TextEditingController(text: widget.email);
    _birthdayCtrl = TextEditingController(text: widget.birthday);
    _gender       = widget.gender;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _birthdayCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark  = Theme.of(context).brightness == Brightness.dark;
    final bg      = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textP   = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final textS   = isDark ? Colors.white54 : const Color(0xFF6B6B6B);
    final inputBg = isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF8F8F8);

    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('Edit Profile',
                  style: TextStyle(
                      color: textP,
                      fontSize: 20,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 24),

              // Name
              _FieldRow(
                label: 'Name',
                required: true,
                controller: _nameCtrl,
                hint: 'Your name',
                inputBg: inputBg,
                textColor: textP,
                actionLabel: 'EDIT',
              ),
              const SizedBox(height: 16),

              // Phone (read-only)
              _FieldRow(
                label: 'Mobile Number',
                controller: TextEditingController(text: widget.phone),
                hint: '',
                inputBg: inputBg,
                textColor: textP,
                readOnly: true,
              ),
              const SizedBox(height: 16),

              // Email
              _FieldRow(
                label: 'Email',
                controller: _emailCtrl,
                hint: 'Add your email',
                inputBg: inputBg,
                textColor: textP,
                actionLabel: _emailCtrl.text.isEmpty ? 'ADD' : 'EDIT',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              // Birthday
              _FieldRow(
                label: 'Your Birthday',
                controller: _birthdayCtrl,
                hint: 'Enter your birthday',
                inputBg: inputBg,
                textColor: textP,
                actionLabel: _birthdayCtrl.text.isEmpty ? 'SET' : 'EDIT',
                keyboardType: TextInputType.datetime,
              ),
              const SizedBox(height: 16),

              // Gender
              Text('Gender',
                  style: TextStyle(
                      color: textS, fontSize: 13, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                      decoration: BoxDecoration(
                        color: inputBg,
                        borderRadius: BorderRadius.circular(8),
                        border: Border(
                            bottom: BorderSide(
                                color: Colors.grey.withValues(alpha: 0.3))),
                      ),
                      child: Text(
                        _gender.isEmpty ? 'Select the gender' : _gender,
                        style: TextStyle(
                            color: _gender.isEmpty ? Colors.grey : textP,
                            fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => _pickGender(context),
                    child: const Text('SELECT',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontSize: 13)),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    widget.onSave(
                      _nameCtrl.text.trim(),
                      _emailCtrl.text.trim(),
                      _birthdayCtrl.text.trim(),
                      _gender,
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _kOrange,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Save Changes',
                      style: TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  void _pickGender(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: ['Male', 'Female', 'Other', 'Prefer not to say']
            .map((g) => ListTile(
          title: Text(g),
          trailing: _gender == g
              ? const Icon(Icons.check_rounded, color: _kOrange)
              : null,
          onTap: () {
            setState(() => _gender = g);
            Navigator.pop(context);
          },
        ))
            .toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Small helpers
// ─────────────────────────────────────────────
class _FieldRow extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final Color inputBg, textColor;
  final bool required;
  final bool readOnly;
  final String? actionLabel;
  final TextInputType? keyboardType;

  const _FieldRow({
    required this.label,
    required this.controller,
    required this.hint,
    required this.inputBg,
    required this.textColor,
    this.required = false,
    this.readOnly = false,
    this.actionLabel,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label,
                style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                    fontWeight: FontWeight.w500)),
            if (required)
              const Text(' *',
                  style: TextStyle(color: Colors.red, fontSize: 13)),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: inputBg,
                  border: Border(
                      bottom: BorderSide(
                          color: Colors.grey.withValues(alpha: 0.3))),
                ),
                child: TextField(
                  controller: controller,
                  readOnly: readOnly,
                  keyboardType: keyboardType,
                  style: TextStyle(color: textColor, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    isDense: true,
                  ),
                ),
              ),
            ),
            if (actionLabel != null && !readOnly) ...[
              const SizedBox(width: 12),
              Text(actionLabel!,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      fontSize: 13)),
            ],
          ],
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? labelColor;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textP  = isDark ? Colors.white : const Color(0xFF1A1A1A);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(icon,
                color: iconColor ?? (isDark ? Colors.white70 : const Color(0xFF555555)),
                size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: labelColor ?? textP,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: isDark ? Colors.white30 : Colors.grey.shade400,
                size: 20),
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData? icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;
  final Widget? widget;

  const _QuickAction({
    this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
    this.widget,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textP  = isDark ? Colors.white70 : const Color(0xFF555555);
    final border = isDark ? Colors.white12 : _kBorder;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            border: Border.all(color: border),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget != null)
                widget!
              else
                Icon(icon!, color: iconColor ?? textP, size: 26),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: textP,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    height: 1.3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  final Color color;
  const _Divider({required this.color});

  @override
  Widget build(BuildContext context) =>
      Divider(height: 0, indent: 20, endIndent: 20, color: color);
}