import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/config/util.dart';
import 'package:namer_app/model/entity/appmessage.dart';
import 'package:namer_app/model/entity/program/programsort.dart';
import 'package:namer_app/presentation/state/enablefab.dart';
import 'package:namer_app/presentation/state/programapi.dart';
import 'package:namer_app/presentation/state/programfilter.dart';
import 'package:namer_app/presentation/widget/error/errorrefresh.dart';
import 'package:namer_app/presentation/widget/errorsnackbar.dart';
import 'package:namer_app/presentation/widget/expandingfab/actionbutton.dart';
import 'package:namer_app/presentation/widget/expandingfab/expandingfab.dart';
import 'package:namer_app/presentation/widget/program/programform.dart';
import 'package:namer_app/presentation/widget/program/programlist.dart';
import 'package:namer_app/presentation/widget/program/programsort.dart';

class ProgramPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programs = ref.watch(programApiProvider);
    final programFilter = ref.watch(programFilterProvider);

    print('rebuild');

    ref.listen(programApiProvider, (previous, next) {
      next.maybeWhen(
        error: (error, stackTrace) {
          if (error is AppMessage) {
            ScaffoldMessenger.of(context)
                .showSnackBar(getErrorSnackbar(Colors.red, error.message));
            ref.read(enableFabProvider.notifier).update((state) => false);
          }
        },
        data: (data) =>
            ref.read(enableFabProvider.notifier).update((state) => true),
        orElse: () {},
      );
    });

    return Center(
      child: Scaffold(
        body: programs.when(
          data: (data) => ProgramList(programs: programFilter.filter(data)),
          error: (error, stackTrace) => ErrorRefresh(onRefresh: () {
            ref.invalidate(programApiProvider);
          }),
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
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    context: context,
                    builder: (context) {
                      return SortPrograms(
                        initialSort: programFilter.sortBy,
                        initialStatus: programFilter.status,
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
