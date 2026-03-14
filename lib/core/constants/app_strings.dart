/// All user-facing text strings for FitLife.
/// Keeping copy here makes localisation or copy-editing a single-file change.
class AppStrings {
  AppStrings._();

  // ── App ───────────────────────────────────────────────────────────────────
  static const String appName = 'FitLife';
  static const String tagline = 'Kigali Gym Directory';

  // ── Auth ─────────────────────────────────────────────────────────────────
  static const String login = 'Sign In';
  static const String register = 'Create Account';
  static const String logout = 'Sign Out';
  static const String forgotPassword = 'Forgot Password?';
  static const String resetPassword = 'Reset Password';
  static const String resetPasswordSent =
      'Password reset link sent! Check your inbox.';
  static const String googleSignIn = 'Continue with Google';
  static const String emailHint = 'Email address';
  static const String passwordHint = 'Password';
  static const String confirmPasswordHint = 'Confirm password';
  static const String dontHaveAccount = "Don't have an account? ";
  static const String alreadyHaveAccount = 'Already have an account? ';
  static const String verifyEmailTitle = 'Verify your email';
  static const String verifyEmailBody =
      'A verification link has been sent to your inbox. '
      'Please verify before signing in.';

  // ── Validation ────────────────────────────────────────────────────────────
  static const String emailRequired = 'Please enter your email address.';
  static const String emailInvalid = 'Please enter a valid email address.';
  static const String passwordRequired = 'Please enter your password.';
  static const String passwordTooShort =
      'Password must be at least 6 characters.';
  static const String passwordsMismatch = 'Passwords do not match.';
  static const String fieldRequired = 'This field is required.';

  // ── Gyms ─────────────────────────────────────────────────────────────────
  static const String gyms = 'Gyms';
  static const String savedGyms = 'Saved Gyms';
  static const String noGyms = 'No gyms found.';
  static const String noSavedGyms = "You haven't saved any gyms yet.";
  static const String allDistricts = 'All Districts';
  static const String subscriptionLabel = 'Subscription';
  static const String perMonth = '/month';
  static const String amenities = 'Amenities';
  static const String gallery = 'Photo Gallery';
  static const String districtLabel = 'District';

  // ── Admin ─────────────────────────────────────────────────────────────────
  static const String adminDashboard = 'Admin Dashboard';
  static const String addGym = 'Add Gym';
  static const String editGym = 'Edit Gym';
  static const String deleteGym = 'Delete Gym';
  static const String confirmDelete =
      'Are you sure you want to delete this gym? This cannot be undone.';
  static const String cancel = 'Cancel';
  static const String confirm = 'Confirm';
  static const String save = 'Save';
  static const String gymName = 'Gym Name';
  static const String description = 'Description';
  static const String priceRwf = 'Monthly Price (RWF)';
  static const String galleryUrls = 'Gallery URLs (one per line)';
  static const String amenitiesLabel = 'Amenities (comma-separated)';
  static const String gymSaved = 'Gym saved successfully.';
  static const String gymDeleted = 'Gym deleted.';

  // ── Settings ─────────────────────────────────────────────────────────────
  static const String settings = 'Settings';
  static const String darkMode = 'Dark Mode';
  static const String defaultDistrict = 'Default District Filter';
  static const String notifications = 'Push Notifications';
  static const String preferences = 'Preferences';

  // ── Generic ───────────────────────────────────────────────────────────────
  static const String retry = 'Retry';
  static const String ok = 'OK';
  static const String loading = 'Loading…';
  static const String error = 'Something went wrong.';
  static const String accessDenied =
      'You do not have permission to access this area.';
}
