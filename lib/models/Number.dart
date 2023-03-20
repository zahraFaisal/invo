class Number {
  static String symbol = "BD";
  static int afterDecimal = 3;

  String formatNumber(double value) {
    return value.toStringAsFixed(afterDecimal);
  }

  static String formatCurrency(double value) {
    return symbol + " " + value.toStringAsFixed(afterDecimal);
  }

  static double getDouble(double value) {
    if (value == null) value = 0;
    return double.parse(value.toStringAsFixed(afterDecimal));
  }

  static String getNumber(double value) {
    if (value == null) value = 0;
    return value.toStringAsFixed(afterDecimal);
  }

  static double rounding(
      double number, double smallestCurrency, int roundType) {
    if (smallestCurrency > 0) {
      number = getDouble(number);
      switch (roundType) {
        case 1: // negative
          int x = int.parse((double.parse(number.toString()) /
                  double.parse(smallestCurrency.toString()))
              .toString());
          return x * smallestCurrency;
        case 2: // postive
          return (number / smallestCurrency).ceil() * smallestCurrency;
        default: // normal
          return (number / smallestCurrency).round() * smallestCurrency;
      }
    }
    return number;
  }
}
