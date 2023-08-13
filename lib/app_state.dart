import 'package:flutter/material.dart';
import 'src/services/spotify_api_fetch.dart';
import 'src/utils/database_helper.dart';

class AppState extends ChangeNotifier {
  AppState() {
    init();
  }

  AccessToken accessToken = AccessToken.empty();

  bool appReady = false;

  bool get isAppReady => appReady;

  bool loading = false;

  int minTime = 0;

  int dataLength = 0;

  int get getDataLength => dataLength;

  set setDataLength(int value) {
    dataLength = value;
    notifyListeners();
  }

  int dataProgress = 0;

  int get getDataProgress => dataProgress;

  set setDataProgress(int value) {
    dataProgress = value;
    notifyListeners();
  }

  get getMinTime => minTime;

  set setMinTime(int value) {
    minTime = value;
    notifyListeners();
  }

  get isLoading => loading;

  set setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

  bool dataReady = false;

  get isDataReady => dataReady;

  set setDataReady(bool value) {
    dataReady = value;
    notifyListeners();
  }

  Future<void> init() async {
    accessToken = await getAccessToken();

    if (await DatabaseHelper().isDatabaseEmpty()) {
      dataReady = false;
    } else {
      dataReady = true;
    }
    appReady = true;
    notifyListeners();
  }
}
