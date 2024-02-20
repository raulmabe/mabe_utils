import 'package:in_app_review/in_app_review.dart';

/// Mixin that exposes methods for rating the app
mixin RatingMixin {
  /// Shows native Rating pop up
  Future<void> showNativeRatingPopup() {
    return InAppReview.instance.requestReview();
  }

  /// Opens App Store or Play Store for rating.
  Future<void> openStoreForRating(String kAppId) async {
    if (await InAppReview.instance.isAvailable()) {
      await InAppReview.instance.openStoreListing(appStoreId: kAppId);
    }
  }
}
