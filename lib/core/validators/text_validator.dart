class TextValidation {
  static String? textValidation(String text) {
    if (text.isEmpty) {
      return "invalid data , please enter the required data";
    } else {
      return null;
    }
  }
}
