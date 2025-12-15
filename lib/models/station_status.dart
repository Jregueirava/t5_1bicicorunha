//Representacion de la estacion a tiempo real

class StationStatus {
  final String stationId;

  final int numBikesAvailable;
  final int numBikesDisabled;

  final int numDocksAvaliable;
  final int numDocksDisabled;

//Bicis electricas disponibles
  final int numEbikesAvaliable;

//Bicis mecanicas disponibles
final int numMechanicalBikesAvaliable;

//Tiempo de la act de los datos

final DateTime lastReported;

StationStatus({
  required this.stationId,
  required this.numBikesAvailable,
  required this.numBikesDisabled,
  required this.numDocksAvaliable,
  required this.numDocksDisabled,
  required this.numEbikesAvaliable,
  required this.numMechanicalBikesAvaliable,
  required this.lastReported,
});

factory StationStatus.fromJson(Map<String, dynamic> json){
  final vehicleTypes = json["vehicle_types_avaliable"] as List? ?? [];

  int ebikes= 0;
  int mechanical= 0;

  //Diferenciar las mecánicas de las eléctricas
  for(var type in vehicleTypes){
    final typeId = type["vehicle_type_id"] as String;
    final count=(type["count"] as num).toInt();

    if (typeId.contains("BOOST") || typeId.contains("EFIT")){
      ebikes = count;
    } else{
      mechanical= count;
    }
  }
  return StationStatus(
  stationId: json["station_id"] as String,
  numBikesAvailable: (json["num_bikes_avalible"] as num).toInt(),
  numBikesDisabled: (json["num_bikes_disabled"] as num?)?.toInt()?? 0,
  numDocksAvaliable: (json["num_docks_available"] as num).toInt(),
  numDocksDisabled: (json["num_docks_disabled"] as num?)?.toInt() ?? 0,
  numEbikesAvaliable: ebikes,
  numMechanicalBikesAvaliable: mechanical,
  lastReported: DateTime.fromMillisecondsSinceEpoch((json["last_reported"] as num).toInt() * 1000,
  ),
);
}


}
