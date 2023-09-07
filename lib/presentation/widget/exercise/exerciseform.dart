import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/config/config.dart';
import 'package:namer_app/model/entity/exercise/exercise.dart';
import 'package:namer_app/presentation/state/exerciseapi.dart';
import 'package:namer_app/presentation/state/muscleapi.dart';
import 'package:namer_app/presentation/state/selectablemuscle.dart';
import 'package:namer_app/presentation/widget/errorsnackbar.dart';
import 'package:namer_app/presentation/widget/muscle/selectablemusclegridview.dart';

class ExerciseForm extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final _formNameTextController = TextEditingController();
  final Exercise? exercise;

  ExerciseForm({required this.exercise}) {
    _formNameTextController.text = exercise?.name ?? '';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final muscles = ref.watch(muscleApiProvider);
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    final formTextStyle = TextStyle();

    void showErrorSnackbar(String message) {
      ScaffoldMessenger.of(context).showSnackBar(getErrorSnackbar(
        Colors.white70,
        message,
      ));
    }

    ref.listen(exerciseApiProvider, (previous, next) {
      next.when(
          data: (data) {
            print("Complete");
            showErrorSnackbar("Complete");
            Navigator.pop(context);
          },
          error: (error, stackTrace) {
            showErrorSnackbar(error.toString());
          },
          loading: () {});
    });

    return Scaffold(
      appBar: AppBar(title: Text('Create New Exercise')),
      body: SafeArea(
        top: true,
        bottom: true,
        left: false,
        right: false,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.perm_identity),
                    SizedBox(width: 10),
                    Text("Name", style: formTextStyle),
                  ],
                ),
                TextFormField(
                  controller: _formNameTextController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'name cannot be empty';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Icon(Icons.checklist_outlined),
                    SizedBox(width: 10),
                    Text("Select Muscles", style: formTextStyle),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: muscles.when(
                    data: (data) => SelectableMuscleGridView(
                      muscles: data,
                      numTilesPerRow: shortestSide < Config.phoneSize ? 4 : 6,
                    ),
                    error: (error, stacktrace) => Column(children: [
                      Text('could not retrieve muscles'),
                      ElevatedButton.icon(
                        icon: Icon(Icons.refresh),
                        onPressed: () => ref.refresh(muscleApiProvider),
                        label: Text("Refresh"),
                      )
                    ]),
                    loading: () => Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.done),
                    label: Text('Submit'),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final exercise = Exercise(
                          id: 0,
                          name: _formNameTextController.text,
                          muscles: ref.read(selectableMuscleProvider),
                        );

                        ref
                            .read(exerciseApiProvider.notifier)
                            .addExercise(exercise);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
