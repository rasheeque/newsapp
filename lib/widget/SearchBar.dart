import 'package:flutter/material.dart';
import 'package:newsApp/provider/news.dart';
import 'package:provider/provider.dart';

class SearchBar extends StatefulWidget {
  SearchBar({this.refreshPage});
  final Function refreshPage;
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  var _autoRefresh = false;
  var _closeIcon = false;
  final _searchController = TextEditingController();
  void refreshSwitch(bool toggle) {
    setState(() {
      _autoRefresh = toggle;
    });

    toggle
        ? Provider.of<News>(context, listen: false).autorefresh()
        : Provider.of<News>(context, listen: false).stoptimer();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10),
                hintText: 'Search for the topic..',
                hintStyle: TextStyle(fontWeight: FontWeight.w100),
              ),
              onSubmitted: (val) {
                Provider.of<News>(context, listen: false)
                    .filteredNews(val)
                    .then((_) {});

                setState(() {
                  _closeIcon = true;
                });
              },
            ),
          ),
          if (_closeIcon)
            IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  widget.refreshPage();
                  setState(() {
                    _searchController.text = '';
                    _closeIcon = false;
                  });
                }),
          Switch(
            value: _autoRefresh,
            onChanged: (toggle) => refreshSwitch(toggle),
            activeColor: Colors.black,
            inactiveThumbColor: Colors.grey,
          ),
        ],
      ),
    );
  }
}
