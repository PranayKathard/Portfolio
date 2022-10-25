import 'package:charts_flutter/flutter.dart' as charts;

class StockSeries {
  final String prodName;
  final int numStock;
  final charts.Color barGreenColor;
  final charts.Color barRedColor;
  final charts.Color barYellowColor;

  StockSeries(
      {this.prodName,
      this.numStock,
      this.barRedColor,
      this.barGreenColor,
      this.barYellowColor});
}
