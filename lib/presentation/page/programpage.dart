import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/presentation/state/programapi.dart';
import 'package:namer_app/presentation/widget/expandingfab/actionbutton.dart';
import 'package:namer_app/presentation/widget/expandingfab/expandingfab.dart';
import 'package:namer_app/presentation/widget/program/programform.dart';
import 'package:namer_app/presentation/widget/program/programlist.dart';

class ProgramPage extends ConsumerWidget {
  const ProgramPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programs = ref.watch(programApiProvider);

    return Center(
      child: Scaffold(
        body: programs.when(
          data: (data) => ProgramList(programs: data),
          error: (error, stackTrace) => Text(error.toString()),
          loading: () => CircularProgressIndicator(),
        ),
        floatingActionButton: ExpandableFab(
          distance: 100,
          children: [
            ActionButton(
              icon: Icon(Icons.delete_forever),
            ),
            ActionButton(
              icon: Icon(Icons.sort),
              onPressed: () {
                showModalBottomSheet(
                    showDragHandle: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    context: context,
                    builder: (context) {
                      return SizedBox(
                        height: 300,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('Sort'),
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.done),
                              label: Text("Apply"),
                            )
                          ],
                        ),
                      );
                    });
              },
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
