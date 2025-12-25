//Combina info + status con lógica calculada

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



  int get totalBikes => status.numBikesAvailable;

  int get electricBikes => status.numEbikesAvailable;

  int get mechanicalBikes => status.numMechanicalBikesAvailable;

  int get freeDocks => status.numDocksAvailable;

  //Porcentaje de ocupación de la estación
  double get occupancyRate {
    if (info.capacity == 0) return 0;
    final occupied = info.capacity - status.numDocksAvailable;
    return (occupied / info.capacity) * 100;
  }

//LÓGICA "¿ME COMPENSA BAJAR?"
  String get compensaBajar {
    //Prioridad 1: hay eléctricas, sí compensa bajar
    if (electricBikes >= 1) {
      return "Sí - Hay $electricBikes e-bike(s) disponible(s)";
    }
    //Prioridad 2: solo hay mecánicas, quizás te compensa
    else if (mechanicalBikes > 0) {
      return "Quizá - Solo hay bicis mecánicas ($mechanicalBikes)";
    }
    //Caso 3: No hay bicis, No compensa
    else {
      return "No - No hay bicis disponibles";
    }
  }

  //Color asociado al estado
  Color get compensaColor {
    if (electricBikes >= 1) return Colors.green;
    if (mechanicalBikes > 0) return Colors.orange;
    return Colors.red;
  }
}