import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlHelper {
  UrlHelper._();

  /// Safely opens an external URL in a new browser tab or external app
  static Future<bool> openUrl(String urlString) async {
    try {
      final Uri uri = Uri.parse(urlString);
      return await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      debugPrint('UrlHelper failed to open $urlString: $e');
      return false;
    }
  }
}
