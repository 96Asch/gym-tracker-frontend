import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/presentation/state/exerciseapi.dart';
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

  @override
  Widget build(BuildContext context) {
    var exercises = ref.watch(exerciseApiProvider);

    return Scaffold(
      appBar: _isMultiSelect
          ? AppBar(
              title: Text('Select Multiple'),
            )
          : null,
      body: exercises.when(
        data: (data) => ExerciseGrid(exercises: data),
        error: (error, stackTrace) => Text(error.toString()),
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
    print("build");

    setState(() {
      _isMultiSelect = !_isMultiSelect;
    });
  }
}
