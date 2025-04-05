class Validators {
  // التحقق من البريد الإلكتروني
  static bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  // التحقق من المبلغ
  static bool isValidAmount(String amount) {
    try {
      double value = double.parse(amount);
      return value > 0;
    } catch (e) {
      return false;
    }
  }

  // التحقق من كلمة المرور
  static bool isValidPassword(String password) {
    return password.length >= 6; // يمكنك تحسين القاعدة بإضافة متطلبات أخرى مثل الأرقام والرموز
  }
}
