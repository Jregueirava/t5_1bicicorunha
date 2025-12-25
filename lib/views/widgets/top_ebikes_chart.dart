import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../models/station_combined.dart';

//Gráfico A: Top estaciones por e-bikes (Barras horizontales)
class TopEbikesChart extends StatelessWidget {
  final List<StationCombined> topStations;

  const TopEbikesChart({super.key, required this.topStations});

  @override
  Widget build(BuildContext context) {
    if (topStations.isEmpty) {
      return const Center(child: Text('No hay datos'));
    }

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: topStations.first.electricBikes.toDouble() + 2,
        barGroups: topStations.asMap().entries.map((entry) {
          final idx = entry.key;
          final station = entry.value;
          return BarChartGroupData(
            x: idx,
            barRods: [
              BarChartRodData(
                toY: station.electricBikes.toDouble(),
                color: Colors.green,
                width: 20,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          );
        }).toList(),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 40),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx < 0 || idx >= topStations.length) return const Text('');
                //Mostrar nombre corto
                final name = topStations[idx].info.name;
                final short = name.length > 10
                    ? '${name.substring(0, 10)}...'
                    : name;
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    short,
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
      ),
    );
  }
}