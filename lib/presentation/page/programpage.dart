import 'package:flutter/material.dart';
import 'package:namer_app/presentation/widget/expandingfab/actionbutton.dart';
import 'package:namer_app/presentation/widget/expandingfab/expandingfab.dart';
import 'package:namer_app/presentation/widget/program/programform.dart';
import 'package:namer_app/presentation/widget/program/programlist.dart';

class ProgramPage extends StatelessWidget {
  const ProgramPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      // child: Column(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [Expanded(child: Text("LogPage2"))],
      // ),
      child: Scaffold(
        body: Center(
          child: ProgramList(),
        ),
        floatingActionButton: ExpandableFab(
          distance: 100,
          children: [
            ActionButton(
              icon: Icon(Icons.delete_forever),
            ),
            ActionButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProgramForm(program: null),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {}
