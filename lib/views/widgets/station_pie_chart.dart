class StationPieChart extends StatelessWidget {
  final StationCombined station;

  const StationPieChart({super.key, required this.station});

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sections: [
          //Sección verde: E-bikes
          PieChartSectionData(
            value: station.electricBikes.toDouble(),
            title: 'E-bikes\n${station.electricBikes}',
            color: Colors.green,
            radius: 60,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          
          //Sección azul: Mecánicas
          PieChartSectionData(
            value: station.mechanicalBikes.toDouble(),
            title: 'Mecánicas\n${station.mechanicalBikes}',
            color: Colors.blue,
            radius: 60,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          
          //Sección gris: Anclajes libres
          PieChartSectionData(
            value: station.freeDocks.toDouble(),
            title: 'Anclajes\n${station.freeDocks}',
            color: Colors.grey,
            radius: 60,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
        
        //Espacio entre secciones
        sectionsSpace: 2,
        
        //Radio del agujero central (para efecto donut)
        centerSpaceRadius: 40,
      ),
    );
  }
}
