// handel password validation

class PasswordValidator {
  static String? passwordChecker(String keyWord) {
    List<String> specialCharacters = ["%", "\$", "@", "!", "&", "*", "?", "#"];

    if (keyWord.isEmpty) {
      return "Required field, please enter your password";
    }

    if (keyWord.length < 6) {
      return "Password must be at least 6 characters long";
    }

    if (!keyWord.contains(RegExp(r'[A-Z]'))) {
      return "Password must contain at least one UpperCase letter";
    }

    if (!keyWord.contains(RegExp(r'[a-z]'))) {
      return "Password must contain at least one lowercase letter";
    }

    if (!keyWord.contains(RegExp(r'[0-9]'))) {
      return "Password must contain at least one number";
    }

    //if there a special char it will return true (!true = false) so will not go throw the condition
    if (!keyWord
        .split('')
        .any((element) => specialCharacters.contains(element))) {
      return "Password must contain at least one special character(@!%*?&\$)";
    }

    return null;
  }
}
