import 'package:flutter/material.dart';

import 'callApi.dart';

class off{
  int Code=0;
  String NameA='';
}


class MyTicket {
  int cardID=0;
  int cardStatusID=0;
  int cardTypeID=0;
  int jobID=0;
  double jardTotalPrice=0;
  int cardSeatsCount=0;
  DateTime? actionDate;
  List<MyTrip> myTrips=[];
}

class MySeat {
  int seatNo=0;
  int resID=0;
  double seatPrice=0;
  int seatStatusID=0;
}



class Coupon {
  String couponCode = "";
  String couponName = "";
  String couponDescription = "";
  String couponLabel = "";
}

class CouponsVal {
  double val = 0;
  String result = '';
  double totalPrice = 0;
  double totalAfterDisc = 0;
}

class User {
  int userID = 0;
  String userName = '';
  String userEmail = '';
  String userPassword = '';
  String userToken = '';
  String userPicUrl = '';
  String usersocialID = '';
  String userTelNo = '';
  bool userIsFace = false;
}

class MyTrip {
  int seatsCount = 0;
  //List seats = new List();
  List seats = [];
  String seatsStr = '';
  int tripSubDataId = 0;
  double tripPrice = 0;
  var trip;

  DateTime date;
  MyTrip(this.date);
}

class MyColors {
  Color appBar = appBarColor; // Color(0xff9B0853);
  Color appBarIcon =
      companyID == 10 ? Colors.black : Colors.white; // Color(0xff9B0853);

  Color homeBck = const Color(0xffF2F2F2); //#F2F2F2
  Color searchTitle = Colors.black;
  Color goComeBckAll = Colors.white; // Color(0xff8F949D); //#121212
  Color goComeBtnActiveBck = Colors.black; //#121212
  Color goComeBtnActive = Colors.white;
  Color goComeBtnActiveNot = Colors.black;
  Color officeTtl = Colors.black;
  Color office = Colors.black;
  Color searchbtn = Colors.white;
  Color btnBck = companyID == 10 ? Colors.red : Colors.blue; // red;
  Color btnred = Colors.red; // red;
  Color dark = const Color(0xff4A4D4E); //Colors.black;//  //#8F949D #272727   #DAA520
  Color seatFree = const Color(0xffFDC679); //#FDC679
  Color titelColor = companyID == 10 ? const Color(0xff4A4D4E) : Colors.white; // red;
  Color dateColor = companyID == 10 ? const Color(0xff4A4D4E) : Colors.blue; // red;
}





//=============================================

class MyTickets {
    int cardId=0;
    int cardStatusId=0;
    String cardStatusName='';
    int cardTypeId=0;
    String cardTypeName='';
    int cardCancelId=0;
    int jobId=0;
    int cardTotalPrice=0;
    int cardSeatsCount=0;
    DateTime? actionDate;
    List<MyTrip> myTrips=[];
    String cardToken='';
}

class MyTickets_MyTrip {
    int cardStatusId=0;
    int cardId=0;
    int tripSubDataId=0;
    DateTime? tripDateTime;
    String tripOfficeFrom='';
    String tripOfficeTo='';
    String tripServKind='';
    String tripOfficeFromNameA='';
    String tripOfficeFromNameE='';
    String tripOfficeToNameA='';
    String tripOfficeToNameE='';
    String tripServKindNameA='';
    String tripServKindNameE='';
    int tripTotalPrice=0;
    int tripSeatsCount=0;
    List<int> seats=[];
    List<int> resIDs=[];
    List<int> seatsPrices=[];
    List<MySeat> mySeats=[];
}

class MyTickets_MySeat {
    int seatNo=0;
    int resId=0;
    int seatPrice=0;
    int seatStatusId=0;
    int cancelFee=0;
}



