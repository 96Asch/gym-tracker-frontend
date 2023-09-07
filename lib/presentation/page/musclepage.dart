import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/config/calcgriditems.dart';
import 'package:namer_app/config/config.dart';
import 'package:namer_app/model/entity/muscle/controller.dart';
import 'package:namer_app/model/entity/muscle/muscle.dart';
import 'package:namer_app/presentation/state/muscleapi.dart';
import 'package:namer_app/presentation/widget/expandingfab/actionbutton.dart';
import 'package:namer_app/presentation/widget/expandingfab/expandingfab.dart';
import 'package:namer_app/presentation/widget/muscle/muscleaddbutton.dart';
import 'package:namer_app/presentation/widget/muscle/musclegridview.dart';

class MusclePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var muscles = ref.watch(muscleApiProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Muscles'),
      ),
      body: muscles.when(
        skipError: true,
        data: (data) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: MuscleGridView(
            muscles: data,
            numTilesPerRow: getNumGridItems(context),
          ),
        ),
        error: (error, stackTrace) => Placeholder(),
        loading: () => Center(
          child: CircularProgressIndicator(),
        ),
      ),
      floatingActionButton: ExpandableFab(
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
