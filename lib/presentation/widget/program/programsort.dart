import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:namer_app/config/util.dart';
import 'package:namer_app/model/entity/program/programfilter.dart';
import 'package:namer_app/model/entity/program/programsort.dart';
import 'package:namer_app/presentation/state/programfilter.dart';

class SortPrograms extends ConsumerStatefulWidget {
  final ProgramSortType initialSort;
  final ProgramStatus initialStatus;

  const SortPrograms({
    required this.initialSort,
    required this.initialStatus,
    super.key,
  });

  @override
  ConsumerState<SortPrograms> createState() => _SortProgramsState();
}

class _SortProgramsState extends ConsumerState<SortPrograms> {
  late ProgramStatus _status;
  late ProgramSortType _sortType;

  @override
  void initState() {
    _status = widget.initialStatus;
    _sortType = widget.initialSort;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _status = ProgramStatus.all;
                      _sortType = ProgramSortType.none;
                    });
                  },
                  child: Text("Reset"),
                ),
                Text("Filter"),
                ElevatedButton.icon(
                  onPressed: () {
                    ref.read(programFilterProvider.notifier).state =
                        ProgramFilter(
                      sortBy: _sortType,
                      status: _status,
                    );
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.done),
                  label: Text("Apply"),
                ),
              ],
            ),
          ),
          Divider(
            indent: 20,
            endIndent: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Filter By:"),
                DropdownButton(
                  value: _status,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  icon: Icon(Icons.filter_alt),
                  items: ProgramStatus.values
                      .map((e) => DropdownMenuItem(
                          value: e, child: Text(e.name.capitalize())))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _status = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Sort By:"),
                DropdownButton(
                  iconSize: 30,
                  alignment: AlignmentDirectional.topStart,
                  borderRadius: BorderRadius.circular(10),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  icon: Icon(Icons.sort_rounded),
                  items: ProgramSortType.values
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.name.capitalize()),
                        ),
                      )
                      .toList(),
                  value: _sortType,
                  onChanged: (value) {
                    setState(() {
                      _sortType = value!;
                    });
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {}
