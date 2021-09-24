import 'dart:async';

import 'package:flutter/foundation.dart';

import '../objects/phytopathy_data.dart';

class PhytopathyEncyclopediaModel with ChangeNotifier {
  List<PhytopathyData> get dataList{
    assert(_isLoaded);
    return _dataList!;
  }

  Completer<void> get loadingCpl{
    assert(_isLoading);
    return _loadingCpl!;
  }

  bool get isLoaded => _isLoaded;
  bool get isLoading => _isLoading;

  bool _isLoaded = false;
  bool _isLoading = false;

  Completer<void>? _loadingCpl;
  List<PhytopathyData>? _dataList;

  Future<void> initialize() async {
    if(_isLoaded){
      return;
    }
    _isLoading = true;
    _loadingCpl = Completer();

    _dataList = await PhytopathyData.loadAllFromAssets();

    _loadingCpl!.complete();
    _isLoading = false;

    _isLoaded = true;
    notifyListeners();
  }
}
