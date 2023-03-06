import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:fl_chart/fl_chart.dart';
import 'datum.dart';
import 'data_loader.dart';

class StockChartExample extends StatefulWidget {
  const StockChartExample({super.key});

  @override
  _StockChartExampleState createState() => _StockChartExampleState();
}

class _StockChartExampleState extends State<StockChartExample> {
  final List<Color> _gradientColors = [
    const Color(0xFF03A9F4),
    const Color(0xFF03A9F4),
    const Color(0xFF03A9F4),
  ];
  final int _divider = 25;
  final int _leftLabelsCount = 6;

  List<FlSpot> _values = const [];

  double _minX = 0;
  double _maxX = 0;
  double _minY = 0;
  double _maxY = 0;
  double _leftTitlesInterval = 0;

  @override
  void initState() {
    super.initState();
    _prepareStockData();
  }

  void _prepareStockData() async {
    final List<Datum> data = await loadStockData();
    print(loadStockData());
    double minY = double.maxFinite;
    double maxY = double.minPositive;

    _values = data.map((datum) {
      if (minY > datum.close) minY = datum.close;
      if (maxY < datum.close) maxY = datum.close;
      return FlSpot(
        datum.date.millisecondsSinceEpoch.toDouble(),
        datum.close,
      );
    }).toList();

    _minX = _values.first.x;
    _maxX = _values.last.x;
    _minY = (minY / _divider).floorToDouble() * _divider;
    _maxY = (maxY / _divider).ceilToDouble() * _divider;
    _leftTitlesInterval =
        ((_maxY - _minY) / (_leftLabelsCount - 1)).floorToDouble();

    setState(() {});
  }

  LineChartData _mainData() {
    return LineChartData(
      gridData: _gridData(),
      titlesData: FlTitlesData(
        bottomTitles: _bottomTitles(),
        leftTitles: _leftTitles(),
      ),
      borderData: FlBorderData(
        border: Border.all(color: Colors.black, width: 1),
      ),
      minX: _minX,
      maxX: _maxX,
      minY: _minY,
      maxY: _maxY,
      lineBarsData: [_lineBarData()],
    );
  }

  LineChartBarData _lineBarData() {
    return LineChartBarData(
      spots: _values,
      colors: _gradientColors,
      colorStops: const [0.25, 0.5, 0.75],
      gradientFrom: const Offset(0.5, 0),
      gradientTo: const Offset(0.5, 1),
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(
        show: true,
        colors: _gradientColors.map((color) => color.withOpacity(0.3)).toList(),
        gradientColorStops: const [0.25, 0.5, 0.75],
        gradientFrom: const Offset(0.5, 0),
        gradientTo: const Offset(0.5, 1),
      ),
    );
  }

  SideTitles _leftTitles() {
    return SideTitles(
      showTitles: true,
      textStyle: TextStyle(
        color: Colors.black,
        fontSize: 14,
      ),
      getTitles: (value) =>
          NumberFormat.compactCurrency(symbol: '\C').format(value),
      reservedSize: 28,
      margin: 12,
      interval: _leftTitlesInterval,
    );
  }

  SideTitles _bottomTitles() {
    return SideTitles(
      showTitles: true,
      textStyle: const TextStyle(
        color: Colors.black,
        fontSize: 14,
      ),
      getTitles: (value) {
        final DateTime date =
        DateTime.fromMillisecondsSinceEpoch(value.toInt());
        return DateFormat.MMM().format(date);
      },
      margin: 8,
      interval: (_maxX - _minX) / 6,
    );
  }

  FlGridData _gridData() {
    return FlGridData(
      show: true,
      drawVerticalLine: false,
      getDrawingHorizontalLine: (value) {
        return const FlLine(
          color: Colors.white12,
          strokeWidth: 1,
        );
      },
      checkToShowHorizontalLine: (value) {
        return (value - _minY) % _leftTitlesInterval == 0;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding:
        const EdgeInsets.only(right: 10.0, left: 6.0, top: 10, bottom: 6),
        child: _values.isEmpty ? Placeholder() : LineChart(_mainData()),
      ),
    );
  }
}