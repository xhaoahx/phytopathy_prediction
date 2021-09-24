import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phytopathy_prediction/models/phytopathy_encyclopedia_model.dart';
import 'package:phytopathy_prediction/models/phytopathy_prediction_model.dart';
import 'package:phytopathy_prediction/objects/phytopathy_data.dart';
import 'package:phytopathy_prediction/route.dart';
import 'package:provider/provider.dart';

final titleStyle = TextStyle(
  fontSize: 20.0,
  fontWeight: FontWeight.w200,
);

class PhytopathyPrediction extends StatelessWidget {
  static const routeName = 'phytopathy_prediction';
  static Widget builder(context) => PhytopathyPrediction();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('植物疾病检测'),
      ),
      body: _PredictionBody(),
    );
  }
}

class _PredictionBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = Center(
      child: Text(
        '图片选择',
        style: titleStyle,
      ),
    );

    final chooser = _ImageChooser();

    final predictButton = Builder(
      builder: (context) {
        void handleButtonPressed() async {
          final model =
              Provider.of<PhytopathyPredictionModel>(context, listen: false);
          if (model.chosen) {
            // ignore: non_constant_identifier_names
            final EPModel = Provider.of<PhytopathyEncyclopediaModel>(
              context,
              listen: false,
            );

            await EPModel.initialize();
            Provider.of<PhytopathyPredictionModel>(
              context,
              listen: false,
            ).prediction();
          } else {
            Scaffold.of(context).showBottomSheet((context) => Text('请选择一张图片'));
          }
        }

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 40.0,
            vertical: 25.0,
          ),
          child: MaterialButton(
            disabledColor: Colors.grey.withOpacity(0.5),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9.0)),
            color: Theme.of(context).primaryColor,
            onPressed: context.watch<PhytopathyPredictionModel>().isLoading
                ? null
                : handleButtonPressed,
            child: Container(
              height: 50.0,
              alignment: Alignment.center,
              child: Text(
                '预测',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w200,
                ),
              ),
            ),
          ),
        );
      },
    );

    final blank = _ResultBlank();

    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 5.0,
      ),
      children: [
        title,
        chooser,
        predictButton,
        blank,
      ],
    );
  }
}

class _ImageChooser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pModel = Provider.of<PhytopathyPredictionModel>(context);

    Widget placeholder;

    if (pModel.chosen) {
      placeholder = Image.file(
        pModel.image,
        fit: BoxFit.cover,
      );
    } else {
      placeholder = Image.asset(
        'assets/pic/prediction/camera.jpeg',
        fit: BoxFit.cover,
      );
    }

    final img = AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        margin: const EdgeInsets.all(12.0),
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          border: Border.all(
            color: Theme.of(context).primaryColor,
            width: 1.5,
          ),
        ),
        child: placeholder,
      ),
    );

    return GestureDetector(
      onTap: () async {
        if (pModel.isChoosing) {
          return;
        }

        final source = await showDialog<ImageSource>(
          context: context,
          builder: (context) => SimpleDialog(
            children: [
              SimpleDialogOption(
                child: Text(
                  '使用本地图片',
                ),
                onPressed: () {
                  Navigator.pop(context, ImageSource.gallery);
                },
              ),
              SimpleDialogOption(
                child: Text(
                  '拍摄图片',
                ),
                onPressed: () {
                  Navigator.pop(context, ImageSource.camera);
                },
              ),
            ],
          ),
        );

        if (source != null) {
          pModel.takeImage(source);
        }
      },
      child: Align(
        alignment: Alignment.center,
        child: SizedBox(
          width:
              MediaQuery.of(context).size.width * (pModel.chosen ? 0.75 : 0.55),
          child: img,
        ),
      ),
    );
  }
}

class _ResultBlank extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<PhytopathyPredictionModel>(context);

    if (model.isLoading) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          Text(
            '加载中，请稍后',
          ),
        ],
      );
    } else {
      if (model.hasData) {
        return _ResultContent(context
            .read<PhytopathyEncyclopediaModel>()
            .dataList[model.predictionIndex]);
      } else {
        return Container(
          alignment: Alignment.center,
          child: Text('请选择一张图片并点击预测按钮'),
        );
      }
    }
  }
}

class _ResultContent extends StatelessWidget {
  _ResultContent(this.data);

  final PhytopathyData data;

  @override
  Widget build(BuildContext context) {
    final title = Text(
      '预测结果：',
      style: titleStyle,
    );

    final titleZN = Text(
      data.titleZN,
      style: TextStyle(
        fontSize: 28.0,
        fontWeight: FontWeight.w300,
      ),
      maxLines: 2,
      softWrap: true,
    );

    final titleEN = Text(
      data.titleEN,
      style: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w200,
      ),
      maxLines: 1,
      softWrap: true,
      overflow: TextOverflow.ellipsis,
    );

    final image = SizedBox(
      child: Hero(
        tag: data,
        child: Image.asset('assets/pic/disease/${data.index}.JPG'),
      ),
      width: MediaQuery.of(context).size.width * 0.55,
    );

    final content = Column(
      //mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(alignment: Alignment.centerLeft, child: title),
        titleZN,
        titleEN,
        image,
      ],
    );

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.phytopathy_encyclopedia_detail,
          arguments: data,
        );
      },
      child: content,
    );
  }
}
