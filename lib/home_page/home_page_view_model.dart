import 'package:flutter/material.dart';
import 'package:flutter_carousel/carousel_widget/carousel_widget_view_model.dart';

import './home_page.dart';

abstract class HomePageViewModel extends State<HomePage> {
  @protected
  CarouselWidgetViewModel currentModel =
      CarouselWidgetViewModel(autoPlay: true, currentPage: 0);

  void updateModel(CarouselWidgetViewModel newModel) {
    if (newModel != currentModel) {
      setState(() {
        currentModel = newModel;
      });
    }
  }
}
