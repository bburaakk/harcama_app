import 'package:intl/intl.dart';

class CurrencyHelper {
  // Türkçe formatı: 1.234,56
  static final NumberFormat _formatter = NumberFormat.currency(
    locale: 'tr_TR',
    symbol: '',
    decimalDigits: 2,
  );

  static final NumberFormat _noDecimalFormatter = NumberFormat.currency(
    locale: 'tr_TR',
    symbol: '',
    decimalDigits: 0,
  );

  /// Double değeri formatlı stringe çevirir (Örn: 1.234,56)
  static String format(double value) {
    // Eğer sayı tam sayı ise (kuruş yoksa) ,00 göstermeyelim (isteğe bağlı, şimdilik standart tutuyorum)
    // Kullanıcı 99.458,45 istediği için standart formatı kullanıyoruz.
    return _formatter.format(value).trim();
  }

  /// Kuruşsuz format (Örn: 1.234)
  static String formatNoDecimal(double value) {
    return _noDecimalFormatter.format(value).trim();
  }

  /// Giriş ekranında yazarken formatlamak için
  /// "1234.5" -> "1.234,5"
  static String formatInput(String input) {
    if (input.isEmpty) return "0";
    
    // Eğer operatör içeriyorsa (+ - * /) formatlamadan olduğu gibi döndür (karmaşıklığı önlemek için)
    if (input.contains(RegExp(r'[+\-*/]'))) {
      return input.replaceAll('.', ',');
    }

    try {
      // Son karakter nokta ise (virgül olarak gösterilecek)
      bool endsWithDot = input.endsWith('.');
      
      // Ondalık kısım var mı?
      List<String> parts = input.split('.');
      
      String integerPart = parts[0];
      String decimalPart = parts.length > 1 ? parts[1] : "";

      if (integerPart.isEmpty) integerPart = "0";

      // Tam sayı kısmını formatla
      double intValue = double.parse(integerPart);
      String formattedInt = _noDecimalFormatter.format(intValue).trim();

      if (endsWithDot) {
        return "$formattedInt,";
      }

      if (parts.length > 1) {
        return "$formattedInt,$decimalPart";
      }

      return formattedInt;
    } catch (e) {
      return input.replaceAll('.', ',');
    }
  }
}
