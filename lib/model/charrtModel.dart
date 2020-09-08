// import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/foundation.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ChartData {
  final String day;
  final int index;
  final int noOfArticles;
  final charts.Color barColor;

  ChartData({
    @required this.day,
    @required this.noOfArticles,
    @required this.barColor,
    this.index,
  });
}
