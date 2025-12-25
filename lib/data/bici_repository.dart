import '../models/station_combined.dart';
import '../models/station_info.dart';
import '../models/station_status.dart';
import 'bici_api.dart';

class BiciRepository {
  final BiciApi api; 

  BiciRepository(this.api);

  Future<List<StationCombined>> fetchAllStations() async {
    //Llamadas en paralelo
    final results = await Future.wait([
      api.getStationsInfoJson(),
      api.getStationsStatusJson(),
    ]);

   
    final infoList = results[0];
    final statusList = results[1];

    //Convertir JSON a modelos
    final infos = infoList
        .map((e) => StationInfo.fromJson(e as Map<String, dynamic>))
        .toList();

    final statuses = statusList 
        .map((e) => StationStatus.fromJson(e as Map<String, dynamic>))
        .toList();

    //Crear Map para búsqueda rápida
    final statusMap = {
      for (var s in statuses) s.stationId: s 
    };

    //Combinar info + status
    final combined = <StationCombined>[];

    for (var info in infos) {
      final status = statusMap[info.stationId];

      if (status != null) {
        combined.add(StationCombined(info: info, status: status));
      }
    }
    
    return combined;
  }
}