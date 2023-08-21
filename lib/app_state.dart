import 'package:flutter/material.dart';
import 'src/services/spotify_api_fetch.dart';
import 'src/utils/database_helper.dart';
import 'src/utils/constants.dart';

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

  late DateTimeRange timeRange;

  DateTimeRange get getTimeRange => timeRange;

  set setTimeRange(DateTimeRange value) {
    timeRange = value;
    notifyListeners();
  }

  bool isMaxRange = true;

  bool get getIsMaxRange => isMaxRange;

  set setIsMaxRange(bool value) {
    isMaxRange = value;
    notifyListeners();
  }

  TopListsOrderBy listsSort = TopListsOrderBy.time;

  TopListsOrderBy get getListsSort => listsSort;

  set setListsSort(TopListsOrderBy value) {
    listsSort = value;
    notifyListeners();
  }

  HistoryOrderBy historySort = HistoryOrderBy.newestFirst;

  HistoryOrderBy get getHistorySort => historySort;

  set setHistorySort(HistoryOrderBy value) {
    historySort = value;
    notifyListeners();
  }

  Future<void> init() async {
    accessToken = await getAccessToken();

    if (await DatabaseHelper().isDatabaseEmpty()) {
      dataReady = false;
    } else {
      timeRange = await DatabaseHelper().getMaxDateRange();
      dataReady = true;
    }
    appReady = true;
    notifyListeners();
  }
}
