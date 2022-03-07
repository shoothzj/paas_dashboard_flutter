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

import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';

class CsvUtils {
  static Future<bool> export(List<String> header, List<List<dynamic>> data) async {
    try {
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Please select an output file:',
        fileName: 'dashboard-output-file',
        allowedExtensions: ['csv'],
        type: FileType.custom,
      );

      if (outputFile != null) {
        File file = File(outputFile + ".csv");
        List<List<dynamic>> rows = [];
        rows.add(header);
        rows.addAll(data);
        String csv = const ListToCsvConverter().convert(rows);
        file.writeAsString(csv);
        return true;
      }
    } on Exception catch (e) {
      throw Exception('Error to export ' + e.toString());
    }
    return false;
  }

  /// import a csv file
  ///
  /// The imported format refers to the exported CSV file format from method see CsvUtils.export [export]
  /// requiring a description of the first behavior parameter, and the second and subsequent columns begins with the data
  static Future<List<List<dynamic>>> import() async {
    try {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['csv'], allowMultiple: false);
      if (result != null) {
        File file = new File(result.files[0].path!);
        List<List<dynamic>> resultList =
            await file.openRead().transform(utf8.decoder).transform(new CsvToListConverter()).toList();

        return resultList;
      }
    } on Exception catch (e) {
      throw Exception('Error to import ${e.toString()}');
    }
    return List.empty();
  }
}
