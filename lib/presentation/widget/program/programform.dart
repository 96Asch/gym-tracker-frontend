import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:namer_app/model/entity/exercise/exercise.dart';
import 'package:namer_app/model/entity/program/program.dart';
import 'package:namer_app/model/entity/program/programexercise.dart';
import 'package:namer_app/presentation/state/exerciseapi.dart';
import 'package:namer_app/presentation/state/programapi.dart';
import 'package:namer_app/presentation/state/programexerciseapi.dart';
import 'package:namer_app/presentation/state/selectableexercise.dart';
import 'package:namer_app/presentation/widget/errorsnackbar.dart';
import 'package:namer_app/presentation/widget/exercise/selectableexercisegrid.dart';
import 'package:namer_app/presentation/widget/shared/formlabel.dart';

class ProgramForm extends ConsumerWidget {
  final _formKey = GlobalKey<FormState>();
  final _formNameTextController = TextEditingController();
  final _formDateTextController = TextEditingController();
  final Program? program;

  ProgramForm({required this.program}) {
    _formNameTextController.text = program?.name ?? '';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formTextStyle = TextStyle();
    final exercises = ref.watch(exerciseApiProvider);

    void showErrorSnackbar(String message) {
      ScaffoldMessenger.of(context).showSnackBar(getErrorSnackbar(
        Colors.white70,
        message,
      ));
    }

    ref.listen(programApiProvider, (previous, next) {
      next.when(
          data: (data) {},
          error: (error, stackTrace) {
            showErrorSnackbar(error.toString());
          },
          loading: () {});
    });

    ref.listen(programExerciseApiProvider, (previous, next) {
      next.when(
          data: (data) {
            showErrorSnackbar("Succesfully added a new program!");
            Navigator.pop(context);
          },
          error: (error, stackTrace) {
            showErrorSnackbar(error.toString());
          },
          loading: () {});
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("Create a new program"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name cannot be empty';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    icon: Icon(Icons.list),
                    labelText: "Enter program name",
                  ),
                  controller: _formNameTextController,
                ),
                SizedBox(height: 20),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Date is required';
                    }
                    return null;
                  },
                  controller: _formDateTextController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.calendar_today),
                    labelText: "Enter Date",
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now()
                            .add(Duration(days: 1)), //get today's date
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101));

                    if (pickedDate != null) {
                      print(pickedDate);
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                      _formDateTextController.text = formattedDate;
                    }
                  },
                ),
                SizedBox(height: 20),
                FormLabel(
                  style: formTextStyle,
                  text: "Select Exercises in order",
                  icon: Icons.checklist,
                ),
                Expanded(
                  child: exercises.when(
                    data: (data) => SelectableExerciseGrid(exercises: data),
                    error: (error, stackTrace) => Text(error.toString()),
                    loading: () => CircularProgressIndicator(),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton.icon(
                  icon: Icon(Icons.check),
                  onPressed: () => onSubmitProgram(ref),
                  label: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onSubmitProgram(WidgetRef ref) {
    if (_formKey.currentState!.validate()) {
      final List<Exercise> selected = ref.read(selectableExerciseProvider);
      final programExercises = selected
          .map(
            (e) => ProgramExercise(
              id: 0,
              programId: 0,
              order: 100 * (selected.indexOf(e) + 1),
              exercise: e,
              sets: [],
            ),
          )
          .toList();

      final program = Program(
        id: 0,
        name: _formNameTextController.text,
        endDate: DateTime.parse(_formDateTextController.text),
        exercises: programExercises,
      );

      ref
          .read(programApiProvider.notifier)
          .addProgram(program, programExercises);
    }
  }
}
