import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

/// Methods that allow to work easier with String URLs or Uris.
mixin UrlsMixin {
  /// Encodes query parameters
  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map(
          (e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
  }

  /// Returns [Uri] from a String [link].
  /// Returns null if the String is an invalid URI
  Uri? getUriFromString(String link) {
    final rawText = link;
    final urlString = rawText.toLowerCase().contains('http') || rawText.toLowerCase().contains('https') ? rawText : 'https://$rawText';
    return Uri.tryParse(urlString);
  }

  /// Returns whether the link is a well-formatted URI
  bool isUrlValid(String link) {
    final url = getUriFromString(link);
    final regex = RegExp(r'^(http|https)://[a-zA-Z0-9]+([-.][a-zA-Z0-9]+)*\.[a-zA-Z]{2,}(:[0-9]+)?(/.*)?$');
    if (url == null) return false;
    final isValid =
        (url.scheme == 'http' || url.scheme == 'https') && url.isAbsolute && url.host.isNotEmpty && regex.hasMatch(url.toString());
    return isValid;
  }

  /// Opens URL String
  Future<bool> launchUrlStringInBrowser({required String url, bool webOpenInSameTab = false}) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url, webOnlyWindowName: webOpenInSameTab ? '_self' : null);
      return true;
    }
    return false;
  }

  /// Opens URI in browser
  Future<bool> launchUriInBrowser({required Uri url, bool webOpenInSameTab = false}) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url, webOnlyWindowName: webOpenInSameTab ? '_self' : null);
      return true;
    }
    return false;
  }
}
