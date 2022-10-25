import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sage/src/Chart%20Models/QuoteChartData.dart';
import 'package:sage/src/Chart%20Models/StockChartData.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:sage/src/Models/product.dart';
import 'package:sage/src/Services/application_service.dart';
import 'package:sage/src/Services/service.dart';
import 'package:sage/src/shared/colors.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key key}) : super(key: key);

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  static List<int> amounts;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Reports'),
        backgroundColor: primaryColor,
      ),
      body: ListView(
        children: [
          Center(
            child: FutureBuilder(
              future: Service.getProducts(),
              builder: (context, AsyncSnapshot<List<Product>> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Text('none');
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                    return Center(
                        child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text('Loading...'),
                    ));
                  case ConnectionState.done:
                    List<StockSeries> data = [];
                    for (Product p in snapshot.data) {
                      StockSeries ss = new StockSeries(
                          prodName: p.name,
                          numStock: p.quantity,
                          barRedColor:
                              charts.ColorUtil.fromDartColor(Colors.redAccent),
                          barYellowColor: charts.ColorUtil.fromDartColor(
                              Colors.yellowAccent),
                          barGreenColor: charts.ColorUtil.fromDartColor(
                              Colors.greenAccent));
                      data.add(ss);
                    }
                    return StockChart(
                      data: data,
                    );
                  default:
                    return Text('default');
                }
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: FutureBuilder(
              future: ApplicationService.getQuantityForQuotePie(),
              builder: (context, AsyncSnapshot<List<int>> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Text('none');
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                    return Center(
                        child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text('Loading...'),
                    ));
                  case ConnectionState.done:
                    List<QuoteSeries> data = [];
                    List<String> cats = [
                      'bags',
                      'laptops',
                      'storage devices',
                      'printer',
                      'other'
                    ];
                    int count = 0;
                    for (int p in snapshot.data) {
                      QuoteSeries qs = new QuoteSeries(
                          category: cats[count],
                          num: p,
                          barColor: charts.ColorUtil.fromDartColor(
                              Colors.lightBlueAccent));
                      data.add(qs);
                      count++;
                    }
                    return QuoteChart(
                      data: data,
                    );
                  default:
                    return Text('default');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class StockChart extends StatelessWidget {
  final List<StockSeries> data;

  StockChart({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<charts.Series<StockSeries, String>> series = [
      charts.Series(
        id: "Amount Stocked",
        data: data,
        domainFn: (StockSeries series, _) => series.prodName,
        measureFn: (StockSeries series, _) => series.numStock,
        colorFn: (StockSeries series, _) {
          if (series.numStock <= 10) {
            return series.barRedColor;
          } else if (series.numStock <= 30) {
            return series.barYellowColor;
          } else {
            return series.barGreenColor;
          }
        },
        labelAccessorFn: (StockSeries stock, _) =>
            '${stock.prodName}: ${stock.numStock.toString()}',
      ),
    ];
    return Container(
      height: 1500,
      width: 1800,
      padding: EdgeInsets.all(15.0),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              Text(
                "STOCK LEVELS",
                style: TextStyle(color: Colors.blueGrey, fontSize: 18),
              ),
              Expanded(
                child: charts.BarChart(
                  series,
                  animate: true,
                  vertical: false,
                  barRendererDecorator: new charts.BarLabelDecorator<String>(),
                  // Hide domain axis.
                  domainAxis: new charts.OrdinalAxisSpec(
                      renderSpec: new charts.NoneRenderSpec()),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class QuoteChart extends StatelessWidget {
  final List<QuoteSeries> data;

  QuoteChart({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<charts.Series<QuoteSeries, String>> series = [
      charts.Series(
          id: "Amount of Quotes",
          data: data,
          domainFn: (QuoteSeries series, _) => series.category.toString(),
          measureFn: (QuoteSeries series, _) => series.num,
          colorFn: (QuoteSeries series, _) => series.barColor,
          labelAccessorFn: (QuoteSeries sales, _) => '${sales.num.toString()}')
    ];
    return Container(
      height: 500,
      width: 1800,
      padding: EdgeInsets.all(15.0),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              Text(
                "QUOTES PER CATEGORY",
                style: TextStyle(color: Colors.blueGrey, fontSize: 18),
              ),
              Expanded(
                child: charts.BarChart(
                  series,
                  animate: true,
                  barRendererDecorator: new charts.BarLabelDecorator<String>(),
                  domainAxis: new charts.OrdinalAxisSpec(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
