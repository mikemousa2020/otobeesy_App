import 'package:flutter/material.dart';
import 'callApi.dart';
import 'homePage.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BookingPayByCredit extends StatefulWidget {
  const BookingPayByCredit({super.key});

  @override
  _BookingPayByCreditState createState() => _BookingPayByCreditState();
}

class _BookingPayByCreditState extends State<BookingPayByCredit> {
  int result = 0;

  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            final url = request.url;
            print('===> $url');

            if (url.contains('Booking_Thanks')) {
              setState(() => result = 1);
            }

            if (url.contains('Booking_Error')) {
              setState(() => result = 2);
            }

            return NavigationDecision.navigate;
          },
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    String payUrl =
        "$payURL/Home/EPay?companyID=$companyID&cardID=$cardID&Total=$cardTotal&couponCode=$couponCode&couponDisc=$couponDisc";

    if (result == 0) {
      controller.loadRequest(Uri.parse(payUrl));
    }

    return Scaffold(
      appBar: myAppBar('سداد ببطاقة الائتمان'),
      body: Column(
        children: [
          AppBarEx(confirmTitle(true)),
          const SizedBox(height: 10),

          if (result == 0)
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
            const Text('تم السداد بنجاح'),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
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
            const Text(
              'عفوا : تم رفض العملية من البنك',
              style: TextStyle(color: Colors.red, fontSize: 18),
            ),
            const SizedBox(height: 20),
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