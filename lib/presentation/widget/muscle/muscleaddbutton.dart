import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/presentation/state/muscleapi.dart';
import 'package:namer_app/presentation/widget/expandingfab/actionbutton.dart';

class MuscleAddButton extends ConsumerWidget {
  const MuscleAddButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();

    return ActionButton(
      icon: Icon(Icons.add),
      onPressed: () => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Add a new muscle'),
          content: TextField(
            controller: controller,
            maxLines: 1,
            onSubmitted: (value) {
              ref.read(muscleApiProvider.notifier).addMuscle(value);
              Navigator.pop(context);
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                ref.read(muscleApiProvider.notifier).addMuscle(controller.text);
                Navigator.pop(context);
              },
              child: Text("Submit"),
            )
          ],
        ),
      ),
    );
  }
}
