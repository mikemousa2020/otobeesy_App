import 'dart:convert';
import 'package:http/http.dart' as http;

/// Thin HTTP wrapper that logs every request and response to the console.
///
/// Drop-in replacement for `http.get()` / `http.post()`. Just swap the import
/// and replace `http.get(url)` with `ApiClient.get(url)`. All existing return
/// types (Future<http.Response>) are preserved so the rest of the code stays
/// untouched.
class ApiClient {
  /// Sends a GET request and logs the full exchange.
  static Future<http.Response> get(String url, {Map<String, String>? headers}) async {
    return _log('GET', url, null, headers, () => http.get(Uri.parse(url), headers: headers));
  }

  /// Sends a POST request and logs the full exchange.
  static Future<http.Response> post(String url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    return _log('POST', url, body, headers,
        () => http.post(Uri.parse(url), headers: headers, body: body, encoding: encoding));
  }

  /// Core interceptor: logs timing, status, and body.
  static Future<http.Response> _log(
    String method,
    String url,
    Object? body,
    Map<String, String>? headers,
    Future<http.Response> Function() call,
  ) async {
    final stopwatch = Stopwatch()..start();

    // ── Build a compact request preview ──
    final buf = StringBuffer()
      ..write('── REQUEST ── $method  $url');
    if (headers != null && headers.isNotEmpty) {
      buf.write('\n   HEADERS: $headers');
    }
    if (body != null) {
      buf.write('\n   BODY:    $body');
    }
    print(buf.toString());

    // ── Execute ──
    http.Response response;
    try {
      response = await call();
    } catch (e) {
      stopwatch.stop();
      print('── ERROR ── $method  $url  (${stopwatch.elapsedMilliseconds}ms)\n   $e');
      rethrow;
    }

    stopwatch.stop();

    // ── Build a compact response preview ──
    final bodyPreview = response.body.length > 500
        ? '${response.body.substring(0, 500)}… (${response.body.length} total chars)'
        : response.body;

    print(
        '── RESPONSE ── ${response.statusCode}  $method  $url  (${stopwatch.elapsedMilliseconds}ms)\n   $bodyPreview');

    return response;
  }
}
