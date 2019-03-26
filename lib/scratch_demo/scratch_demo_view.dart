import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_carousel/navigation/navigation_view_model.dart';
import 'package:flutter_carousel/resources.dart' as res;
import 'package:flutter_carousel/scratch_demo/scratch_card_view_model.dart';
import 'package:flutter_carousel/scratch_demo/scratch_card_widget.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:sprintf/sprintf.dart';

class ScratchDemoPageWidget extends StatefulWidget {
  ScratchDemoPageWidget({Key key, @required this.viewModel});

  final ScratchCardViewModel viewModel;

  @override
  _ScratchDemoPageWidgetState createState() =>
      new _ScratchDemoPageWidgetState();
}

class _ScratchDemoPageWidgetState extends State<ScratchDemoPageWidget> {
  _ScratchDemoPageWidgetState({Key key});

  @override
  Widget build(BuildContext context) {
    SharedDrawerState navState = SharedDrawer.of(context);
    return ScopedModel(
        model: widget.viewModel,
        child: new Scaffold(
            appBar: AppBar(
              title: Text(navState.selectedItem?.title ?? "",
                  style: res.textStyleTitleDark),
              leading: IconButton(
                icon: Icon(
                    navState.shouldGoBack ? res.backIcon(context) : Icons.menu),
                onPressed: () {
                  if (navState.shouldGoBack) {
                    navState.navigator.currentState.pop();
                  } else {
                    RootScaffold.openDrawer(context);
                  }
                },
              ),
              actions: <Widget>[
                // action button
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    widget.viewModel.setDefaultState(true);
                  },
                )
              ],
            ),
            body: ScratchDemoView()));
  }
}

class ScratchDemoView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new ScopedModelDescendant<ScratchCardViewModel>(
        builder: (context, child, model) {
      return Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
            model.isCompleted
                ? Text("The card is now clear!", style: res.textStyleNormal)
                : Container(),
            ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(14.0)),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.indigo, width: 2.0)),
                  width: 250.0,
                  height: 250.0,
                  alignment: Alignment.center,
                  child: Stack(
                    children: <Widget>[
                      new ScratchCardWidget(
                          cover: FittedBox(
                              fit: BoxFit.cover,
                              child: Image.asset('images/itt_kapard_new.png')),
                          reveal: DecoratedBox(
                            decoration:
                                const BoxDecoration(color: Colors.indigo),
                            child: Center(
                                child: Text(
                              'Congratulations! You WON!',
                              style: res.textStyleNormalDark,
                            )),
                          ),
                          strokeWidth: 15.0,
                          updateRevealedInterval: 500,
                          completeThreshold: 0.99,
                          onComplete: () {
                            print('The card is now clear!');
                          },
                          onScratch: (percent) {
                            print(sprintf("onScratch: %.5f, completed: %s",
                                [percent, model.isCompleted]));
                          }),
                    ],
                  ),
                )),
            Text(
                "${sprintf("Scratched: %.5f%%", [
                  model.revealedPercent * 100
                ])}",
                style: res.textStyleNormal),
            Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Switch.adaptive(
                      value: model.debugMode,
                      onChanged: (value) => model.debugMode = value),
                  Text("Show snapshot", style: res.textStyleNormal),
                ])),
            new ScratchDebugView()
          ]));
    });
  }
}

class ScratchDebugView extends StatelessWidget {
  Widget build(BuildContext context) {
    return new ScopedModelDescendant<ScratchCardViewModel>(
        builder: (context, child, model) {
      if (!model.debugMode) return Container();
      if (model.capturedImage != null) {
        return Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
              /* color: Colors.pink,*/
              border: Border.all(color: Colors.pink, width: 2.0)),
          child: Stack(fit: StackFit.loose, children: <Widget>[
            Image.memory(model.capturedImage),
            //state.captureInProgress ? CircularProgressIndicator() : Container()
            model.captureInProgress
                ? Center(
                    child: CircularProgressIndicator(
                    strokeWidth: 6,
                    backgroundColor: Colors.pink,
                  ))
                : Container()
          ]),
          //margin: EdgeInsets.all(10)
        );
      }
      return Container();
    });
  }
}
