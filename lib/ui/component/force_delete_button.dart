import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/generated/l10n.dart';

class ForceDeleteButton extends StatefulWidget {
  final Function(bool) callback;

  ForceDeleteButton(this.callback);

  @override
  State<StatefulWidget> createState() {
    return new __ForceDeleteButtonState(callback);
  }
}

class __ForceDeleteButtonState extends State<ForceDeleteButton> {
  bool forceDelete = false;

  final Function(bool) callback;

  __ForceDeleteButtonState(this.callback);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return StatefulBuilder(builder: (context, setState) {
                  return AlertDialog(
                    title: Text(
                      S.of(context).confirmDeleteQuestion,
                      textAlign: TextAlign.center,
                    ),
                    content: Container(
                      width: 300,
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        children: [
                          SizedBox(
                            width: 10,
                          ), //SizedBox
                          Text(S.of(context).forceDelete), //Text
                          SizedBox(width: 10),
                          Checkbox(
                            value: this.forceDelete,
                            onChanged: (value) {
                              setState(() {
                                if (value == null) {
                                  this.forceDelete = false;
                                } else {
                                  this.forceDelete = value;
                                }
                              });
                            },
                          )
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text(
                          S.of(context).cancel,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text(
                          S.of(context).confirm,
                        ),
                        onPressed: () {
                          callback.call(forceDelete);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                });
              });
        },
        icon: Icon(Icons.delete));
  }
}
