import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/generated/l10n.dart';

class ClearBacklogButton extends StatelessWidget {
  final VoidCallback voidCallback;

  ClearBacklogButton(this.voidCallback);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(
                    S.of(context).confirmClearBacklog,
                    textAlign: TextAlign.center,
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
                        voidCallback.call();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              });
        },
        icon: Icon(Icons.delete));
  }
}
