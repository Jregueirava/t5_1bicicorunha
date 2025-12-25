//Se encarga de las peticiones HTTP a la API de BiciCoruña

import 'dart:convert';
import 'package:http/http.dart' as http;

class BiciApi{
  //URLS de los endpoints(General Bikeshare Feed Specification)
  static const String _baseInfo=
  "https://acoruna.publicbikesystem.net/customer/gbfs/v2/gl/station_information";
  static const String _baseStatus =
  "https://acoruna.publicbikesystem.net/customer/gbfs/v2/gl/station_status";


//Info estatica de todas las estaciones
Future<List<dynamic>> getStationsInfoJson() async{
  final url = Uri.parse(_baseInfo);

  //Peticion asincrona
  final res = await http.get(url);

  //Validar respuesta HHTP

  if(res.statusCode != 200){
    throw Exception("Error HTTP ${res.statusCode} en station_information");

  }

  //Decodificaion del JSON
  final decoded = jsonDecode(res.body);

  if(decoded is! Map || decoded["data"] == null){
    throw Exception("Formato inesperado en station_information");
  }

  final data = decoded["data"] as Map<String, dynamic>;
  final stations = data["stations"] as List;
  return stations;
}

//Estado en timepo real de la estacion
Future<List<dynamic>> getStationsStatusJson() async {
    final url = Uri.parse(_baseStatus);
    final res = await http.get(url);

    if (res.statusCode != 200) {
      throw Exception("Error HTTP ${res.statusCode} en station_status");
    }

    final decoded = jsonDecode(res.body);

    if (decoded is! Map || decoded["data"] == null) {
      throw Exception("Formato inesperado en station_status");
    }

    final data = decoded["data"] as Map<String, dynamic>;
    final stations = data["stations"] as List;
    return stations;
  }
}