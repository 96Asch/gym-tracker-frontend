import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/model/entity/appmessage.dart';
import 'package:namer_app/presentation/state/programapi.dart';
import 'package:namer_app/presentation/widget/error/errorrefresh.dart';
import 'package:namer_app/presentation/widget/errorsnackbar.dart';
import 'package:namer_app/presentation/widget/expandingfab/actionbutton.dart';
import 'package:namer_app/presentation/widget/expandingfab/expandingfab.dart';
import 'package:namer_app/presentation/widget/program/programform.dart';
import 'package:namer_app/presentation/widget/program/programlist.dart';

class ProgramPage extends ConsumerStatefulWidget {
  const ProgramPage({
    super.key,
  });

  @override
  ConsumerState<ProgramPage> createState() => _ProgramPageState();
}

class _ProgramPageState extends ConsumerState<ProgramPage> {
  bool _canEdit = true;

  @override
  Widget build(BuildContext context) {
    final programs = ref.watch(programApiProvider);

    ref.listen(programApiProvider, (previous, next) {
      next.maybeWhen(
        error: (error, stackTrace) {
          if (error is AppMessage) {
            ScaffoldMessenger.of(context)
                .showSnackBar(getErrorSnackbar(Colors.red, error.message));

            setState(() {
              _canEdit = false;
              print(_canEdit);
            });
          }
        },
        orElse: () {},
      );
    });

    return Center(
      child: Scaffold(
        body: programs.when(
          data: (data) => ProgramList(programs: data),
          error: (error, stackTrace) => ErrorRefresh(onRefresh: () {
            ref.invalidate(programApiProvider);
          }),
          loading: () => CircularProgressIndicator(),
        ),
        floatingActionButton: ExpandableFab(
          enabled: _canEdit,
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
