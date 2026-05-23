library goldenhorse;

import 'package:flutter/material.dart';
import 'callApi.dart';
import 'station_data.dart';

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
          builder: (context) => SearchableGetOffice(widget.direction, refresh),
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

/// A searchable, region-grouped station selection dialog.
///
/// Replaces the flat [GetOffice] dialog with a grouped experience:
/// stations are organized by region, searchable by Arabic name,
/// and duplicates are disambiguated with code suffixes.
class SearchableGetOffice extends StatefulWidget {
  final int direction;
  final VoidCallback notifyParent;

  const SearchableGetOffice(this.direction, this.notifyParent, {super.key});

  @override
  State<SearchableGetOffice> createState() => _SearchableGetOfficeState();
}

class _SearchableGetOfficeState extends State<SearchableGetOffice> {
  late TextEditingController _searchController;
  List<StationGroup> _groups = [];
  List<StationGroup> _filteredGroups = [];
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _groups = groupStationsByRegion(offices);
    _filteredGroups = _groups;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Center(child: Text('اختار المحطة')),
        backgroundColor: myColors.dark,
      ),
      body: Column(
        children: [
          // Search field
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'ابحث عن محطة',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _filteredGroups = _groups;
                          });
                        },
                      )
                    : null,
                border: const OutlineInputBorder(),
              ),
              onChanged: (query) {
                setState(() {
                  if (query.isEmpty) {
                    _filteredGroups = _groups;
                  } else {
                    _filteredGroups = filterStations(_groups, query);
                  }
                });
              },
            ),
          ),
          // Results area
          Expanded(
            child: _filteredGroups.isEmpty
                ? const Center(child: Text('لا توجد نتائج'))
                : ListView(
                    children: _filteredGroups.map((group) {
                      return ExpansionTile(
                        title: Text(
                          group.regionName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        initiallyExpanded: false,
                        children: group.stations.map((station) {
                          // Disambiguate the duplicate stations (both named "أحمد حلمي")
                          final isDuplicate =
                              station.code == 585 || station.code == 2113;
                          final displayName = isDuplicate
                              ? '${station.nameA} (Code: ${station.code})'
                              : station.nameA;
                          final bool isSelected = widget.direction == 1
                              ? codeFrom == station.code
                              : codeTo == station.code;

                          return InkWell(
                            onTap: () {
                              if (widget.direction == 1) {
                                codeFrom = station.code;
                                officeNameFrom = station.nameA;
                              } else {
                                codeTo = station.code;
                                officeNameTo = station.nameA;
                              }
                              widget.notifyParent();
                              Navigator.of(context).pop();
                            },
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.topRight,
                                  padding: const EdgeInsets.fromLTRB(
                                      30.0, 5.0, 30.0, 5.0),
                                  child: Row(
                                    textDirection: TextDirection.rtl,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          displayName,
                                          textAlign: TextAlign.end,
                                          textDirection: TextDirection.ltr,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: isSelected
                                            ? const Icon(Icons.check,
                                                color: Colors.green)
                                            : const Text(''),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }
}
