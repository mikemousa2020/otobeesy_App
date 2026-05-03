//import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'myClasses.dart';
import 'package:path_provider/path_provider.dart';
import 'trips.dart';
import 'dateGet.dart' as dt;

int companyID = 10;
int selCode = 0;
String api = "";
String officeNameFrom = '';
String officeNameTo = '';
String payURL =
    isTest ? 'https://otobeesy.com:811/' : 'https://otobeesy.com:816';
String appTitle = companyID == 10 ? 'اتوبيسى' : 'الحصان الذهبى';

List offices = [];
bool isTest = false;
double ver = 18;
int appTypeID = 2; // 2 Android    3 IOS
int codeFrom = companyID == 10 ? 585 : 34;
int codeTo = companyID == 10 ? 2051 : 33;
int resMinute = 4 * 60;

String seatImgSelected = 'assets/pics/seatselected.png';
String seatImgFree =
    companyID == 10 ? 'assets/pics/seatfree.png' : 'assets/pics/free_Hosan.png';
String seatImgBooked = 'assets/pics/seatbooked.png';
String seatImgcanceled = 'assets/pics/cancelseat.png';
String imglogo =
    companyID == 10 ? 'assets/pics/icon.png' : 'assets/pics/icon2.png';
String imgvisa = 'assets/pics/cards.png';
String imgfawry = 'assets/pics/fawry.png';

Color appBarColor =
    companyID == 10 ? Colors.white : Colors.blue; // 0xffB42809; #DAA520
double cardTotal = 0;

bool isRoundTrip = false; // تم اختيار الز ذهاب وعودة
bool getRoundTrip = false; // البحث فى شاشة العودة

MyTrip myTripGo = MyTrip(DateTime.now());
MyTrip myTripCome = MyTrip(DateTime.now().add(const Duration(days: 1)));

int currentstep = 0;
List seats = [];
List seatsSelected = [];
var trips = [];
var card;
int cardID = 0;
double couponDisc = 0;
String couponCode = '';
bool isCouponNotFound = false;
String couponResult = '';

String token = 'TazHub';
String dateFrom = 'السبت ,11 يناير';
String dateTo = '';

MyColors myColors = MyColors();

User user = User();
Coupon coupon = Coupon();

String apiUrl = isTest
    ? 'https://otobeesy.com:812/api/V2/'
    : companyID == 4
        ? 'https://goldenhorse-eg.com/api/V2/'
        : 'https://otobeesy.com/api/V2/'; //

String apiToAdd() {
  return '&ver=$ver&appTypeID=$appTypeID&userToken=${user.userToken}';
}

final ThemeData _themeData = ThemeData(
    primarySwatch: companyID == 10 ? Colors.red : Colors.blue,
    primaryColor: myColors.dark);

Widget myPic() {
  return Column(
    children: <Widget>[
      Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: user.userPicUrl.isNotEmpty
                  ? DecorationImage(
                      fit: BoxFit.fill, image: NetworkImage(user.userPicUrl))
                  : null))
    ],
  );
}

Widget wait() {
  return Container(
    child: const Center(
      child: CircularProgressIndicator(),
    ),
  );
}

InputDecoration myInputDecoration(String lblText,
    [double brdRadius = 10,
    double pL = 5,
    double pT = 10,
    double pR = 15,
    double pB = 5]) {
  return InputDecoration(
    //icon: Icon(Icons.account_circle),
    labelText: lblText,
    hintText: lblText,
    contentPadding: EdgeInsets.fromLTRB(pL, pT, pR, pB),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(brdRadius)),
  );
}

Widget logo() {
  return Image(image: AssetImage(imglogo), height: 60);
}

void goTo(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

String dateTimeToStr(dt) {
  DateTime t = DateTime.parse(dt);
  String s =
      '${t.year}/${t.month}/${t.day}';
  return s;
}

String dateToStr(DateTime t) {
  String s =
      '${t.year}/${t.month}/${t.day}';
  return s;
}

String getTimeStr(v) {
  DateTime d = DateTime.parse(v);
  //DateTime d=json.decode(v);
  String am = 'صباحا';
  int hr = d.hour;

  // switch (hr) {
  //   case 0:
  //   case 1:
  //   case 2:
  //     am = 'بعد منتصف الليل';
  //     break;
  //   case 3:
  //   case 4:
  //   case 5:
  //     am = 'فجرا';
  //     break;
  //   case 5:
  //   case 6:
  //   case 7:
  //   case 8:
  //   case 9:
  //   case 10:
  //   case 11:
  //     am = 'صباحا';
  //     break;
  //   case 9:
  //   case 12:
  //   case 13:
  //   case 14:
  //     am = 'ظهرا';
  //     break;
  //   case 15:
  //   case 16:
  //   case 17:
  //     am = 'عصرا';
  //     break;
  //   default:
  //     am = 'مساءا';
  //     break;
  // }

  if (hr >= 12) {
    //hr = hr - 12;
    am = 'مساءا';
  } else {
    am = 'صباحا';
  }

  String s = '';
  String h = hr.toString();
  String m = d.minute.toString();
  h = (h.length == 1 ? '0' : '') + h;
  m = (m.length == 1 ? '0' : '') + m;
  s = '$h:$m';

  return '$s $am';
}

String getDateStr(DateTime? v, int direction) {
  String s = '';
  if (v == null && direction == 1) v = DateTime.now();
  if (v == null) return s;
  String d = v.day.toString();
  String mm = '';
  switch (v.month) {
    case 1:
      mm = 'يناير';
      break;
    case 2:
      mm = 'فبراير';
      break;
    case 3:
      mm = 'مارس';
      break;
    case 4:
      mm = 'ابريل';
      break;
    case 5:
      mm = 'مايو';
      break;
    case 6:
      mm = 'يونيو';
      break;
    case 7:
      mm = 'يوليو';
      break;
    case 8:
      mm = 'اغسطس';
      break;
    case 9:
      mm = 'سبتمبر';
      break;
    case 10:
      mm = 'اكتوبر';
      break;
    case 11:
      mm = 'نوفمبر';
      break;
    case 12:
      mm = 'ديسمبر';
      break;
  }

  s = '$d $mm';

  return s;
}

void setTripseats(List seats) {
  String seatsStr = '';
  for (var s in seats) {
    seatsStr += (seatsStr == '' ? '' : ',') + s['SeatNo'].toString();
  }

  if (!isRoundTrip) myTripCome = MyTrip(DateTime.now());

  if (!getRoundTrip) {
    myTripGo.seatsStr = seatsStr;
    myTripGo.seats = seats;
    myTripGo.seatsCount = myTripGo.seats.length;
    myTripGo.tripSubDataId = myTripGo.trip['id'];
    myTripGo.tripPrice = isRoundTrip
        ? myTripGo.trip['TripPrice_GoCome'] / 2
        : myTripGo.trip['TripPrice'];
    //print(myTripGo.trip);
  } else {
    myTripCome.seatsStr = seatsStr;
    myTripCome.seats = seats;
    myTripCome.seatsCount = myTripCome.seats.length;
    myTripCome.tripSubDataId = myTripCome.trip['id'];
    myTripCome.tripPrice = isRoundTrip
        ? myTripCome.trip['TripPrice_GoCome'] / 2
        : myTripCome.trip['TripPrice'];
    //myTripCome.tripPrice = myTripCome.trip['TripPrice'];
  }

  cardTotal = myTripGo.seatsCount * myTripGo.tripPrice +
      myTripCome.seatsCount * myTripCome.tripPrice;
}

String formatNum(double n) => n.toString().replaceAll('.0', '');

Future<String> getOffices() async {
  //String s = 'https://gobus.me/api/V3/Login?userEmail=1&userPassword=1';
  String s = '$apiUrl/Stations?companyID=$companyID'; // 'https://gobus.me/api/V2/Stations?companyID=$companyID';
  var r = await http.get(Uri.parse(s));
  String ss = r.body;
  //offices = json.decode(ss);
  return ss;
}

// Future<String> getOffices2(int companyID) async{
//   api = apiUrl + "Stations?companyID=$companyID" + apiToAdd();
//   var v = await http.get(Uri.parse(api));
//   String ss = v.body;
//   offices = json.decode(ss);
//   return ss;
// }

Future getCouponsVal(String couponCode, int cardID) {
  api = "${apiUrl}GetCouponsVal?couponCode=$couponCode&cardID=$cardID${apiToAdd()}";
  return http.get(Uri.parse(api));
}
Future getCoupons() {
  api = "${apiUrl}GetCoupons?companyID=$companyID${apiToAdd()}";
  return http.get(Uri.parse(api));
}

Future getAppVer() {
  api = '${apiUrl}GetAppVer?companyID=$companyID${apiToAdd()}';
  return http.get(Uri.parse(api));
}

Future contactusSave(
    String userName, String userEmail, String userTelNo, String msg) {
  api =
      "${apiUrl}Contactus?Name=$userName&TelNo=$userTelNo&Email=$userEmail&companyID=$companyID&Msg=$msg${apiToAdd()}";
  return http.get(Uri.parse(api));
}

Future getMyTickets() {
  api = "${apiUrl}MyTickets?userID=${user.userID}${apiToAdd()}";
  return http.get(Uri.parse(api));
}

Future cancelSeats(String seatsIDs, int cardID) {
  api = "${apiUrl}CancelSeats?SeatsIDs=$seatsIDs&userID=${user.userID}&cardID=$cardID${apiToAdd()}";
  return http.post(Uri.parse(api));
}

Future userProfileUpdate(String userName, String userEmail, String userTelNo) {
  api =
      "${apiUrl}profileUpdate?&userID=${user.userID}&userName=$userName&userEmail=$userEmail&userTelNo=$userTelNo&userToken=${user.userToken}${apiToAdd()}";
  return http.get(Uri.parse(api));
}

Future userPasswordUpdate(String userPassword, String userPasswordNew) {
  api =
      "${apiUrl}profileUpdate?userID=${user.userID}&passwordOnly=true&userPassword=$userPassword&userPasswordNew=$userPasswordNew&userToken=${user.userToken}";
  return http.get(Uri.parse(api));
}

Future getTripSeats(int id) {
  api = "${apiUrl}GetSeats?tripSubData_Id=$id${apiToAdd()}";
  return http.get(Uri.parse(api));
}

Future getCnfg(String cnfgName) {
  api = "${apiUrl}GetCnfg?companyID=$companyID&cnfgName=$cnfgName${apiToAdd()}";
  return http.get(Uri.parse(api));
}

Future holdSeats() {
  api =
      "${apiUrl}HoldSeats?userID=${user.userID}&goSeats=${myTripGo.seatsStr}&goTripSubData_Id=${myTripGo.tripSubDataId}&userToken=${user.userToken}${apiToAdd()}";
  if (isRoundTrip) {
    api +=
        '&comeSeats=${myTripCome.seatsStr}&comeTripSubData_Id=${myTripCome.tripSubDataId}${apiToAdd()}';
  }
  return http.get(Uri.parse(api));
}

Future fawrySave() {
  api = "${apiUrl}BookingSave_Fawry?couponCode=$couponCode&userID=${user.userID}&cardID=$cardID&seatsCount=${myTripGo.seatsCount + myTripCome.seatsCount}&totalPrice=${cardTotal - couponDisc}&companyID=$companyID&userToken=${user.userToken}${apiToAdd()}";
  return http.get(Uri.parse(api));
}

Future<String> get loacalPath async {
  final path = await getApplicationDocumentsDirectory();
  return path.path;
}

Future<File> get loacalFile async {
  final file = await loacalPath;
  return File('$file/dataMike.txt');
}

Future<File> writeData(myStr) async {
  String str = myStr ??
      '${user.userEmail},${user.userPassword},${user.userID},${user.userIsFace},${user.usersocialID}';
  final file = await loacalFile;
  return file.writeAsString(str);
}

Future<String> readData() async {
  String s = '';
  try {
    final file = await loacalFile;
    s = await file.readAsString();
  } catch (e) {}
  return s;
}

Future login(String socialID, String userEmail, String userPassword) {
  api = userEmail.isNotEmpty
      ? "${apiUrl}Login?userEmail=$userEmail&userPassword=$userPassword&companyID=$companyID&lang=true${apiToAdd()}"
      : '${apiUrl}Login?socialID=$socialID&companyID=$companyID&lang=true${apiToAdd()}';
  return http.get(Uri.parse(api));
}

Future signup(String socialID, String userName, String userEmail,
    String userTelNo, String userPassword, String picUrl) {
  api =
      "${apiUrl}Signup?userName=$userName&userEmail=$userEmail&userTelNo=$userTelNo&userPassword=$userPassword&companyID=$companyID&lang=true" "&socialID=$socialID&pic_Url=$picUrl&socialTypeID=1" +
          apiToAdd();
  return http.get(Uri.parse(api));
}

Future getTrips() {
  DateTime tripDate =
      myTripGo.date; //=getRoundTrip?dateToSelected:myTripGo.date;

  int _codeFrom = codeFrom, _codeTo = codeTo;
  if (getRoundTrip) {
    tripDate = getRoundTrip ? myTripCome.date : myTripGo.date;
    _codeFrom = codeTo;
    _codeTo = codeFrom;
  }

  api =
      '${apiUrl}GetTrips?From=$_codeFrom&To=$_codeTo&tripDate=$tripDate&companyID=$companyID&token=$token${apiToAdd()}';
  return http.get(Uri.parse(api));
}

void pageTrips(context) {
  Navigator.push(
      context,  MaterialPageRoute(builder: (context) => GetTrips()));
}

AppBar myAppBar(String myTitle) {
  return AppBar(
      iconTheme: IconThemeData(
        color: myColors.appBarIcon, //change your color here
      ),
      //leading: logo(),0xff443a49   0xffEC1D24
      backgroundColor: myColors.appBar,
      elevation: 0,
      title: Center(
          child: companyID == 1
              ? Image(image: AssetImage(imglogo), height: 30)
              : Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    companyID == 10
                        ? Image(
                            image: AssetImage(imglogo),
                            fit: BoxFit.contain,
                            height: companyID == 10 ? 40 : 45,
                          )
                        : const Text(""),
                    Expanded(
                        child: Container(
                            alignment: Alignment.center,
                            child: Text(myTitle,
                                style: TextStyle(
                                    fontSize: 16, color: myColors.titelColor))))
                    //SizedBox(width: 20),
                  ],
                ))
      //:
      //Text(myTitle,            style: TextStyle(fontSize: 25.0, color: Colors.black))),
      );
}

class AppBarEx extends StatefulWidget {
  final Widget wdg;
  const AppBarEx(this.wdg, {super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AppBarExState createState() => _AppBarExState();
}

class _AppBarExState extends State<AppBarEx> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: 56,
      child: Stack(
        children: <Widget>[
          Positioned(
              child: Container(
            height: 30,
            color: myColors.appBar,
          )),
          Positioned(
            top: 5,
            left: 12,
            width: MediaQuery.of(context).size.width - 24,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: myColors.goComeBckAll,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black54,
                      offset: Offset(1, 1),
                      blurRadius: 2,
                    ),
                  ]),
              child: widget.wdg,
            ),
          )
        ],
      ),
    );
  }
}

Scaffold myScaffold(String appBarTitle, Widget myBody) {
  return Scaffold(
    appBar: AppBar(
      title: Center(
        child: Text(appBarTitle),
      ),
    ),
    body: myBody,
  );
}

Widget trpTitle() {
  bool isCome = getRoundTrip;
  DateTime t = !getRoundTrip
      ? myTripGo.date
      : myTripCome.date; //=getRoundTrip?dateToSelected:myTripGo.date;

  return Row(
    textDirection: TextDirection.rtl,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text(
        isCome ? officeNameTo : officeNameFrom,
        style: TextStyle(
            fontSize: 14, fontWeight: FontWeight.bold, color: myColors.dark),
      ),
      const Padding(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: Icon(
          Icons.arrow_back,
          size: 22,
          color: Colors.red,
        ),
      ),
      Text(
        !isCome ? officeNameTo : officeNameFrom,
        style: TextStyle(
            fontSize: 14, fontWeight: FontWeight.bold, color: myColors.dark),
      ),
      const SizedBox(
        width: 14,
      ),
      Text(
        '${t.month}/${t.day}',
        style: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red),
      )
    ],
  );
}

Future msg(context, txt) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('موافق'),
            )
          ],
          content: Container(
            //height: 100,
            child: Text('$txt'),
          ),
        );
      });
}

Widget confirmTitle(bool withcouponDisc) {
  return Container(
    //padding: EdgeInsets.all(0),
    //height: 50,
    //color: Colors.red,
    child: Row(
      textDirection: TextDirection.rtl,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SizedBox(width: 30),
        const Text(
          'الاجمالى',
          style: TextStyle(fontSize: 20, color: Colors.grey),
          textAlign: TextAlign.left,
        ),
        Expanded(
          child: Text(
            '${formatNum(cardTotal - (withcouponDisc ? couponDisc : 0))} جنيه',
            style: const TextStyle(fontSize: 25, color: Colors.black),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(width: 10),
      ],
    ),
  );
}

Widget pnldate(context, int direction) {
  return Theme(
    data: _themeData,
    child: Expanded(
      child: dt.GetDate(direction),
    ),
  );
}
