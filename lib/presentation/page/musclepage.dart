import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/config/calcgriditems.dart';
import 'package:namer_app/model/entity/appmessage.dart';
import 'package:namer_app/presentation/state/muscleapi.dart';
import 'package:namer_app/presentation/widget/error/errorrefresh.dart';
import 'package:namer_app/presentation/widget/errorsnackbar.dart';
import 'package:namer_app/presentation/widget/expandingfab/actionbutton.dart';
import 'package:namer_app/presentation/widget/expandingfab/expandingfab.dart';
import 'package:namer_app/presentation/widget/muscle/muscleaddbutton.dart';
import 'package:namer_app/presentation/widget/muscle/musclegridview.dart';

class MusclePage extends ConsumerStatefulWidget {
  @override
  ConsumerState<MusclePage> createState() => _MusclePageState();
}

class _MusclePageState extends ConsumerState<MusclePage> {
  bool _canEdit = true;

  @override
  Widget build(BuildContext context) {
    var muscles = ref.watch(muscleApiProvider);

    ref.listen(muscleApiProvider, (previous, next) {
      next.maybeWhen(
        error: (error, stackTrace) {
          if (error is AppMessage) {
            ScaffoldMessenger.of(context)
                .showSnackBar(getErrorSnackbar(Colors.red, error.message));
            setState(() {
              _canEdit = false;
            });
          }
        },
        orElse: () {},
      );
    });

    return Scaffold(
      body: muscles.when(
        skipError: true,
        data: (data) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: MuscleGridView(
            muscles: data,
            numTilesPerRow: getNumGridItems(context),
          ),
        ),
        error: (error, stackTrace) => ErrorRefresh(
          onRefresh: () {
            ref.invalidate(muscleApiProvider);
          },
        ),
        loading: () => Center(
          child: CircularProgressIndicator(),
        ),
      ),
      floatingActionButton: ExpandableFab(
        enabled: _canEdit,
        distance: 100,
        children: [
          ActionButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () {},
          ),
          MuscleAddButton(),
        ],
      ),
    );
  }
}
