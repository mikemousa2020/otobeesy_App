import 'package:flutter/material.dart';
//import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
//import 'package:webview_flutter/webview_flutter.dart';
import 'myDrawer.dart';
import 'callApi.dart';

class Terms extends StatefulWidget {
  const Terms({super.key});

  @override
  _ContactusState createState() => _ContactusState();
}

class _ContactusState extends State<Terms> {
  String result = '';
  //bool inSave = false;

  @override
  Widget build(BuildContext context) {
    //userNameController.text='Test 2' ;
    return Scaffold(
      endDrawer: MyDrawer(),
      appBar: myAppBar('الشروط والاحكام'),
      body: Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: 
        const Text("Test")
        
        // WebView(
        //   initialUrl: '$TermsURL',
        //   javascriptMode: JavascriptMode.unrestricted,
        // )
         
          
            // Container(
            //   height: 400,
            //   child: WebviewScaffold(
            //     url: "$TermsURL",
            //     clearCache: true,
            //   ),
            // ),
          
        ),

        //  WebviewScaffold(
        //   url: "$TermsURL",
        //   //hidden: false,
        //   clearCache: true,
        // ),
      
    );
  }
}
