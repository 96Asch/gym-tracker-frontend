import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/config/config.dart';
import 'package:namer_app/config/util.dart';
import 'package:namer_app/presentation/state/exerciseapi.dart';

class ExerciseGrid extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    var exercises = ref.watch(exerciseApiProvider);
    var colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: exercises.when(
          data: ((data) => GridView.count(
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                crossAxisCount: shortestSide < Config.phoneSize ? 2 : 4,
                children: data
                    .map((e) => Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withAlpha(150),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: GridTile(
                            header: ColoredBox(
                              color: colorScheme.primary,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  e.name.toUpperCase(),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            footer: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(e.muscles
                                  .map((e) => e.name.capitalize())
                                  .join(', ')),
                            ),
                            child: Icon(Icons.ac_unit_outlined),
                          ),
                        ))
                    .toList(),
              )),
          error: (error, stackTrace) => Text(error.toString()),
          loading: () => Center(
                child: LinearProgressIndicator(),
              )),
    );
  }
}
