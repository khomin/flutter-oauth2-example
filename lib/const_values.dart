class ConstValues {
  static final ConstValues _instance = ConstValues._internal();

  static const double logoSize = 200;
  static const double lineHeight = 50;
  static const double inputMaxWidth = 400;

  factory ConstValues() {
    return _instance;
  }

  ConstValues._internal();
}
