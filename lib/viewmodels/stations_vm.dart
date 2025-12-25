// ViewModel: gestiona el estado de la UI

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/bici_repository.dart';
import '../models/station_combined.dart';

class StationsVm extends ChangeNotifier {
  final BiciRepository repo;

  StationsVm(this.repo);


  bool loading = false;
  String? error;


  List<StationCombined> allStations = [];
  String? favoriteStationId;

  StationCombined? get favoriteStation {
    if (favoriteStationId == null) return null;

    try {
      return allStations.firstWhere(
        (s) => s.info.stationId == favoriteStationId
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> loadStations() async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      allStations = await repo.fetchAllStations();

      await _loadFavoriteFromPrefs();
    } catch (e) {
      error = e.toString();

      allStations = [];
    }
    
    loading = false;
    notifyListeners();
  }

  Future<void> setFavorite(String stationId) async {
    favoriteStationId = stationId;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("favorite_station_id", stationId);

    notifyListeners();
  }


  Future<void> _loadFavoriteFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    favoriteStationId = prefs.getString("favorite_station_id");
  }

  List<StationCombined> getTopByEbikes(int n) {
    final sorted = List<StationCombined>.from(allStations)
      ..sort((a, b) => b.electricBikes.compareTo(a.electricBikes));

    return sorted.take(n).toList();
  }

  List<StationCombined> getTopByOccupancy(int n) {
    final sorted = List<StationCombined>.from(allStations)
      ..sort((a, b) => b.occupancyRate.compareTo(a.occupancyRate));
    return sorted.take(n).toList();
  }
}