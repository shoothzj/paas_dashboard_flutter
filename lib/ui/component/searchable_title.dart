//
// Licensed to the Apache Software Foundation (ASF) under one
// or more contributor license agreements.  See the NOTICE file
// distributed with this work for additional information
// regarding copyright ownership.  The ASF licenses this file
// to you under the Apache License, Version 2.0 (the
// "License"); you may not use this file except in compliance
// with the License.  You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.
//

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
