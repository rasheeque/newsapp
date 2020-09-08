import 'package:flutter/cupertino.dart';

class NewsDetails with ChangeNotifier {
  int totalResults;
  String source;
  String title;
  String urlToImage;
  String content;
  DateTime publishedAt;

  NewsDetails(
      {@required this.source,
      @required this.title,
      @required this.totalResults,
      @required this.urlToImage,
      @required this.content,
      @required this.publishedAt});
}
