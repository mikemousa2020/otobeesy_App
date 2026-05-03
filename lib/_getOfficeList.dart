library goldenhorse;

import 'package:flutter/material.dart';
import 'callApi.dart';

class GetOffLi extends StatelessWidget {
  final li;
  final int selCode;

  const GetOffLi(this.li, this.selCode, {super.key});
  @override
  Widget build(BuildContext context) {
    bool isSelected = selCode == li['Code'];

    return Container(
      //onDismissed: (dirction) {},
      //background: Container(        color: Colors.red,      ),
      //secondaryBackground: Container(        color: Colors.green,      ),
      key: Key(li['NameA']),
      child: Column(
        children: <Widget>[
          Container(
              alignment: Alignment.topRight,
              padding: const EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 5.0),
              child: Row(
                textDirection: TextDirection.rtl,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Text(
                      li['NameA'],
                      textAlign: TextAlign.end,
                      textDirection: TextDirection.ltr,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: (isSelected
                        ? const Icon(Icons.check, color: Colors.green)
                        : const Text('')),
                  ),
                  // new CircleAvatar(
                  //   child: Text(li['Code'].toString()),
                  //   backgroundColor: Colors.redAccent,
                  // ),
                ],
              )),
          const Divider(),
        ],
      ),
    );
  }
}

//int selCode = 0;

class OfficePnl extends StatefulWidget {
  final BuildContext cntx;
  final int direction;
  const OfficePnl(this.cntx, this.direction, {super.key});

  @override
  _OfficePnlState createState() => _OfficePnlState();
}

class _OfficePnlState extends State<OfficePnl> {
  //_OfficePnlState(this.direction);

  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    for (var u in offices) {
      if (widget.direction == 1 && codeFrom == u['Code']) {
        officeNameFrom = u['NameA'];
      }
      if (widget.direction == 2 && codeTo == u['Code']) {
        officeNameTo = u['NameA'];
      }
    }

    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => GetOffice(widget.direction, refresh),
        );
      },
      child: Container(
        //alignment: AlignmentDirectional.centerEnd,
        //alignment: Alignment.topRight,
        padding: const EdgeInsets.only(right: 40.0, left: 20.0),
        child: Column(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.direction == 1 ? 'من' : 'الى',
              style: TextStyle(color: myColors.officeTtl, fontSize: 15.0),
            ),
            Row(
              textDirection: TextDirection.rtl,
              children: <Widget>[
                Expanded(
                  flex: 7,
                  child: Text(
                    widget.direction == 1 ? officeNameFrom : officeNameTo,
                    //officeNameFrom,
                    style: TextStyle(color: myColors.office, fontSize: 23.0),
                    textDirection: TextDirection.rtl,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Icon(
                    Icons.chevron_left,
                    color: myColors.office,
                    size: 40,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class GetOffice extends StatefulWidget {
  final dirction;
  final Function() notifyParent;
  //ChildWidget({Key key, @required this.notifyParent}) : super(key: key);

  const GetOffice(this.dirction, this.notifyParent, {super.key});
  //GetOffice({Key key,this.dirction, @required this.notifyParent}): super(key: key);

  @override
  _GetOfficeState createState() => _GetOfficeState();
}

class _GetOfficeState extends State<GetOffice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Center(
          child: Text('اختار المحطة'),
        ),
        backgroundColor: myColors.dark,
      ),
      body: ListView.builder(
        itemCount: offices.length,
        itemBuilder: (context, index) {
          return InkWell(
            //child: GetOffLi(offices[index], selCode),
            child: GetOffLi(
                offices[index], widget.dirction == 1 ? codeFrom : codeTo),
            onTap: () {
              if (widget.dirction == 1) {
                codeFrom = offices[index]['Code'];
                officeNameFrom = offices[index]['NameA'];
              } else {
                codeTo = offices[index]['Code'];
                officeNameTo = offices[index]['NameA'];
              }
              
              widget.notifyParent();
              Navigator.of(context).pop();
            },
          );
        },
      ),
    );
  }
}
