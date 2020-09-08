import 'package:flutter/material.dart';
import 'package:newsApp/model/charrtModel.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:newsApp/provider/news.dart';
import 'package:provider/provider.dart';

class ChartScreen extends StatefulWidget {
  @override
  _ChartScreenState createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  List<ChartData> _data;
  // var _init = true;
  var _loading = true;
  var _nodata = true;

  final _searchController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // if (_init) {
    //   Provider.of<News>(context, listen: false)
    //       .chartData(_searchController.text)
    //       .then((value) {
    //     _data = value;
    //   });
    //   _init = false;
    // }
  }

  @override
  Widget build(BuildContext context) {
    List<charts.Series<ChartData, String>> series = [
      charts.Series(
          id: "Subscribers",
          data: _data,
          domainFn: (ChartData series, _) => series.day,
          measureFn: (ChartData series, _) => series.noOfArticles,
          colorFn: (ChartData series, _) => series.barColor)
    ];
    return Column(
      children: [
        Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.white),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10),
              hintText: 'Search for the topic..',
              hintStyle: TextStyle(fontWeight: FontWeight.w100),
            ),
            onSubmitted: (val) {
              setState(() {
                _loading = true;
              });
              Provider.of<News>(context, listen: false)
                  .chartData(val)
                  .then((value) {
                _data = value;
                setState(() {
                  _nodata = false;
                  _loading = false;
                });
              });
            },
          ),
        ),
        Expanded(
          child: _nodata
              ? Center(
                  child: Text('no data please search for the topic'),
                )
              : _loading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      height: 400,
                      padding: EdgeInsets.all(20),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Text(
                                "Total result for ${_searchController.text}  past week",
                                // style: Theme.of(context).textTheme.body2,
                              ),
                              Expanded(
                                child: charts.BarChart(
                                  series,
                                  animate: true,
                                  // vertical: true,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
        ),
      ],
    );
  }
}
