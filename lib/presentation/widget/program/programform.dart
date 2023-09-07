import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:namer_app/model/entity/program/program.dart';
import 'package:namer_app/presentation/state/exerciseapi.dart';
import 'package:namer_app/presentation/state/programapi.dart';
import 'package:namer_app/presentation/state/selectableexercise.dart';
import 'package:namer_app/presentation/widget/exercise/exercisegrid.dart';
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
    final selectedExercises = ref.watch(selectableExerciseProvider);
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    final formTextStyle = TextStyle();
    final exercises = ref.watch(exerciseApiProvider);

    ref.listen(programApiProvider, (previous, next) {
      next.when(
        data: (data) {},
        error: (error, stackTrace) {},
        loading: () {},
      );
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("Create a new program"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.perm_identity),
                    labelText: "Enter Program name",
                  ),
                  controller: _formNameTextController,
                ),
                SizedBox(height: 20),
                TextFormField(
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
                    data: (data) => ExerciseGrid(exercises: data),
                    error: (error, stackTrace) => Text(error.toString()),
                    loading: () => CircularProgressIndicator(),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton.icon(
                  icon: Icon(Icons.check),
                  onPressed: () {},
                  label: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
