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
import 'package:paas_dashboard_flutter/generated/l10n.dart';

class DynamicFilterTable extends StatefulWidget {
  final ColumnNotifier _notifier;

  final FilterCallBack callBack;

  DynamicFilterTable(this._notifier, this.callBack);

  @override
  State<StatefulWidget> createState() {
    return new _DynamicFilterTableState(_notifier, callBack);
  }
}

class ColumnNotifier extends ChangeNotifier {
  List<String> _columns = [];

  List<String> get columns => _columns;

  setColumns(List<String> columns) {
    _columns = columns;
    notifyListeners();
  }
}

class _DynamicFilterTableState extends State<DynamicFilterTable> {
  ColumnNotifier _notifier;

  List<DropDownButtonData> rowData = [];

  DataTable? table;

  FilterCallBack callBack;

  _DynamicFilterTableState(this._notifier, this.callBack);

  @override
  void initState() {
    super.initState();
  }

  addRow() async {
    setState(() {
      DropDownButtonData data = new DropDownButtonData(_notifier.columns[0], OP.EQ, rowData.length, true);
      rowData.add(data);
    });
  }

  deleteRow() async {
    setState(() {
      if (rowData.isNotEmpty) {
        rowData.removeLast();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var filterButton = TextButton(
        onPressed: () {
          if (rowData.isNotEmpty) {
            callBack.execute(rowData);
          }
        },
        child: Text(S.of(context).filter));
    var addButton = TextButton(onPressed: () => {addRow()}, child: Text("+"));
    var deleteButton = TextButton(onPressed: () => {deleteRow()}, child: Text("-"));
    DataColumn filterColumn = new DataColumn(label: filterButton);
    DataColumn addColumn = new DataColumn(label: addButton);
    DataColumn deleteColumn = new DataColumn(label: deleteButton);
    DataColumn joinColumn = new DataColumn(label: Text(""));

    table = DataTable(
        columns: [filterColumn, addColumn, deleteColumn, joinColumn],
        rows: rowData.map((e) => getDataRow(e)).toList(),
        headingTextStyle: new TextStyle(color: Colors.grey));

    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: <Widget>[Container(child: table!)],
    );
  }

  List<DropdownMenuItem<OP>> getOpMenu() {
    List<DropdownMenuItem<OP>> rs = [];
    rs.add(new DropdownMenuItem(child: Text("="), value: OP.EQ));
    rs.add(new DropdownMenuItem(child: Text("!="), value: OP.NOT_EQ));
    rs.add(new DropdownMenuItem(child: Text("<"), value: OP.LT));
    rs.add(new DropdownMenuItem(child: Text(">"), value: OP.GT));
    rs.add(new DropdownMenuItem(child: Text("<="), value: OP.LT_EQ));
    rs.add(new DropdownMenuItem(child: Text(">="), value: OP.GT_EQ));
    rs.add(new DropdownMenuItem(child: Text("is null"), value: OP.NULL));
    rs.add(new DropdownMenuItem(child: Text("is not null"), value: OP.NOT_NULL));
    rs.add(new DropdownMenuItem(child: Text("include"), value: OP.INCLUDE));
    rs.add(new DropdownMenuItem(child: Text("exclude"), value: OP.EXCLUDE));
    rs.add(new DropdownMenuItem(child: Text("begin with"), value: OP.BEGIN));
    rs.add(new DropdownMenuItem(child: Text("end with"), value: OP.END));
    rs.add(new DropdownMenuItem(child: Text("contain"), value: OP.CONTAIN));
    return rs;
  }

  List<DropdownMenuItem<bool>> getJoinMenu() {
    List<DropdownMenuItem<bool>> rs = [];
    rs.add(new DropdownMenuItem(child: Text("AND"), value: true));
    rs.add(new DropdownMenuItem(child: Text("OR"), value: false));
    return rs;
  }

  List<DropdownMenuItem<TYPE>> getTypeMenu() {
    List<DropdownMenuItem<TYPE>> rs = [];
    rs.add(new DropdownMenuItem(child: Text("TEXT"), value: TYPE.TEXT));
    rs.add(new DropdownMenuItem(child: Text("NUMBER"), value: TYPE.NUMBER));
    rs.add(new DropdownMenuItem(child: Text("ObjectId"), value: TYPE.OBJECT_ID));
    return rs;
  }

  DataRow getDataRow(DropDownButtonData data) {
    List<DataCell> cells = [];
    List<DropdownMenuItem> columnItems =
        _notifier.columns.map((e) => new DropdownMenuItem(child: Text(e.toString()), value: e)).toList();
    DropdownMenuItem<String> customItem = new DropdownMenuItem(
      child: new TextField(
        decoration: InputDecoration(labelText: S.of(context).custom),
        controller: new TextEditingController(text: rowData[data.index].custom ? rowData[data.index].column : ""),
        onChanged: (text) {
          rowData[data.index].column = text;
          rowData[data.index].custom = true;
        },
      ),
      value: "",
    );
    columnItems.add(customItem);
    DropdownButton itemButton = DropdownButton(
      items: columnItems,
      onChanged: (value) {
        setState(() {
          if (value != "") {
            rowData[data.index].custom = false;
            rowData[data.index].column = value;
          }
        });
      },
      value: rowData[data.index].custom ? "" : rowData[data.index].column,
      isExpanded: true,
    );
    DropdownButton opButton = DropdownButton(
      items: getOpMenu(),
      onChanged: (value) {
        setState(() {
          rowData[data.index].op = value;
          if (value == OP.NULL || value == OP.NOT_NULL) {
            rowData[data.index].hiddenValue = true;
          } else {
            rowData[data.index].hiddenValue = false;
          }
        });
      },
      value: rowData[data.index].op,
      isExpanded: true,
    );

    TextField inputField = new TextField(
      onChanged: (text) {
        rowData[data.index].value = text;
      },
    );
    DropdownButton inputTypeButton = DropdownButton(
      items: getTypeMenu(),
      onChanged: (value) {
        setState(() {
          rowData[data.index].type = value;
        });
      },
      value: rowData[data.index].type,
      isExpanded: true,
    );
    DropdownButton joinButton = DropdownButton(
      items: getJoinMenu(),
      onChanged: (value) {
        setState(() {
          rowData[data.index].join = value;
        });
      },
      value: rowData[data.index].join,
      isExpanded: true,
    );
    cells.add(new DataCell(itemButton));
    cells.add(new DataCell(opButton));
    if (rowData[data.index].hiddenValue) {
      cells.add(new DataCell(new Text("")));
    } else {
      cells.add(new DataCell(Expanded(
        child: new Row(
          children: <Widget>[Expanded(child: inputField), Expanded(child: inputTypeButton)],
        ),
      )));
    }
    if (data.index + 1 == rowData.length) {
      cells.add(new DataCell(new Text("")));
    } else {
      cells.add(new DataCell(joinButton));
    }
    DataRow row = new DataRow(cells: cells);
    return row;
  }
}

enum OP { EQ, NOT_EQ, LT, GT, LT_EQ, GT_EQ, NULL, NOT_NULL, INCLUDE, EXCLUDE, BEGIN, END, CONTAIN }

enum TYPE { NUMBER, TEXT, OBJECT_ID }

class DropDownButtonData {
  // whether hide cell
  bool hiddenValue = false;
  int index;
  String column;
  OP op;
  String? value;
  // row connector: AND/OR
  bool join;
  TYPE type = TYPE.TEXT;
  // is custom column
  bool custom = false;

  DropDownButtonData(this.column, this.op, this.index, this.join);
}

abstract class FilterCallBack {
  void execute(List<DropDownButtonData> rowData);
}
