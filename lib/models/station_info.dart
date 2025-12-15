class StationInfo{
  final String stationId;
  final String name;

  //Coordenadas
  final double lat;
  final double lon;

  //Numero de anclajes de la estacion
  final int capacity;

  StationInfo({
    required this.stationId,
    required this.name,
    required this.lat,
    required this.lon,
    required this.capacity,
  });

factory StationInfo.fromJson(Map<String, dynamic> json){
  return StationInfo(stationId: json["station_id"] as String, 
  name: json["name"] as String, 
  lat: (json["lat"] as num).toDouble(),
   lon: (json["lon"] as num).toDouble(), 
   capacity: (json["capacity"] as num).toInt(),
   );
}

}