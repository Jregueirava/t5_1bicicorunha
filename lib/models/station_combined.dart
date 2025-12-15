import 'package:flutter/material.dart';
import 'station_info.dart';
import 'station_status.dart';

class StationCombined {
  final StationInfo info;
  final StationStatus status;

  StationCombined({
    required this.info,
    required this.status,
  });

  //Getters 

  int get totalBikes => status.numBikesAvailable;
  int get electricBikes => status.numEbikesAvaliable;
  int get mechanicalbikes => status.numMechanicalBikesAvaliable;
  int get freeDocks => status.numDocksAvaliable;

  //Porcentaje de ocupacion de la estacion
  double get occupancyRate{
    if(info.capacity == 0) return 0;
    final occupied = info.capacity - status.numDocksAvaliable;
    return (occupied/ info.capacity) * 100;
  }

  //COMPENSA BAJAR
  String get compensaBajar{
    //Pridridad 1: hay electricas , si compensa bajar
    if(electricBikes >= 1){
      return "Si - Hay $electricBikes e-bike(s) disponible(s)";
    }
    //Prioridad 2: solo hay mecanicas, quizas te compensa
    else if (mechanicalbikes > 0){
      return "Quizá - Solo hay bicis mecánicas($mechanicalbikes)";
    }
    //Caso 3: No hay bicis, No compensa
    else{
      return "No - No hay bicis disponibles";
    }
  }

  //Color asociado al estado

  Color get compensaColor{
    if(electricBikes >= 1) return Colors.green;
    if(mechanicalbikes > 0) return Colors.orange;
    return Colors.red;
  }
}