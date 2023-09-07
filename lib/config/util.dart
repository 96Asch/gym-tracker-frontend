extension StringExtension on String {
  String capitalize() {
    final split = this.split(' ');
    final capitalized = split.map((e) {
      if (e.length > 2) {
        return e[0].toUpperCase() + e.substring(1);
      }
      return e.toUpperCase();
    });

    return capitalized.join((' '));
  }
}
