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

  const DynamicFilterTable(this._notifier, this.callBack);

  @override
  State<StatefulWidget> createState() {
    return _DynamicFilterTableState(_notifier, callBack);
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
  final ColumnNotifier _notifier;

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
      DropDownButtonData data = DropDownButtonData(_notifier.columns[0], OP.EQ, rowData.length, true);
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
    var addButton = TextButton(onPressed: () => {addRow()}, child: const Text("+"));
    var deleteButton = TextButton(onPressed: () => {deleteRow()}, child: const Text("-"));
    DataColumn filterColumn = DataColumn(label: filterButton);
    DataColumn addColumn = DataColumn(label: addButton);
    DataColumn deleteColumn = DataColumn(label: deleteButton);
    DataColumn joinColumn = const DataColumn(label: Text(""));

    table = DataTable(
        columns: [filterColumn, addColumn, deleteColumn, joinColumn],
        rows: rowData.map((e) => getDataRow(e)).toList(),
        headingTextStyle: const TextStyle(color: Colors.grey));

    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: <Widget>[Container(child: table!)],
    );
  }

  List<DropdownMenuItem<OP>> getOpMenu() {
    List<DropdownMenuItem<OP>> rs = [];
    rs.add(const DropdownMenuItem(value: OP.EQ, child: Text("=")));
    rs.add(const DropdownMenuItem(value: OP.NOT_EQ, child: Text("!=")));
    rs.add(const DropdownMenuItem(value: OP.LT, child: Text("<")));
    rs.add(const DropdownMenuItem(value: OP.GT, child: Text(">")));
    rs.add(const DropdownMenuItem(value: OP.LT_EQ, child: Text("<=")));
    rs.add(const DropdownMenuItem(value: OP.GT_EQ, child: Text(">=")));
    rs.add(const DropdownMenuItem(value: OP.NULL, child: Text("is null")));
    rs.add(const DropdownMenuItem(value: OP.NOT_NULL, child: Text("is not null")));
    rs.add(const DropdownMenuItem(value: OP.INCLUDE, child: Text("include")));
    rs.add(const DropdownMenuItem(value: OP.EXCLUDE, child: Text("exclude")));
    rs.add(const DropdownMenuItem(value: OP.BEGIN, child: Text("begin with")));
    rs.add(const DropdownMenuItem(value: OP.END, child: Text("end with")));
    rs.add(const DropdownMenuItem(value: OP.CONTAIN, child: Text("contain")));
    return rs;
  }

  List<DropdownMenuItem<bool>> getJoinMenu() {
    List<DropdownMenuItem<bool>> rs = [];
    rs.add(const DropdownMenuItem(value: true, child: Text("AND")));
    rs.add(const DropdownMenuItem(value: false, child: Text("OR")));
    return rs;
  }

  List<DropdownMenuItem<TYPE>> getTypeMenu() {
    List<DropdownMenuItem<TYPE>> rs = [];
    rs.add(const DropdownMenuItem(value: TYPE.TEXT, child: Text("TEXT")));
    rs.add(const DropdownMenuItem(value: TYPE.NUMBER, child: Text("NUMBER")));
    rs.add(const DropdownMenuItem(value: TYPE.OBJECT_ID, child: Text("ObjectId")));
    return rs;
  }

  DataRow getDataRow(DropDownButtonData data) {
    List<DataCell> cells = [];
    List<DropdownMenuItem> columnItems =
        _notifier.columns.map((e) => DropdownMenuItem(value: e, child: Text(e.toString()))).toList();
    DropdownMenuItem<String> customItem = DropdownMenuItem(
      value: "",
      child: TextField(
        decoration: InputDecoration(labelText: S.of(context).custom),
        controller: TextEditingController(text: rowData[data.index].custom ? rowData[data.index].column : ""),
        onChanged: (text) {
          rowData[data.index].column = text;
          rowData[data.index].custom = true;
        },
      ),
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

    TextField inputField = TextField(
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
    cells.add(DataCell(itemButton));
    cells.add(DataCell(opButton));
    if (rowData[data.index].hiddenValue) {
      cells.add(const DataCell(Text("")));
    } else {
      cells.add(DataCell(Expanded(
        child: Row(
          children: <Widget>[Expanded(child: inputField), Expanded(child: inputTypeButton)],
        ),
      )));
    }
    if (data.index + 1 == rowData.length) {
      cells.add(const DataCell(Text("")));
    } else {
      cells.add(DataCell(joinButton));
    }
    DataRow row = DataRow(cells: cells);
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
