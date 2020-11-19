import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:dorona/colors1.dart';
import 'package:dorona/providers/bottomBarProvider.dart';
import 'package:dorona/styles.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CovidUpdates extends StatefulWidget {
  @override
  _CovidUpdatesState createState() => _CovidUpdatesState();
}

class _CovidUpdatesState extends State<CovidUpdates> {
  int _currentIndex = 0;
  Future data;
  Color color = Colors.red;
  int graphType = 0;
  ScrollController scrollController;
  @override
  void initState() {
    data = fetchCoronaData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final bottomBarProvider = Provider.of<BottomBarProvider>(context);
    // scrollController = ScrollController()
    //   ..addListener(() {
    //     if (scrollController.position.pixels > 512) {
    //       if (!bottomBarProvider.isShowBottom) {
    //         print("find widget");
    //         print(scrollController.offset);
    //         bottomBarProvider.changeBottom(true);
    //       }
    //     }
    //     if (scrollController.position.pixels < 512) {
    //       if (bottomBarProvider.isShowBottom) {
    //         print("find widget");
    //         print(scrollController.offset);
    //         bottomBarProvider.changeBottom(false);
    //       }
    //     }
    //   });
    return SingleChildScrollView(
      controller: scrollController,
      child: Container(
        height: 2830,
        width: width,
        color: Colors.white,
        child: FutureBuilder(
            future: data,
            builder: (ctx, snapshot) {
              if (!snapshot.hasData) {
                return Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ));
              }
              if (snapshot.hasError) {
                return Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ));
              }
              if (snapshot.hasData) {
                List<dynamic> dailyData = snapshot.data['dailyData'];
                List<dynamic> stateData = snapshot.data['stateData'];
                return Column(
                  children: [
                    Container(
                        width: width,
                        color: Color(0xFFF5F5F7),
                        padding: EdgeInsets.only(top: 10, left: 10, bottom: 2),
                        child: Text(
                          "Covid-19 cases overview",
                          style: titleTextStyle,
                        )),
                    Container(
                        width: width,
                        color: Color(0xFFF5F5F7),
                        padding: EdgeInsets.only(left: 10, bottom: 10),
                        child: Text(
                          "Updated on ${snapshot.data['dailyData'][snapshot.data['dailyData'].length - 1]['date']}",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        )),
                    SizedBox(height: 10),
                    Container(
                        child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _currentIndex = 0;
                                    color = Colors.red;
                                  });
                                },
                                child: Container(
                                    width: width * 0.4,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: _currentIndex == 0
                                            ? blueColor.withOpacity(0.2)
                                            : Colors.grey.withOpacity(0.1),
                                        border: Border.all(
                                            color: _currentIndex == 0
                                                ? blueColor
                                                : Colors.grey.withOpacity(0.2)),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                      child: Text(
                                        'Active',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15),
                                      ),
                                    )),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _currentIndex = 1;
                                  color = Colors.green;
                                });
                              },
                              child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: _currentIndex == 1
                                        ? blueColor.withOpacity(0.2)
                                        : Colors.grey.withOpacity(0.1),
                                    border: Border.all(
                                        color: _currentIndex == 1
                                            ? blueColor
                                            : Colors.grey.withOpacity(0.2)),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  width: width * 0.4,
                                  child: Center(
                                    child: Text(
                                      'Recovered',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15),
                                    ),
                                  )),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _currentIndex = 2;
                                    color = Colors.green;
                                  });
                                },
                                child: Container(
                                    width: width * 0.4,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: _currentIndex == 2
                                            ? blueColor.withOpacity(0.2)
                                            : Colors.grey.withOpacity(0.1),
                                        border: Border.all(
                                            color: _currentIndex == 2
                                                ? blueColor
                                                : Colors.grey.withOpacity(0.2)),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                      child: Text(
                                        'Deceased',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15),
                                      ),
                                    )),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _currentIndex = 3;
                                  color = Colors.red;
                                });
                              },
                              child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: _currentIndex == 3
                                        ? blueColor.withOpacity(0.2)
                                        : Colors.grey.withOpacity(0.1),
                                    border: Border.all(
                                        color: _currentIndex == 3
                                            ? blueColor
                                            : Colors.grey.withOpacity(0.2)),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  width: width * 0.4,
                                  child: Center(
                                    child: Text(
                                      'Confirmed',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15),
                                    ),
                                  )),
                            )
                          ],
                        ),
                        FadeIn(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: SizedBox(
                              child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.82,
                                  decoration: BoxDecoration(
                                      color: color.withAlpha(30),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  child: Padding(
                                      padding: const EdgeInsets.all(25.0),
                                      child: FadeIn(
                                        child: DailyCaseBar(
                                          data: dailyData,
                                          index: _currentIndex,
                                          color: color,
                                        ),
                                      ))),
                            ),
                          ),
                        )
                      ],
                    )),
                    Container(
                        width: width,
                        color: Color(0xFFF5F5F7),
                        padding: EdgeInsets.only(top: 10, left: 10, bottom: 10),
                        child: Text("All state/UT stats",
                            style: GoogleFonts.aleo(
                                color: blueColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold))),
                    Container(
                      color: Color(0xFFF5F5F7),
                      height: 35,
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Active',
                            style: GoogleFonts.aleo(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          Text(
                            'Recovered',
                            style: GoogleFonts.aleo(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          Text(
                            'Deceased',
                            style: GoogleFonts.aleo(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Confirmed',
                            style: GoogleFonts.aleo(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                        child: StateList(
                      data: stateData,
                    )),
                  ],
                );
              }
            }),
      ),
    );
  }

  Future<Map<String, dynamic>> fetchCoronaData() async {
    var result = await http.get('https://api.covid19india.org/data.json');
    List<dynamic> dailyData = json.decode(result.body)['cases_time_series'];
    dailyData.removeRange(0, 75);
    List<dynamic> stateData = json.decode(result.body)['statewise'];
    var corona = {'dailyData': dailyData, 'stateData': stateData};
    return corona;
  }
}

class DailyCaseBar extends StatelessWidget {
  DailyCaseBar({
    Key key,
    @required this.data,
    @required this.index,
    @required this.color,
  }) : super(key: key);

  final List data;
  final int index;
  final Color color;
  String tag;

  @override
  Widget build(BuildContext context) {
    if (index == 1)
      tag = 'dailyrecovered';
    else if (index == 2)
      tag = 'dailydeceased';
    else if (index == 3)
      tag = 'dailyconfirmed';
    else
      tag = 'active';

    return Container(
      height: MediaQuery.of(context).size.width * 0.50,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceBetween,
          //maxY: maxY,
          barTouchData: BarTouchData(
              enabled: true, touchTooltipData: BarTouchTooltipData()),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: SideTitles(
              showTitles: false,
            ),
            leftTitles: SideTitles(
              margin: 10.0,
              showTitles: true,
              getTitles: ((value) {
                if (value == 0) return '0';
                if (value % 100000 == 0)
                  return '${(value / 100000).toInt()}L';
                else if (value % 10000 == 0)
                  return '${(value / 10000).toInt()}0K';
                if (tag == "dailydeceased") {
                  if (value % 200 == 0) {
                    if (value >= 1000) {
                      if (value % 1000 == 0)
                        return '${(value / 1000).toInt()}K';
                      return '${value / 1000}K';
                    }
                    return '${(value).toInt()}';
                  }
                }
                if (tag == 'active' && value % 2000 == 0) {
                  return '${value / 1000}K';
                }

                return '';
              }),
            ),
          ),
          gridData: FlGridData(
              show: true,
              checkToShowHorizontalLine: (value) {
                if (tag == "dailydeceased")
                  return value % 200 == 0 || value == 0;
                else if (tag == 'active') {
                  return value % 2000 == 0;
                }
                return value % 10000 == 0 || value == 0;
              },
              getDrawingHorizontalLine: (value) {
                if (value == 0)
                  return FlLine(
                    color: Colors.black,
                    strokeWidth: 3,
                  );
                return FlLine(
                  color: Colors.black12,
                  strokeWidth: 1,
                );
              }),
          borderData:
              FlBorderData(show: true, border: Border(bottom: BorderSide())),
          barGroups: data
              .asMap()
              .map((key, value) {
                double val;
                if (index == 0) {
                  val = double.parse(value['dailyconfirmed']) -
                      double.parse(value['dailydeceased']) -
                      double.parse(value['dailyrecovered']);
                } else
                  val = double.parse(value[tag]);
                return MapEntry(
                    key,
                    BarChartGroupData(
                      x: key,
                      barRods: [
                        BarChartRodData(
                            y: val < 0 ? 0 : val, color: color, width: 0.5),
                      ],
                    ));
              })
              .values
              .toList(),
        ),
      ),
    );
  }
}

class StateList extends StatefulWidget {
  final List<dynamic> data;

  const StateList({this.data});

  @override
  _StateListState createState() => _StateListState();
}

class _StateListState extends State<StateList> {
  @override
  Widget build(BuildContext context) {
    print(widget.data.length);
    return ListView.builder(
      itemCount: widget.data.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (ctx, index) {
        var data = widget.data[index];
        return Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 5,
              ),
              Text(
                data['state'],
                style: GoogleFonts.aleo(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 2.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    data['active'],
                    style: GoogleFonts.aleo(
                      color: Colors.red,
                    ),
                  ),
                  Text(
                    data['recovered'],
                    style: GoogleFonts.aleo(
                      color: Colors.green,
                    ),
                  ),
                  Text(
                    data['deaths'],
                    style: GoogleFonts.aleo(),
                  ),
                  Text(
                    data['confirmed'],
                    style: GoogleFonts.aleo(
                      color: Colors.red,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Divider()
              /*Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ''.padLeft(data['active'].toString().length),
                    style: TextStyle(
                        color: Colors.red
                    ),
                  ),
                  Text(
                    data['deltarecovered'],
                    style: TextStyle(
                      color: Colors.green,
                    ),
                  ),
                  Text(
                    data['deltadeaths'],
                    style: TextStyle(
                        color: Colors.black
                    ),
                  ),
                  Text(
                    data['deltaconfirmed'],
                    style: TextStyle(
                        color: Colors.red
                    ),
                  )
                ],
              )*/
            ],
          ),
        );
      },
    );
  }
}
