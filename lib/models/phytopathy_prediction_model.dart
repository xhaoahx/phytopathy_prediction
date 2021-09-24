import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phytopathy_prediction/common/error_handler.dart';

import 'network.dart';

export 'package:image_picker/image_picker.dart' show ImageSource;

class PhytopathyPredictionModel with ChangeNotifier {
  int get predictionIndex => _predictionIndex!;
  int? _predictionIndex;

  File get image => _image!;
  File? _image;

  bool get hasData => _hasData;
  bool _hasData = false;

  bool get chosen => _chosen;
  bool _chosen = false;

  bool get isLoading => _isLoading;
  bool _isLoading = false;

  bool get isChoosing => _isChoosing;
  bool _isChoosing = false;


  Future<bool> takeImage(ImageSource source) async {
    if (_isChoosing || _isLoading) {
      return false;
    }

    final picker = ImagePicker();

    try {
      _isChoosing = true;
      final pickedFile = await picker.getImage(source: source);

      if (pickedFile == null) {
        _isChoosing = false;
        return false;
      } else {
        _image = File(pickedFile.path);
        _isChoosing = false;
        _chosen = true;

        notifyListeners();
        return true;
      }
    } catch (e, s) {
      errorPrintHandler(e, s);
      return false;
    }finally{
      _isChoosing = false;
    }
  }

  Future<void> prediction() async {
    if (_isLoading) {
      return;
    }

    _hasData = false;
    _isLoading = true;
    notifyListeners();

    await _loadData();

    _isLoading = false;
    _hasData = true;
    notifyListeners();
  }

  Future<void> _loadData() async {
    assert(_chosen);
    assert(_image != null);

    final path = _image!.path;
    final formData =
        FormData.fromMap({"myfile": await MultipartFile.fromFile(path)});

    try {
      final data = await Network.instance.post('',data: formData);
      if(data == null){
        throw ArgumentError.notNull('_loadData.data');
      }
      _handleResponse(data);
    } catch (e, s) {
      errorPrintHandler(e, s);
    }
  }

  void _handleResponse(dynamic data) {
    if(data is Map){
      _predictionIndex = data['data']['result'];
    }else{
      final dataStr = data as String;
      final json = jsonDecode(dataStr.replaceAll('&#39;', '"'));
      _predictionIndex = json['data']['result'];
    }
  }
}
