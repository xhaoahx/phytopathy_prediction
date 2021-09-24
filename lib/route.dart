import 'package:flutter/material.dart';
import 'package:phytopathy_prediction/pages/navigation/discovery/topic_details.dart';
import 'package:phytopathy_prediction/pages/navigation/home/banner_detials.dart';
import 'package:phytopathy_prediction/pages/navigation/home/chat/chat_details.dart';
import 'package:phytopathy_prediction/pages/navigation/home/chat/chat_list.dart';
import 'package:phytopathy_prediction/pages/navigation/home/weather_boradcast.dart';
import 'package:phytopathy_prediction/pages/share/consult.dart';
import 'package:phytopathy_prediction/pages/share/register.dart';
import 'package:phytopathy_prediction/pages/splash.dart';

import 'pages/navigation/navigation.dart';
import 'pages/share/phytopathy_encyclopedia.dart';
import 'pages/share/phytopathy_encyclopedia_detail.dart';
import 'pages/share/phytopathy_prediction.dart';
import 'widgets/fade_in_page_route.dart';

// ignore: non_constant_identifier_names
class Routes {
  static const _unknownRouteName = 'unknown';

  static final splash = Splash.routeName;
  static final navigation = Navigation.routeName;
  static final register = Register.routeName;
  static final phytopathy_encyclopedia = PhytopathyEncyclopedia.routeName;
  static final phytopathy_prediction = PhytopathyPrediction.routeName;
  static final phytopathy_encyclopedia_detail =
      PhytopathyEncyclopediaDetail.routeName;

  static final weather_boradcast = WeatherBroadcast.routeName;
  static final banner_detials = BannerDetails.routeName;
  static final chat_list = ChatList.routeName;
  static final chat_details = ChatDetails.routeName;
  static final topic_details = TopicDetails.routeName;
  static final consult = Consult.routeName;

  static final _routeTable = <String, WidgetBuilder>{
    _unknownRouteName: _unknownPageBuilder,
    Navigation.routeName: Navigation.builder,
    Register.routeName: Register.builder,
    PhytopathyEncyclopedia.routeName: PhytopathyEncyclopedia.builder,
    PhytopathyPrediction.routeName: PhytopathyPrediction.builder,
    PhytopathyEncyclopediaDetail.routeName:
        PhytopathyEncyclopediaDetail.builder,
    WeatherBroadcast.routeName: WeatherBroadcast.builder,
    BannerDetails.routeName: BannerDetails.builder,
    ChatList.routeName: ChatList.builder,
    ChatDetails.routeName: ChatDetails.builder,
    TopicDetails.routeName: TopicDetails.builder,
    Consult.routeName: Consult.builder,
    Splash.routeName: Splash.builder,
  };

  static Route<void> handleGenerateRoute(RouteSettings settings) {
    final String? routeName = settings.name;
    final WidgetBuilder? builder = _routeTable[routeName ?? _unknownRouteName];

    if (routeName == Navigation.routeName) {
      assert(builder != null);
      return FadeInPageRoute(builder: builder!);
    }

    if (builder != null) {
      return MaterialPageRoute(
        builder: builder,
        settings: settings,
        //title: settings.name,
      );
    } else {
      // Unknown route
      assert(false);
      return MaterialPageRoute(builder: (BuildContext context) {
        return _unknownPageBuilder(context);
      });
    }
  }

  static Widget _unknownPageBuilder(context) => SizedBox();
}
