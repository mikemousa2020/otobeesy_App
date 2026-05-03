//import 'dart:convert';
//import 'dart:convert';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'callApi.dart';

//import 'classes/myClasses.dart';

class BookingHeader extends StatefulWidget {
  const BookingHeader({super.key});

  // final bool withCoupon;
  //  BookingHeader(this.withCoupon);
  @override
  _BookingHeaderState createState() => _BookingHeaderState();
}

class _BookingHeaderState extends State<BookingHeader> {
  TextEditingController couponCodeController = TextEditingController();
  //double cardTotalWithDisc = 0;
  @override
  initState() {
    couponDisc = 0;
    couponCode = '';
    isCouponNotFound = false;
    couponResult = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(15),
        //color: myColors.homeBck,
        child: Column(
          children: <Widget>[
            Row(
              textDirection: TextDirection.rtl,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Row(
                      textDirection: TextDirection.rtl,
                      children: <Widget>[
                        couponDisc > 0
                            ? Row(
                                textDirection: TextDirection.rtl,
                                children: <Widget>[
                                  const Text('الاجمالى بعد الخصم'),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    formatNum(cardTotal - couponDisc),
                                    style: const TextStyle(
                                      color: Colors.orange,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text('جنيه')
                                ],
                              )
                            : const Text(''),
                      ],
                    ),
                  ],
                ),
                Text('# $cardID',
                    style: const TextStyle(color: Colors.transparent, fontSize: 15)),
                //Image(image: AssetImage("$imglogo")),
              ],
            ),
           
            InkWell(
              onTap: () {
                 showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              getCouponsVal(couponCodeController.text, cardID)
                                  .then((response) {
                                var val = json.decode(response.body);
                                if (val != null && val['result'] == '') {
                                  setState(() {
                                    couponDisc = val['val'];
                                    couponCode = couponCodeController.text;
                                    isCouponNotFound = false;
                                    couponResult = '';
                                  });
                                } else {
                                  setState(() {
                                    couponDisc = 0;
                                    couponCode = "";
                                    isCouponNotFound = true;
                                    couponResult = val['result'] ?? 'خطأ';
                                  });
                                }
                              });
                              Navigator.of(context).pop();

                              //setState(() {});
                            },
                            child: const Text('موافق'),
                          )
                        ],
                        content: SizedBox(
                          height: 110,
                          child: Column(
                            children: <Widget>[
                              const Text('رجاء ادخال البروموكود'),
                              const SizedBox(
                                height: 10,
                              ),
                              TextField(
                                controller: couponCodeController,
                                textAlign: TextAlign.center,
                                //onChanged: (){},
                                //textDirection: TextDirection.rtl,
                                keyboardType: TextInputType.emailAddress,
                                autofocus: false,
                                decoration: InputDecoration(
                                  hintText: 'البروموكود',
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(32)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              },
              child: Wrap(
                textDirection: TextDirection.rtl,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  const Image(image: AssetImage('assets/pics/coupon.png')),
                  const SizedBox(width: 10),

                  Container(
                      //color: Colors.red,
                      child: const Text(
                    'هل لديك بروموكود خصم؟',
                    style: TextStyle(color: Colors.blue, fontSize: 14),
                  )),
                  const SizedBox(width: 5),

                  Text(
                    couponCode.isNotEmpty || isCouponNotFound
                        ? ''
                        : 'اضغط هنا لادخاله',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),

                  // Icon(
                  //   Icons.money_off,
                  //   color: Colors.grey,
                  // ),
                  const SizedBox(width: 10),
                  Text(
                    couponCode,
                    style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 20,
                    ),
                  ),
                  isCouponNotFound
                      ? Text(
                          //'بروموكود خطأ',
                          couponResult,
                          style: const TextStyle(color: Colors.red),
                        )
                      : const Text(''),
                ],
              ),
            ),
           
            const Divider()
          ],
        ));
  }
}
