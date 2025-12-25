import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import '../models/station_combined.dart';
import 'views/widgets/station_pie_chart.dart';
import 'views/widgets/compensa_indicator.dart';


class StationDetailPage extends StatelessWidget {
  final StationCombined station;

  const StationDetailPage({super.key, required this.station});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm:ss');
    final lastUpdated = dateFormat.format(station.status.lastReported);

    return Scaffold(
      appBar: AppBar(
        title: Text(station.info.name),
        actions: [
          IconButton(
            tooltip: 'Exportar PDF',
            onPressed: () => _exportPdf(context),
            icon: const Icon(Icons.picture_as_pdf),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Información básica
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      station.info.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Capacidad: ${station.info.capacity} anclajes'),
                    Text('Coordenadas: ${station.info.lat.toStringAsFixed(4)}, ${station.info.lon.toStringAsFixed(4)}'),
                    const SizedBox(height: 8),
                    Text(
                      'Actualizado: $lastUpdated',
                      style: const TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ¿Me compensa bajar?
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '¿Me compensa bajar ahora?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    CompensaIndicator(
                      message: station.compensaBajar,
                      color: station.compensaColor,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Gráfico B: Estado actual (Pie)
            const Text(
              'Distribución actual',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: StationPieChart(station: station),
            ),

            const SizedBox(height: 16),

            // Estadísticas numéricas
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _StatRow(
                      label: 'E-bikes disponibles',
                      value: '${station.electricBikes}',
                      color: Colors.green,
                    ),
                    const Divider(),
                    _StatRow(
                      label: 'Bicis mecánicas disponibles',
                      value: '${station.mechanicalBikes}',
                      color: Colors.blue,
                    ),
                    const Divider(),
                    _StatRow(
                      label: 'Anclajes libres',
                      value: '${station.freeDocks}',
                      color: Colors.grey,
                    ),
                    const Divider(),
                    _StatRow(
                      label: 'Ocupación',
                      value: '${station.occupancyRate.toStringAsFixed(1)}%',
                      color: Colors.orange,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportPdf(BuildContext context) async {
    final doc = pw.Document();
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm:ss');
    final now = dateFormat.format(DateTime.now());
    final lastUpdated = dateFormat.format(station.status.lastReported);

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (_) => [
          pw.Header(
            level: 0,
            child: pw.Text(
              'Informe de Estación BiciCoruña',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 20),
          
          pw.Text(
            station.info.name,
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 10),
          
          pw.Text('Fecha de generación: $now'),
          pw.Text('Última actualización de datos: $lastUpdated'),
          pw.SizedBox(height: 20),
          
          pw.Header(level: 1, child: pw.Text('Datos estáticos')),
          pw.SizedBox(height: 10),
          pw.Text('ID de estación: ${station.info.stationId}'),
          pw.Text('Capacidad total: ${station.info.capacity} anclajes'),
          pw.Text('Latitud: ${station.info.lat}'),
          pw.Text('Longitud: ${station.info.lon}'),
          pw.SizedBox(height: 20),
          
          pw.Header(level: 1, child: pw.Text('Estado actual')),
          pw.SizedBox(height: 10),
          pw.TableHelper.fromTextArray(
            headers: ['Tipo', 'Cantidad'],
            data: [
              ['E-bikes disponibles', '${station.electricBikes}'],
              ['Bicis mecánicas', '${station.mechanicalBikes}'],
              ['Total bicis', '${station.totalBikes}'],
              ['Anclajes libres', '${station.freeDocks}'],
              ['Ocupación', '${station.occupancyRate.toStringAsFixed(1)}%'],
            ],
          ),
          pw.SizedBox(height: 20),
          
          pw.Header(level: 1, child: pw.Text('¿Me compensa bajar?')),
          pw.SizedBox(height: 10),
          pw.Text(
            station.compensaBajar,
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (_) async => doc.save());
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatRow({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
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

