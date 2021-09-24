import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:phytopathy_prediction/models/chat_model.dart';
import 'package:phytopathy_prediction/models/discovery_model.dart';
import 'package:phytopathy_prediction/models/phytopathy_encyclopedia_model.dart';
import 'package:phytopathy_prediction/models/phytopathy_prediction_model.dart';
import 'package:phytopathy_prediction/models/user_model.dart';
import 'package:phytopathy_prediction/models/weather_model.dart';
import 'package:phytopathy_prediction/objects/theme.dart';
import 'package:phytopathy_prediction/pages/splash.dart';
import 'package:phytopathy_prediction/route.dart';
import 'package:provider/provider.dart';

class PhytopathyPredictionAPP extends StatelessWidget {
  // 植物百科模型
  final _phytopathyEPModel = PhytopathyEncyclopediaModel();
  // 植物预测模型
  final _phytopathyPModel = PhytopathyPredictionModel();

  // 天气模型
  final _weatherModel = WeatherModel();
  // 登陆模型
  final _loginModel = UserModel();
  // 咨询模型
  final _chatModel = ChatModel();

  final _discoveryModel = DiscoveryModel();

  @override
  Widget build(BuildContext context) {
    final app = OKToast(
      child: MaterialApp(
        title: '寻害医生',
        theme: APPThemeData.themeData,
        home: Splash(),
        onGenerateRoute: Routes.handleGenerateRoute,
        //onGenerateInitialRoutes: ,
      ),
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _loginModel),
        ChangeNotifierProvider<PhytopathyEncyclopediaModel>.value(
          value: _phytopathyEPModel,
        ),
        ChangeNotifierProvider<PhytopathyPredictionModel>.value(
          value: _phytopathyPModel,
        ),
        ChangeNotifierProvider<WeatherModel>.value(
          value: _weatherModel,
        ),
        ChangeNotifierProvider<ChatModel>.value(value: _chatModel),
        ChangeNotifierProvider<DiscoveryModel>.value(value: _discoveryModel),
      ],
      child: app,
    );
  }
}
