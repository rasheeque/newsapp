import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:newsApp/model/charrtModel.dart';
import 'package:newsApp/model/newsDetails.dart';
import 'package:newsApp/model/newsModel.dart';
import 'package:charts_flutter/flutter.dart' as chart;

class News with ChangeNotifier {
  static const duration = const Duration(seconds: 3);
  Timer timer;
  List<ChartData> _chartData = [];
  List<NewsDetails> _news = [];
  // News(this._news);
  List get news {
    return [..._news];
  }

  Future<void> fetchHeadlines() async {
    print('fetch and set headlines');
    const headlineUrl =
        'https://newsapi.org/v2/top-headlines?country=in&apiKey=58080b15b8eb43cab6ee74b4dcc7915d';
    try {
      final response = await http.get(headlineUrl);
      final List<NewsDetails> loadNews = [];
      if (response.statusCode == 200) {
        final extractedData = json.decode(response.body);
        if (extractedData == null) {
          return;
        }
        NewsModel model = NewsModel.fromJson(extractedData);
        model.articles.forEach(
          (element) {
            loadNews.add(
              NewsDetails(
                source: element.source.name ?? '',
                title: element.title ?? '',
                totalResults: model.totalResults ?? '',
                urlToImage: element.urlToImage ?? '',
                content: element.content ?? '',
                publishedAt: element.publishedAt ?? '',
              ),
            );
          },
        );
        _news = loadNews;
      }
    } catch (err) {
      throw err;
    }

    // print(json.decode(response.body));
    notifyListeners();
  }

  Future<void> filteredNews(String seachString) async {
    final headlineUrl =
        'https://newsapi.org/v2/everything?q=$seachString&apiKey=58080b15b8eb43cab6ee74b4dcc7915d';
    try {
      final response = await http.get(headlineUrl);
      final List<NewsDetails> loadNews = [];
      if (response.statusCode == 200) {
        final extractedData = json.decode(response.body);
        if (extractedData == null) {
          return;
        }
        NewsModel model = NewsModel.fromJson(extractedData);
        model.articles.forEach(
          (element) {
            loadNews.add(
              NewsDetails(
                source: element.source.name ?? '',
                title: element.title ?? '',
                totalResults: model.totalResults ?? '',
                urlToImage: element.urlToImage ?? '',
                content: element.content ?? '',
                publishedAt: element.publishedAt ?? '',
              ),
            );
          },
        );
        _news = loadNews;
      }
    } catch (err) {
      throw err;
    }
    notifyListeners();
  }

  Future<List<ChartData>> chartData(String seachString) async {
    DateTime from = DateTime.now().subtract(Duration(days: 7));
    DateTime to = DateTime.now();

    final headlineUrl =
        'https://newsapi.org/v2/everything?qInTitle=$seachString&apiKey=58080b15b8eb43cab6ee74b4dcc7915d&from=$from&to=$to&pageSize=100';

    try {
      final response = await http.get(headlineUrl);
      final List<NewsDetails> loadNews = [];
      if (response.statusCode == 200) {
        final extractedData = json.decode(response.body);
        if (extractedData == null) {
          return null;
        }
        NewsModel model = NewsModel.fromJson(extractedData);
        model.articles.forEach(
          (element) {
            loadNews.add(
              NewsDetails(
                  source: element.source.name ?? '',
                  title: element.title ?? '',
                  totalResults: model.totalResults ?? '',
                  urlToImage: element.urlToImage ?? '',
                  content: element.content ?? '',
                  publishedAt: element.publishedAt),
            );
          },
        );
        print(loadNews.length);
        for (int i = 1; i <= 7; i++) {
          int totalRes = loadNews
                  .where((element) => element.publishedAt
                      .isAfter(DateTime.now().subtract(Duration(days: i))))
                  .toList()
                  .length ??
              0;

          String day = DateFormat('E')
              .format(DateTime.now().subtract(Duration(days: i)));

          print('day= $day==total= $totalRes');
          _chartData.add(
            ChartData(
              index: i,
              day: day,
              noOfArticles: totalRes,
              barColor: chart.ColorUtil.fromDartColor(Colors.blue),
            ),
          );
        }
      }
      return _chartData..sort((a, b) => b.index.compareTo(a.index));
    } catch (err) {
      throw err;
    }
  }

  void autorefresh() {
    timer = Timer.periodic(
      duration,
      (t) {
        filteredNews(t.tick.toString());
        // print(t.tick.toString());
        // print('in');
      },
    );
    // ChangeNotifier();
  }

  void stoptimer() {
    print('stopping the timer=  ${timer.isActive}');

    if (timer.isActive) timer.cancel();
  }
}
