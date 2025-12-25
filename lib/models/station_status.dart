//Representación de la estación en tiempo real

class StationStatus {
  final String stationId;

  final int numBikesAvailable;
  final int numBikesDisabled;

  final int numDocksAvailable;
  final int numDocksDisabled;

  //Bicis eléctricas disponibles
  final int numEbikesAvailable;

  //Bicis mecánicas disponibles
  final int numMechanicalBikesAvailable;

  //Tiempo de la actualización de los datos
  final DateTime lastReported;

  StationStatus({
    required this.stationId,
    required this.numBikesAvailable,
    required this.numBikesDisabled,
    required this.numDocksAvailable,
    required this.numDocksDisabled,
    required this.numEbikesAvailable,
    required this.numMechanicalBikesAvailable,
    required this.lastReported,
  });

  factory StationStatus.fromJson(Map<String, dynamic> json) {
    final vehicleTypes = json["vehicle_types_available"] as List? ?? [];

    int ebikes = 0;
    int mechanical = 0;

    //Diferenciar las mecánicas de las eléctricas
    for (var type in vehicleTypes) {
      final typeId = type["vehicle_type_id"] as String;
      final count = (type["count"] as num).toInt();

      //Verificar si es eléctrica (puede venir "BOOST", "EFIT", "electric", etc.)
      if (typeId.contains("BOOST") || 
          typeId.contains("EFIT") ||
          typeId.contains("electric") ||
          typeId.contains("ebike")) {
        ebikes = count;
      } else {
        mechanical = count;
      }
    }
    
    return StationStatus(
      stationId: json["station_id"] as String,
      numBikesAvailable: (json["num_bikes_available"] as num).toInt(),
      numBikesDisabled: (json["num_bikes_disabled"] as num?)?.toInt() ?? 0,
      numDocksAvailable: (json["num_docks_available"] as num).toInt(),
      numDocksDisabled: (json["num_docks_disabled"] as num?)?.toInt() ?? 0,
      numEbikesAvailable: ebikes,
      numMechanicalBikesAvailable: mechanical,
      lastReported: DateTime.fromMillisecondsSinceEpoch(
        (json["last_reported"] as num).toInt() * 1000,
      ),
    );
  }
}
