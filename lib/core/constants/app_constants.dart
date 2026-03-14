/// Application-wide constants: shared-preference keys, Firestore collection
/// names, and other literal values. Centralising strings here removes the
/// risk of typo-driven runtime bugs.
class AppConstants {
  AppConstants._();

  // ── Firestore ────────────────────────────────────────────────────────────
  static const String gymsCollection = 'gyms';
  static const String usersCollection = 'users';

  // ── Kigali districts ─────────────────────────────────────────────────────
  static const List<String> districts = [
    'Gasabo',
    'Kicukiro',
    'Nyarugenge',
  ];

  // ── SharedPreferences keys ───────────────────────────────────────────────
  static const String prefThemeMode = 'pref_theme_mode'; // 'light' | 'dark'
  static const String prefDefaultDistrict = 'pref_default_district';
  static const String prefNotifications = 'pref_notifications'; // bool

  // ── User roles ───────────────────────────────────────────────────────────
  static const String roleUser = 'user';
  static const String roleAdmin = 'admin';

  // ── Misc ─────────────────────────────────────────────────────────────────
  static const String heroTagPrefix = 'gym_hero_'; // prefix for Hero tags
  static const int galleryMaxImages = 6;
}
