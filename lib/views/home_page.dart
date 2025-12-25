// Pantalla principal con favorito y top e-bikes

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/stations_vm.dart';
import '../models/station_combined.dart';
import 'station_detail_page.dart';
import 'widgets/top_ebikes_chart.dart';
import 'widgets/compensa_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) { 
      context.read<StationsVm>().loadStations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<StationsVm>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("BiciCoruña - Acceso Rápido"),
        actions: [
          IconButton(
            tooltip: "Recargar datos",
            onPressed: vm.loadStations,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _buildBody(vm),
    );
  }

  Widget _buildBody(StationsVm vm) {
    if (vm.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vm.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text("Error: ${vm.error}", textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: vm.loadStations,
              child: const Text("Reintentar"),
            ),
          ],
        ),
      );
    }

    if (vm.allStations.isEmpty) {
      return const Center(child: Text("No hay estaciones disponibles"));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Estación favorita
          if (vm.favoriteStation != null)
            _FavoriteStationCard(
              station: vm.favoriteStation!,
              onTap: () => _goToDetail(context, vm.favoriteStation!),
            )
          else
            _NoFavoriteCard(
              onSelectFavorite: () => _showStationPicker(context, vm),
            ),
          
          const SizedBox(height: 24),

          //Gráfico Top e-bikes
          const Text(
            "Top 5 estaciones con más e-bikes",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 250,
            child: TopEbikesChart(topStations: vm.getTopByEbikes(5)),
          ),
          
          const SizedBox(height: 24),
          
          Center(
            child: ElevatedButton.icon(
              onPressed: () => _showStationPicker(context, vm),
              icon: const Icon(Icons.list),
              label: const Text("Ver todas las estaciones"),
            ),
          ),
        ],
      ),
    );
  }

  void _goToDetail(BuildContext context, StationCombined station) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StationDetailPage(station: station),
      ),
    );
  }

  void _showStationPicker(BuildContext context, StationsVm vm) {
    showModalBottomSheet(
      context: context,
      builder: (_) => ListView.builder(
        itemCount: vm.allStations.length,
        itemBuilder: (_, i) {
          final station = vm.allStations[i];
          final isFavorite = station.info.stationId == vm.favoriteStationId;
          
          return ListTile(
            leading: Icon(
              isFavorite ? Icons.star : Icons.star_border,
              color: isFavorite ? Colors.amber : null,
            ),
            title: Text(station.info.name),
            subtitle: Text(
              'E-bikes: ${station.electricBikes} | Mecánicas: ${station.mechanicalBikes}',
            ),
            trailing: IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () {
                Navigator.pop(context);
                _goToDetail(context, station);
              },
            ),
            onTap: () async {
              await vm.setFavorite(station.info.stationId);
              if (context.mounted) Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}

//WIDGETS PRIVADOS

class _FavoriteStationCard extends StatelessWidget {
  final StationCombined station;
  final VoidCallback onTap;

  const _FavoriteStationCard({required this.station, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      station.info.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              CompensaIndicator(
                message: station.compensaBajar,
                color: station.compensaColor,
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _InfoChip(
                    icon: Icons.electric_bike,
                    label: 'E-bikes',
                    value: '${station.electricBikes}',
                    color: Colors.green,
                  ),
                  _InfoChip(
                    icon: Icons.pedal_bike,
                    label: 'Mecánicas',
                    value: '${station.mechanicalBikes}',
                    color: Colors.blue,
                  ),
                  _InfoChip(
                    icon: Icons.location_on,
                    label: 'Anclajes',
                    value: '${station.freeDocks}',
                    color: Colors.grey,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NoFavoriteCard extends StatelessWidget {
  final VoidCallback onSelectFavorite;

  const _NoFavoriteCard({required this.onSelectFavorite});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.star_border, size: 48, color: Colors.grey),
            const SizedBox(height: 8),
            const Text(
              'No has marcado ninguna estación favorita',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onSelectFavorite,
              child: const Text('Seleccionar favorita'),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}