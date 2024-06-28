import 'package:charts_flutter/flutter.dart' as charts;

class QuoteSeries {
  final String category;
  final int num;
  final charts.Color barColor;

  QuoteSeries({required this.category, required this.num, required this.barColor});
}
