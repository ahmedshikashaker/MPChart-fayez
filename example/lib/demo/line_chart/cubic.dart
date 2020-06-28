import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mp_chart/mp/chart/line_chart.dart';
import 'package:mp_chart/mp/controller/line_chart_controller.dart';
import 'package:mp_chart/mp/core/data/line_data.dart';
import 'package:mp_chart/mp/core/data_interfaces/i_line_data_set.dart';
import 'package:mp_chart/mp/core/data_provider/line_data_provider.dart';
import 'package:mp_chart/mp/core/data_set/line_data_set.dart';
import 'package:mp_chart/mp/core/description.dart';
import 'package:mp_chart/mp/core/entry/entry.dart';
import 'package:mp_chart/mp/core/enums/mode.dart';
import 'package:mp_chart/mp/core/enums/y_axis_label_position.dart';
import 'package:mp_chart/mp/core/fill_formatter/i_fill_formatter.dart';
import 'package:mp_chart/mp/core/image_loader.dart';
import 'package:mp_chart/mp/core/utils/color_utils.dart';
import 'package:example/demo/action_state.dart';
import 'package:example/demo/util.dart';

class LineChartCubic extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LineChartCubicState();
  }
}

class LineChartCubicState extends LineActionState<LineChartCubic> {
  var random = Random(1);
  int _count = 16;
  double _range = 100.0;

  @override
  void initState() {
    _initController();
    _initLineData(_count, _range);
    super.initState();
  }

  @override
  String getTitle() => "Line Chart Cubic";

  @override
  Widget getBody() {
    return Stack(
      children: <Widget>[
        Positioned(
          right: 16,
          left: 16,
          top: 0,
          bottom: 100,
          child: _initLineChart(),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Center(
                        child: Slider(
                            value: _count.toDouble(),
                            min: 0,
                            max: 700,
                            onChanged: (value) {
                              _count = value.toInt();
                              _initLineData(_count, _range);
                            })),
                  ),
                  Container(
                      padding: EdgeInsets.only(right: 15.0),
                      child: Text(
                        "$_count",
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: ColorUtils.BLACK,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      )),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Center(
                        child: Slider(
                            value: _range,
                            min: 0,
                            max: 150,
                            onChanged: (value) {
                              _range = value;
                              _initLineData(_count, _range);
                            })),
                  ),
                  Container(
                      padding: EdgeInsets.only(right: 15.0),
                      child: Text(
                        "${_range.toInt()}",
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: ColorUtils.BLACK,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      )),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  void _initController() {
    var desc = Description()..enabled = false;
    controller = LineChartController(
        axisLeftSettingFunction: (axisLeft, controller) {
          axisLeft.enabled= false;
//          axisLeft
//            ..typeface = Util.LIGHT
//            ..setLabelCount2(6, false)
//            ..textColor = (ColorUtils.WHITE)
//            ..position = (YAxisLabelPosition.INSIDE_CHART)
//            ..drawGridLines = (false)
//            ..axisLineColor = (ColorUtils.BLUE);
        },
        axisRightSettingFunction: (axisRight, controller) {
          axisRight.enabled = (false);
        },
        legendSettingFunction: (legend, controller) {
          (controller as LineChartController).setViewPortOffsets(0, 0, 0, 0);
          legend.enabled = (false);
          var data = (controller as LineChartController).data;
          if (data != null) {
            var formatter = data.getDataSetByIndex(0).getFillFormatter();
            if (formatter is A) {
              formatter.setPainter(controller);
            }
          }
        },
        xAxisSettingFunction: (xAxis, controller) {
          xAxis.enabled = (true);
          xAxis.drawGridLines = true;
          xAxis.gridLineWidth = 1;
        },
//        drawGridBackground: true,
        dragXEnabled: true,
        dragYEnabled: true,
        scaleXEnabled: true,
        scaleYEnabled: true,
        pinchZoomEnabled: false,
//        gridBackColor: Color.fromARGB(255, 104, 241, 175),

        backgroundColor: Colors.white,
        description: desc);
  }

  void _initLineData(int count, double range) async {
    var img = await ImageLoader.loadImage('assets/img/star.png');


    List<Entry> values = List();

    for (int i = 0; i < count; i++) {
      double val = (random.nextDouble() * (range + 1)) + 20;
      values.add(Entry(x: i.toDouble(), y: val, icon: img));
    }

    LineDataSet set1;
    LineDataSet set2;
    // create a dataset and give it a type
    set1 = LineDataSet(values, "DataSet 1");

    set1.setMode(Mode.CUBIC_BEZIER);
    set1.setCubicIntensity(0.2);
    set1.setDrawFilled(false);
    set1.setDrawCircles(false);
    set1.setLineWidth(3);
    set1.setCircleRadius(4);
    set1.setCircleColor(ColorUtils.WHITE);
    set1.setHighLightColor(Color.fromARGB(255, 244, 117, 117));
    set1.setFillColor(ColorUtils.WHITE);
    set1.setFillAlpha(100);
    set1.setDrawHorizontalHighlightIndicator(false);
    set1.setFillFormatter(A());

    set2 = LineDataSet([values[0]], "DataSet 2");

    set2.setMode(Mode.CUBIC_BEZIER);
    set2.setCubicIntensity(0.2);
    set2.setDrawFilled(false);
    set2.setDrawCircles(false);
    set2.setLineWidth(3);
    set2.setCircleRadius(4);
    set2.setCircleSize(40);
    set2.setCircleColor(ColorUtils.WHITE);
    set2.setHighLightColor(Color.fromARGB(255, 244, 117, 117));
    set2.setFillColor(ColorUtils.WHITE);
    set2.setFillAlpha(100);
    set2.setDrawIcons(true);


    set2.setDrawHorizontalHighlightIndicator(false);
    set2.setFillFormatter(A());

    // create a data object with the data sets
    controller.data = LineData.fromList(List()..add(set1)..add(set2))
      ..setValueTypeface(Util.LIGHT)
      ..setValueTextSize(9)
      ..setDrawValues(false);

    setState(() {});
  }

  Widget _initLineChart() {
    var lineChart = LineChart(controller);
    controller.animator
      ..reset()
      ..animateXY1(2000, 2000);
    return lineChart;
  }
}

class A implements IFillFormatter {
  LineChartController _controller;

  void setPainter(LineChartController controller) {
    _controller = controller;
  }

  @override
  double getFillLinePosition(
      ILineDataSet dataSet, LineDataProvider dataProvider) {
    return _controller?.painter?.axisLeft?.axisMinimum;
  }
}
