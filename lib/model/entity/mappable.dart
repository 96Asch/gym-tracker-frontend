// Interface for http query parameters or body
abstract class Mappable {
  //Returns the props of the class as a Map<string, dynamic>.
  Map<String, dynamic> toMap();
}
