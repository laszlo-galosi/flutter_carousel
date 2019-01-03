import 'package:flutter/material.dart';
import 'package:flutter_carousel/carousel_widget/carousel_widget_view.dart';
import 'package:flutter_carousel/carousel_widget/carousel_widget_view_model.dart';

import './home_page_view_model.dart';

class HomePageView extends HomePageViewModel {
  HomePageView();

  factory HomePageView.forDesignTime() {
    return new HomePageView();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return CarouselWidgetModelBinding(
        model: currentModel,
        child: Scaffold(
          appBar: AppBar(
            // Here we take the value from the MyHomePage object that was createdP bPy
            // the App.build method, and use it to set our appbar title.
            title: Text(widget.title),
          ),
          body: Center(child: CarouselWidgetView(updateModel: updateModel)),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              updateModel(
                  CarouselWidgetViewModel(autoPlay: !currentModel.autoPlay));
            },
            tooltip: 'Autoplay',
            child: currentModel.autoPlay
                ? Icon(Icons.pause)
                : Icon(Icons.play_arrow),
          ),
        ));
  }
}
