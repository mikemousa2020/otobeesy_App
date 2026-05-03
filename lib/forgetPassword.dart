import 'package:flutter/material.dart';
import 'callApi.dart';
//import 'dart:convert';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(),
      body: Center(
          child: Container(
        //color: Colors.red,
        height: 400,
        padding: const EdgeInsets.all(20),
        child: ListView(
          //textDirection: TextDirection.rtl,
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            logo(),
            const SizedBox(height: 20),
            const Text('إعاده ضبط كلمه السر',
                style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
            const SizedBox(height: 10),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'البريد الالكترونى',
                contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
              ),
            ),
            const SizedBox(height: 30),
            RawMaterialButton(
              fillColor: Colors.red,
              splashColor: Colors.orange,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
              onPressed: () {
                // Navigator.push(
                //     context,
                //     new MaterialPageRoute(
                //         builder: (context) => new GetTrips()));
              },
              shape: const StadiumBorder(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('ارسل رابط تغيير كلمه السر',
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
