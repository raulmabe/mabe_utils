import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:mabe_utils/src/mixins/urls_mixin.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Exposes a method to open a tally form
mixin TallyMixin on UrlsMixin {
  /// Opens a Tally form with the specified [mode].
  Future<void> openTally({
    required TallyFormOption mode,
    required String userId,
    required bool isPayer,
    required String appName,
    String? subject,
  }) async {
    final version = (await PackageInfo.fromPlatform()).version;
    final uri = Uri.https('ask.labhouse.io', mode.path, {
      'userId': userId,
      'appName': appName,
      'isPayer': isPayer.toString(),
      'version': version,
      'platform': kIsWeb
          ? 'web'
          : Platform.isAndroid
              ? 'android'
              : 'ios',
      if (subject != null) 'subject': subject,
    });

    await launchUrlStringInBrowser(url: uri.toString());
    return;
  }
}

/// Tally Form Options
enum TallyFormOption {
  /// Represents an issue related contact
  issue,

  /// Represents an feature related contact
  feat;

  /// String coded for path
  String get path => this == feat ? 'features' : 'issues';
}
