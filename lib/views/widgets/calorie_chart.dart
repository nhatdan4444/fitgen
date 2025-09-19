import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '/providers/calorie_provider.dart';
import '/utils/constants.dart';

class CalorieChart extends StatelessWidget {
  final String period;
  final String mealType;

  const CalorieChart({super.key, this.period = 'daily', this.mealType = 'all'});

  @override
  Widget build(BuildContext context) {
    return Consumer<CalorieProvider>(
      builder: (context, provider, child) {
        final chartData = _getChartData(provider);

        return Container(
          height: 300,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawHorizontalLine: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (value) =>
                          FlLine(color: Colors.grey[200]!, strokeWidth: 1),
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 50,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              '${value.toInt()}',
                              style: TextStyle(
                                color: textColor.withOpacity(0.6),
                                fontSize: 12,
                              ),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              _getBottomTitle(value.toInt()),
                              style: TextStyle(
                                color: textColor.withOpacity(0.6),
                                fontSize: 10,
                              ),
                            );
                          },
                        ),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: chartData,
                        isCurved: true,
                        curveSmoothness: 0.3,
                        color: const Color(0xFF509B50),
                        barWidth: 3,
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 4,
                              color: const Color(0xFF509B50),
                              strokeWidth: 2,
                              strokeColor: Colors.white,
                            );
                          },
                        ),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color(0xFF509B50).withOpacity(0.3),
                              const Color(0xFF509B50).withOpacity(0.1),
                              const Color(0xFF509B50).withOpacity(0.05),
                            ],
                          ),
                        ),
                      ),
                      // Goal line
                      if (provider.goal.dailyGoal > 0)
                        LineChartBarData(
                          spots: _getGoalLine(
                            provider.goal.dailyGoal.toDouble(),
                          ),
                          isCurved: false,
                          color: Colors.red.withOpacity(0.8),
                          barWidth: 2,
                          dotData: const FlDotData(show: false),
                          dashArray: [5, 5],
                        ),
                    ],
                    lineTouchData: LineTouchData(
                      touchTooltipData: LineTouchTooltipData(
                        tooltipRoundedRadius: 8,
                        getTooltipItems: (spots) {
                          return spots.map((spot) {
                            return LineTooltipItem(
                              '${spot.y.toInt()} kcal',
                              const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            );
                          }).toList();
                        },
                      ),
                      handleBuiltInTouches: true,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegendItem('Thực tế', const Color(0xFF509B50)),
                  const SizedBox(width: 20),
                  if (provider.goal.dailyGoal > 0)
                    _buildLegendItem('Mục tiêu', Colors.red),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: textColor.withOpacity(0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  List<FlSpot> _getChartData(CalorieProvider provider) {
    // This is sample data - replace with actual data processing
    List<FlSpot> spots = [];

    // Generate sample data based on period
    switch (period) {
      case 'daily':
        // Last 7 days
        for (int i = 0; i < 7; i++) {
          spots.add(
            FlSpot(i.toDouble(), (1800 + (i * 100) + (i * 50)).toDouble()),
          );
        }
        break;
      case 'weekly':
        // Last 4 weeks
        for (int i = 0; i < 4; i++) {
          spots.add(FlSpot(i.toDouble(), (12000 + (i * 500)).toDouble()));
        }
        break;
      case 'monthly':
        // Last 6 months
        for (int i = 0; i < 6; i++) {
          spots.add(FlSpot(i.toDouble(), (50000 + (i * 2000)).toDouble()));
        }
        break;
      case 'yearly':
        // Last 3 years
        for (int i = 0; i < 3; i++) {
          spots.add(FlSpot(i.toDouble(), (600000 + (i * 10000)).toDouble()));
        }
        break;
    }

    return spots;
  }

  List<FlSpot> _getGoalLine(double goal) {
    List<FlSpot> goalSpots = [];
    int pointCount = period == 'daily'
        ? 7
        : period == 'weekly'
        ? 4
        : period == 'monthly'
        ? 6
        : 3;

    for (int i = 0; i < pointCount; i++) {
      double adjustedGoal = goal;
      if (period == 'weekly') adjustedGoal *= 7;
      if (period == 'monthly') adjustedGoal *= 30;
      if (period == 'yearly') adjustedGoal *= 365;

      goalSpots.add(FlSpot(i.toDouble(), adjustedGoal));
    }

    return goalSpots;
  }

  String _getBottomTitle(int index) {
    switch (period) {
      case 'daily':
        final days = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];
        return index < days.length ? days[index] : '';
      case 'weekly':
        return 'T${index + 1}';
      case 'monthly':
        final months = ['T1', 'T2', 'T3', 'T4', 'T5', 'T6'];
        return index < months.length ? months[index] : '';
      case 'yearly':
        return '${2022 + index}';
      default:
        return '$index';
    }
  }
}
