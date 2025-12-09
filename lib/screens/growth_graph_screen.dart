import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';

class GrowthGraphScreen extends StatefulWidget {
  const GrowthGraphScreen({super.key});

  @override
  State<GrowthGraphScreen> createState() => _GrowthGraphScreenState();
}

class _GrowthGraphScreenState extends State<GrowthGraphScreen> {
  int _selectedYear = DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HabitProvider>(context);
    final winrates = provider.getYearlyWinrates(_selectedYear);
    final totalCompletions = provider.getTotalCompletions(_selectedYear);
    final overallWR = provider.calculateWinrate(year: _selectedYear, month: 1); // Simplified, average over year

    return Scaffold(
      appBar: AppBar(title: const Text('Growth Graph')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: winrates.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
                      isCurved: true,
                      color: Colors.blue,
                    ),
                  ],
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(sideTitles: _bottomTitles()),
                  ),
                ),
              ),
            ),
            DropdownButton<int>(
              value: _selectedYear,
              items: List.generate(5, (i) => DropdownMenuItem(value: DateTime.now().year - i, child: Text('${DateTime.now().year - i}'))),
              onChanged: (val) => setState(() => _selectedYear = val!),
            ),
            Card(
              child: ListTile(
                title: const Text('Your WR'),
                subtitle: Text('${overallWR.toStringAsFixed(0)}%'),
                trailing: SizedBox(
                  width: 100,
                  height: 100,
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(value: overallWR, color: Colors.orange),
                        PieChartSectionData(value: 100 - overallWR, color: Colors.blue),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('Congratulations'),
                subtitle: Text('You have done Good habits: $totalCompletions times this years'),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              child: const Text('BACK'),
            ),
          ],
        ),
      ),
    );
  }

  SideTitles _bottomTitles() {
    return SideTitles(
      showTitles: true,
      getTitlesWidget: (value, meta) {
        const months = ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'];
        return Text(months[value.toInt()]);
      },
    );
  }
}