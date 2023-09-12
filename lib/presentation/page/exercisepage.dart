import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/model/entity/appmessage.dart';
import 'package:namer_app/presentation/state/enablefab.dart';
import 'package:namer_app/presentation/state/exerciseapi.dart';
import 'package:namer_app/presentation/widget/error/errorrefresh.dart';
import 'package:namer_app/presentation/widget/errorsnackbar.dart';
import 'package:namer_app/presentation/widget/exercise/exerciseform.dart';
import 'package:namer_app/presentation/widget/exercise/exercisegrid.dart';
import 'package:namer_app/presentation/widget/expandingfab/actionbutton.dart';
import 'package:namer_app/presentation/widget/expandingfab/expandingfab.dart';

class ExercisePage extends ConsumerStatefulWidget {
  @override
  ConsumerState<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends ConsumerState<ExercisePage> {
  bool _isMultiSelect = false;
  bool _canEdit = true;

  @override
  Widget build(BuildContext context) {
    var exercises = ref.watch(exerciseApiProvider);

    ref.listen(exerciseApiProvider, (previous, next) {
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

    return Scaffold(
      appBar: _isMultiSelect
          ? AppBar(
              title: Text('Select Multiple'),
            )
          : null,
      body: exercises.when(
        data: (data) => ExerciseGrid(exercises: data),
        error: (error, stackTrace) => ErrorRefresh(
          onRefresh: () {
            ref.invalidate(exerciseApiProvider);
          },
        ),
        loading: () => CircularProgressIndicator(),
      ),
      floatingActionButton: ExpandableFab(
        distance: 100,
        children: [
          ActionButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () {
              _toggleMultiSelect();
            },
          ),
          ActionButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExerciseForm(exercise: null),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  void _toggleMultiSelect() {
    setState(() {
      _isMultiSelect = !_isMultiSelect;
    });
  }
}
