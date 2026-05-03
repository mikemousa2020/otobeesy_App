import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';
import 'callApi.dart';
import 'homePage.dart';

class BookingNewPayByCredit extends StatefulWidget {
  const BookingNewPayByCredit({super.key});

  @override
  _BookingNewPayByCreditState createState() => _BookingNewPayByCreditState();
}

class _BookingNewPayByCreditState extends State<BookingNewPayByCredit> {
  int result = 0;
  bool isLoading = true;
  String cardToken = '';
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    _initPayment();
  }

  Future<void> _initPayment() async {
    await _holdSeatsAndGetToken();
    if (cardToken.isNotEmpty) {
      _initWebView();
    }
  }

  Future<void> _holdSeatsAndGetToken() async {
    try {
      final response = await holdSeats();
      print('===> HoldSeats RESPONSE status: ${response.statusCode}');
      var data = json.decode(response.body);
      print('===> HoldSeats RESPONSE body: $data');
      
      if (data['CardToken'] != null && data['CardToken'].toString().isNotEmpty) {
        cardToken = data['CardToken'];
        print('===> CardToken extracted: $cardToken');
      } else {
        print('===> HoldSeats FAILED: No CardToken in response');
        if (mounted) {
          setState(() {
            result = 2;
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print('===> HoldSeats ERROR: $e');
      if (mounted) {
        setState(() {
          result = 2;
          isLoading = false;
        });
      }
    }
  }

  void _initWebView() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            print('===> WebView onPageStarted: $url');
            if (mounted) setState(() => isLoading = true);
          },
          onPageFinished: (url) {
            print('===> WebView onPageFinished: $url');
            if (mounted) setState(() => isLoading = false);
          },
          onNavigationRequest: (request) {
            print('===> WebView onNavigationRequest: ${request.url}');
            final url = request.url.toLowerCase();
            
            if (url.contains('OtpCallBack') || url.contains('Thanks')) {
              print('===> SUCCESS - Payment callback detected!');
              Future.delayed(const Duration(seconds: 2), () {
                if (mounted) setState(() => result = 1);
              });
            } else if (url.contains('fail')) {
              print('===> FAIL - Payment failed');
              if (mounted) setState(() => result = 2);
            }
            return NavigationDecision.navigate;
          },
          onWebResourceError: (error) {
            print('===> WebView ERROR: ${error.description}');
            print('===> WebView ERROR code: ${error.errorCode}');
            print('===> WebView ERROR type: ${error.errorType}');
          },
        ),
      );

    // final payUrl = '$paymentBaseUrl?t=$cardToken&i=${user.userID}&l=ar&w=10&s=10';
    final payUrl = '$paymentBaseUrl?t=$cardToken&i=${user.userID}&l=ar&w=10';
    print('===> Loading Payment URL: $payUrl');
    controller.loadRequest(Uri.parse(payUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar('سداد ببطاقة الائتمان'),
      body: Column(
        children: [
          AppBarEx(confirmTitle(true)),
          const SizedBox(height: 10),

          if (isLoading && result == 0)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          else if (result == 0 && cardToken.isNotEmpty)
            Expanded(
              child: WebViewWidget(controller: controller),
            )
          else if (result == 1)
            successWidget(context)
          else
            errorWidget(context),
        ],
      ),
    );
  }

  Widget successWidget(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 20),
            const Text(
              'تم السداد بنجاح',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
              child: const Text('الشاشة الرئيسية'),
            ),
          ],
        ),
      ),
    );
  }

  Widget errorWidget(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, color: Colors.red, size: 80),
            const SizedBox(height: 20),
            const Text(
              'عفوا : تم رفض العملية من البنك',
              style: TextStyle(color: Colors.red, fontSize: 18),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('عودة لصفحة السداد'),
            ),
          ],
        ),
      ),
    );
  }
}