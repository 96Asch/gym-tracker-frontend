import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_scroll_shadow/flutter_scroll_shadow.dart';
import 'package:namer_app/model/entity/program/program.dart';
import 'package:namer_app/presentation/state/programapi.dart';
import 'package:namer_app/presentation/page/programexercisepage.dart';
import 'package:namer_app/presentation/state/programexerciseapi.dart';
import 'package:namer_app/presentation/widget/program/programentry.dart';

class ProgramList extends ConsumerWidget {
  final List<Program> programs;

  const ProgramList({required this.programs});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: RefreshIndicator(
        onRefresh: () {
          ref.invalidate(programApiProvider);
          return Future(() => null);
        },
        child: ScrollShadow(
          child: ListView(
            children: programs.map((program) {
              return GestureDetector(
                onTap: () {
                  ref
                      .read(programExerciseApiProvider.notifier)
                      .loadProgramExercises(program.id);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return ProgramExercisePage(
                          program: program,
                        );
                      },
                    ),
                  );
                },
                child: Column(
                  children: [
                    ProgramEntry(program: program),
                    Divider(),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
