import 'package:flutter/foundation.dart';
import 'package:shared_prefereneces/shared_preferences.dart';
import '../data/bici_repository.dart';
import '../models/station_combined.dart';

class StationsVm extends ChangeNotifier{
  final BiciRepository repo;

  StationsVm(this.repo);

  bool loding = false;
  String? error;

  List<StationCombined> allStation = [];
 String? favoriteStationId;

 StationCombined? get favoriteStationId{
  if(favoriteStationId == null) return null;

  try{
    return allStations.firstWhere(
      (s) => s.info.stationId == favoriteStationId
    );

  } catch(_){
    return null;
  }
 }

 Future<void> loadStations() async{
  loading = true;
  error = null;

  notifyListeners();

  try{
    allStations = await repo.fetchAllStations();

    await_loadFavoriteFromPrefs();
  } catch(e){
    error = e.toString();
    allStation[];
  }
  loading = false;
  notifyListeners();

  Future<void> setFavorite(String stationId) async{
    favoriteStationId = stationId;

    final prefs = stationId;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("favorite_station_id", stationId);

    notifyListeners();

  }

  Future<void> await_loadFavoriteFromPrefs() async{
    final prefs = await SharedPreferences.getInstance();
    favoriteStationId = prefs.getString("favorite_station_id");

  }

  List<StationCombined> getTopByEbikes(int n){
    final sorted = List<StationCombined> .from(allStation)

    ..sort((a, b) => b.electricBikes.compareTo(a.electricBikes));

    return sorted.take(n).toList();
  }

  List<StationCombined> getTopByOccupancy(int n){
      final sorted = List<StationCombined>.from(allStations)
      ..sort((a, b) => b.occupancyRate.compareTo(a.occupancyRate));
      return sorted.take(n).toList();
  }
 }
 

}