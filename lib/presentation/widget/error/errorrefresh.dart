import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ErrorRefresh extends ConsumerWidget {
  final Function() onRefresh;

  const ErrorRefresh({required this.onRefresh});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Could not retrieve programs"),
          ElevatedButton.icon(
              onPressed: () {
                onRefresh();
              },
              icon: Icon(Icons.refresh),
              label: Text("Retry"))
        ],
      ),
    );
  }
}
