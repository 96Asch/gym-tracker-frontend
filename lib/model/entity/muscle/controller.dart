import 'package:namer_app/model/entity/muscle/muscle.dart';

abstract class IMuscleController {
  void onSelected(final Muscle muscle);
  bool isSelected(final Muscle muscle);
}
