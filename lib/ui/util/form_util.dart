import 'package:flutter/material.dart';

class FormFieldDef {
  String fieldName;

  FormFieldDef(this.fieldName);
}

class FormUtil {
  static const String CANCEL = 'cancel';
  static const String CREATE = 'create';

  static ButtonStyleButton createButton3(
      String resourceName,
      List<FormFieldDef> formFieldDefList,
      BuildContext context,
      Function(String, String, String) callback) {
    if (formFieldDefList.length != 3) {
      throw AssertionError('args not match');
    }
    return createButton(resourceName, formFieldDefList, context,
            (list) => callback(list[0], list[1], list[2]));
  }

  static ButtonStyleButton createButton2(
      String resourceName,
      List<FormFieldDef> formFieldDefList,
      BuildContext context,
      Function(String, String) callback) {
    if (formFieldDefList.length != 2) {
      throw AssertionError('args not match');
    }
    return createButton(resourceName, formFieldDefList, context,
        (list) => callback(list[0], list[1]));
  }

  static ButtonStyleButton createButton1(
      String resourceName,
      List<FormFieldDef> formFieldDefList,
      BuildContext context,
      Function(String) callback) {
    if (formFieldDefList.length != 1) {
      throw AssertionError('args not match');
    }
    return createButton(
        resourceName, formFieldDefList, context, (list) => callback(list[0]));
  }

  static ButtonStyleButton createButton(
      String resourceName,
      List<FormFieldDef> formFieldDefList,
      BuildContext context,
      Function(List<String>) callback) {
    return TextButton(
        onPressed: () {
          var editControllerList =
              formFieldDefList.map((e) => TextEditingController()).toList();
          List<TextFormField> formFieldsList = List.generate(
              formFieldDefList.length,
              (index) => TextFormField(
                    decoration: InputDecoration(
                        labelText: formFieldDefList[index].fieldName),
                    controller: editControllerList[index],
                  ));
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  scrollable: true,
                  title: Text(resourceName + ' Form'),
                  content: Form(
                      child: Column(
                    children: formFieldsList,
                  )),
                  actions: [
                    ElevatedButton(
                      child: Text(CREATE),
                      onPressed: () {
                        var list = editControllerList
                            .map((e) => e.value.text)
                            .toList();
                        callback(list);
                        Navigator.of(context).pop();
                      },
                    ),
                    ElevatedButton(
                      child: Text(CANCEL),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              });
        },
        child: Text('Create ' + resourceName));
  }
}
