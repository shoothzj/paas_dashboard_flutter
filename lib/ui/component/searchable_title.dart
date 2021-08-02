import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchableTitle extends StatelessWidget {
  final String title;

  final String searchHint;

  final TextEditingController searchController;

  SearchableTitle(this.title, this.searchHint, this.searchController);

  @override
  Widget build(BuildContext context) {
    var searchBox = Container(
      width: 300,
      child: TextFormField(
        controller: searchController,
        decoration: InputDecoration(hintText: searchHint),
      ),
    );
    return Container(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: [
          Container(
            child: Text(
              title,
              style: TextStyle(fontSize: 30),
            ),
          ),
          searchBox
        ],
      ),
    );
  }
}
