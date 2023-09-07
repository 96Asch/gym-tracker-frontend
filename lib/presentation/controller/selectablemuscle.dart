import 'package:namer_app/model/entity/muscle/controller.dart';
import 'package:namer_app/model/entity/muscle/muscle.dart';

class SelectableMuscleController implements IMuscleController {
  final Set<Muscle> _muscles = {};

  SelectableMuscleController(List<Muscle> initialMuscles) {
    _muscles.addAll(initialMuscles);
  }

  void setMuscles(List<Muscle> muscles) {
    _muscles.clear();
    _muscles.addAll(muscles);
  }

  List<Muscle> get muscles {
    return _muscles.toList();
  }

  @override
  bool isSelected(Muscle muscle) {
    return _muscles.contains(muscle);
  }

  @override
  void onSelected(Muscle muscle) {
    _muscles.add(muscle);
  }
}
