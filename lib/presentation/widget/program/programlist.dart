import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_scroll_shadow/flutter_scroll_shadow.dart';
import 'package:namer_app/presentation/state/programapi.dart';

class ProgramList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programs = ref.watch(programApiProvider);

    return programs.when(
        data: (data) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: ScrollShadow(
                child: ListView(
                  children: data.map((program) {
                    return ListTile(
                      title: Text(program.name),
                      leading: Icon(Icons.abc),
                    );
                  }).toList(),
                ),
              ),
            ),
        error: (error, stackTrace) => Text(error.toString()),
        loading: () => CircularProgressIndicator());
  }
}
