import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/config/util.dart';
import 'package:namer_app/model/entity/program/programexercise.dart';
import 'package:namer_app/model/entity/set/set.dart';
import 'package:namer_app/presentation/state/setapi.dart';
import 'package:namer_app/presentation/widget/errorsnackbar.dart';

class AddSetDialog extends ConsumerStatefulWidget {
  final ProgramExercise programExercise;
  final int lastRepetitions;
  final double lastWeight;
  final bool lastDouble;

  AddSetDialog({
    required this.programExercise,
    required this.lastRepetitions,
    required this.lastWeight,
    required this.lastDouble,
    super.key,
  });

  @override
  ConsumerState<AddSetDialog> createState() => _AddSetDialogState();
}

class _AddSetDialogState extends ConsumerState<AddSetDialog> {
  final _formRepetitionsController = TextEditingController();
  final _formWeightController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _isDouble = false;

  @override
  void initState() {
    _formRepetitionsController.text = widget.lastRepetitions.toString();
    _formWeightController.text = widget.lastWeight.toString();
    _isDouble = widget.lastDouble;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void showErrorSnackbar(String message) {
      ScaffoldMessenger.of(context).showSnackBar(getErrorSnackbar(
        Colors.white70,
        message,
      ));
    }

    ref.listen(setApiProvider, (previous, next) {
      next.maybeWhen(
        error: (error, stackTrace) {
          showErrorSnackbar(error.toString());
        },
        data: (data) {
          Navigator.pop(context);
        },
        orElse: () {},
      );
    });

    return SimpleDialog(
      title: Text('Log set'),
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value == null || !value.isInt()) {
                        return 'repetitions must be a whole number';
                      }
                      return null;
                    },
                    controller: _formRepetitionsController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      icon: Icon(Icons.numbers),
                      labelText: 'Repetitions',
                    ),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value == null || !value.isDouble()) {
                        return 'weight must be a number';
                      }
                      return null;
                    },
                    controller: _formWeightController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      icon: Icon(Icons.scale),
                      labelText: 'Weight in kg',
                    ),
                  ),
                  CheckboxListTile(
                      title: Text("Double"),
                      tristate: false,
                      value: _isDouble,
                      onChanged: (value) {
                        setState(() {
                          _isDouble = value!;
                        });
                      }),
                ],
              )),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: ElevatedButton.icon(
            icon: Icon(Icons.done),
            label: Text('Submit'),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final newSet = Set(
                  id: 0,
                  programExerciseId: widget.programExercise.id,
                  isDouble: _isDouble,
                  repetitions: int.parse(_formRepetitionsController.text),
                  weightInKg: double.parse(_formWeightController.text),
                );
                ref
                    .read(setApiProvider.notifier)
                    .addSet(widget.programExercise, newSet);
              }
            },
          ),
        ),
      ],
    );
  }
}
