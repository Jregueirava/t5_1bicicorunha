import '../models/station_combined.dart';
import '../models/station_info.dart';
import '../models/station_status.dart';
import 'bici_api.dart';


class BiciRepository {
  BiciRepository(this.api);

  Future<List<StationCombined>>fetchAllStations()async{
    final results = await Future.wait([api.getStationsInfoJson(),
    api.getStationStatusJson(),
    ]);

    final infos = infoList.map((e) => StationInfo.fromJson(e as Map<String, dynamic>))
    .toList();

    final statuces = statusList.map((e) => StationStatus.fromJson(e as Map<String, dynamic>)).
    toList();

    final statusMap={
      for(var s in statuses) s.StationCombined final combined = <StationCombined>[];

      for(var info in infos){
        final status = statusMap[info.stationId];

        if(status != null){
          combined.add(StationCombined(info: info, status: status));
        }
      }
      return combined;
    }
    
  }
}