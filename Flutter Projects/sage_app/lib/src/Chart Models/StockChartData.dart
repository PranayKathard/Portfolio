import 'package:charts_flutter/flutter.dart' as charts;

class StockSeries {
  final String prodName;
  final int numStock;
  final charts.Color barGreenColor;
  final charts.Color barRedColor;
  final charts.Color barYellowColor;

  StockSeries(
      {required this.prodName,
      required this.numStock,
      required this.barRedColor,
      required this.barGreenColor,
      required this.barYellowColor});
}
