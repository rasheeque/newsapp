import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
// import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:newsApp/provider/news.dart';
import 'package:newsApp/widget/SearchBar.dart';
import 'package:provider/provider.dart';
// import 'package:http/http.dart' as http;

class NewsScreen extends StatefulWidget {
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  var _autoRefresh = false;
  var _closeIcon = false;
  var _loading = false;
  final _searchController = TextEditingController();

  Future<void> _searchNews(BuildContext context, String searchString) async {
    Provider.of<News>(context, listen: false).filteredNews(searchString);
  }

  void _refreshSwitch() {
    print('hello');
    // if (toggle)
    // Provider.of<News>(context, listen: false).autorefresh();
    setState(() {
      // _autoRefresh = toggle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Container(
        //   height: 50,
        //   width: double.infinity,
        //   decoration: BoxDecoration(color: Colors.white),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       Expanded(
        //         child: TextField(
        //           controller: _searchController,
        //           decoration: InputDecoration(
        //             contentPadding: EdgeInsets.all(10),
        //             hintText: 'Search for the topic..',
        //             hintStyle: TextStyle(fontWeight: FontWeight.w100),
        //           ),
        //           onSubmitted: (val) {
        //             Provider.of<News>(context, listen: false)
        //                 .filteredNews(val)
        //                 .then((_) {});

        //             setState(() {
        //               _closeIcon = true;
        //             });
        //           },
        //         ),
        //       ),
        //       if (_closeIcon)
        //         IconButton(
        //             icon: Icon(Icons.close),
        //             onPressed: () {
        //               setState(() {
        //                 _searchController.text = '';
        //                 _closeIcon = false;
        //               });
        //             }),
        //       Switch(
        //         value: _autoRefresh,
        //         onChanged: (toggle) => refreshSwitch(toggle),
        //         activeColor: Colors.black,
        //         inactiveThumbColor: Colors.grey,
        //       ),
        //     ],
        //   ),
        // ),
        SearchBar(
          refreshPage: _refreshSwitch,
        ),
        Expanded(
          child: FutureBuilder(
            future: Provider.of<News>(context, listen: false).fetchHeadlines(),
            builder: (ctx, snapshot) {
              debugPrint('result has data =${snapshot.hasData}');
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return RefreshIndicator(
                  onRefresh: () => Provider.of<News>(context, listen: false)
                      .fetchHeadlines(),
                  child: Container(
                    // height: MediaQuery.of(context).size.height / 0.9,
                    padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                    child: Consumer<News>(
                      builder: (ctx, loadedData, child) => ListView.builder(
                        itemCount: loadedData.news.length,
                        itemBuilder: (context, index) {
                          return _newsTile(
                            context: context,
                            imgPath: loadedData.news[index].urlToImage,
                            mainHead: loadedData.news[index].title,
                            subHead: loadedData.news[index].content == null
                                ? ''
                                : loadedData.news[index].content,
                          );
                        },
                        shrinkWrap: true,
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _newsTile({String imgPath, String mainHead, String subHead, context}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover, image: NetworkImage(imgPath)),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          width: 75,
          height: 75,
        ),
        Expanded(
          child: Container(
            height: 100,
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    mainHead,
                    // textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.start,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      subHead,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
