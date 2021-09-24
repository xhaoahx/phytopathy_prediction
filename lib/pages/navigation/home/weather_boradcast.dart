import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/error_handler.dart';
import '../../../models/weather_model.dart';

class WeatherBroadcast extends StatelessWidget {

  static const routeName = 'weather_broadcast';
  static Widget builder(context) => WeatherBroadcast();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('天气预报'),
      // ),
      body: _WeatherBroadcastBody(),
    );
  }
}

class _WeatherBroadcastBody extends StatefulWidget {
  @override
  __WeatherBroadcastBodyState createState() => __WeatherBroadcastBodyState();
}

class __WeatherBroadcastBodyState extends State<_WeatherBroadcastBody> {
  bool _hasError = false;

  @override
  void initState() {
    super.initState();

    final model = context.read<WeatherModel>();

    if(!model.loaded){
      model.loadPosition().catchError((e, s) {
        errorPrintHandler(e, s);
        setState(() {
          _hasError = true;
        });
      }).then((_) {
        model.loadWeatherData().catchError((e, s) {
          errorPrintHandler(e, s);
          setState(() {
            _hasError = true;
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Center(
        child: Text('加载失败'),
      );
    }

    if (context.watch<WeatherModel>().loaded) {
      return _WeatherContent();
    } else {
      return Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            const SizedBox(width: 15.0),
            Text('加载中，请稍后'),
          ],
        ),
      );
    }
  }
}

class _WeatherContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      child: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            delegate: _WeatherMainDelegate(),
            pinned: true,
          ),
          _Forecast(),
        ],
      ),
      onRefresh: context.read<WeatherModel>().loadWeatherData,
    );
  }
}

class _WeatherMainDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final percent = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);

    print('percent: $percent');

    final opacity = (1.0 - percent * 2).clamp(0.0, 1.0);
    final top = (1.0 - percent) * 30.0;
    const paddingTop = 30.0;

    final weather = context.read<WeatherModel>().weather;

    print(paddingTop);

    final backgroundImg = weather.weatherIcon != null
        ? Opacity(
            opacity: 0.4,
            child: Image.asset(
              'assets/pic/forecast/${weather.weatherIcon!.substring(0, 2)}.png',
              //'assets/pic/forecast/11.png',
              fit: BoxFit.cover,
            ),
          )
        : SizedBox();

    final backgroundAppbar = Container(
      decoration: BoxDecoration(
        // gradient: Tween<LinearGradient>(
        //   begin: LinearGradient(
        //     begin: Alignment.topCenter,
        //     end: Alignment.bottomCenter,
        //     colors: [
        //       Theme.of(context).primaryColor.withOpacity(bgOpacity),
        //       Theme.of(context).canvasColor.withOpacity(bgOpacity),
        //     ],
        //   ),
        //   end: LinearGradient(
        //     begin: Alignment.topCenter,
        //     end: Alignment.bottomCenter,
        //     colors: [
        //       Theme.of(context).primaryColor.withOpacity(bgOpacity),
        //       Theme.of(context).canvasColor.withOpacity(bgOpacity),
        //     ],
        //   ),
        // ).lerp(percent),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).primaryColor.withOpacity(percent),
            ColorTween(
              begin: Theme.of(context).canvasColor.withOpacity(1.0 - percent),
              end: Theme.of(context).primaryColor.withOpacity(percent),
            ).lerp(percent)!,
          ],
        ),
      ),
    );

    final backButton = IconButton(
        icon: Icon(
          Icons.arrow_back_ios_outlined,
          color: Colors.white,
        ),
        onPressed: () => Navigator.pop(context));

    final position = Container(
      //color: Colors.red,
      height: kToolbarHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            weather.areaName ?? '未知地点',
            style: TextStyle(fontSize: 20.0, color: Colors.white),
          ),
          const SizedBox(
            width: 16.0,
          ),
          Icon(
            Icons.location_on_sharp,
            size: 20.0,
            color: Colors.white,
          ),
        ],
      ),
    );

    final tempe = Container(
      //color: Colors.blue,
      height: 80.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            weather.temperature?.celsius?.toInt().toString() ?? '0',
            style: TextStyle(
              color: Colors.white,
              fontSize: 72.0,
            ),
          ),
          const Text(
            '℃',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );

    //final tempeRange =

    final tempeRange = Container(
      //color: Colors.green,
      height: kToolbarHeight,
      child: Text(
        '${weather.tempMax?.celsius?.toInt() ?? '0'}℃'
        '/'
        '${weather.tempMin?.celsius?.toInt() ?? '0'}℃',
        style: TextStyle(fontSize: 20.0, color: Colors.white),
      ),
      alignment: Alignment.center,
    );

    final description = SizedBox(
      height: 32.0,
      child: Text(
        weather.weatherDescription ?? '未知',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
      ),
    );

    final body = opacity > 0
        ? Opacity(
            opacity: opacity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [tempe, tempeRange, description],
            ),
          )
        : SizedBox();

    final content = Column(
      children: [position, body],
    );

    return Stack(
      children: [
        Positioned.fill(child: backgroundImg),
        Positioned.fill(child: backgroundAppbar),
        Positioned(
          top: paddingTop,
          left: 0.0,
          child: backButton,
        ),
        Positioned(
          top: paddingTop + top,
          left: 60.0,
          right: 60.0,
          child: content,
        ),
      ],
    );
  }

  @override
  double get maxExtent => 320;

  double get minExtent => 86.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}

class _Forecast extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final forecast = context.read<WeatherModel>().forecast;

    print('rebuild');
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final weather = forecast[index];
          final time =
              Text(weather.date?.toString().substring(0, 16) ?? '未知时间');
          final icon = weather.weatherIcon != null
              ? Image.asset('assets/pic/forecast/${weather.weatherIcon!}.png')
              : SizedBox();
          final tempeRange = Text(
            '${weather.tempMax?.celsius?.toInt() ?? '0'}℃'
            '/'
            '${weather.tempMin?.celsius?.toInt() ?? '0'}℃',
          );

          return SizedBox(
            height: 56.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [time, icon, tempeRange],
            ),
          );
        },
        childCount: forecast.length,
      ),
    );
  }
}
