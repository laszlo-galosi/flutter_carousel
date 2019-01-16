import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_carousel/navigation/navigation_view_model.dart';
import 'package:flutter_carousel/resources.dart' as res;
import 'package:flutter_carousel/scratch_demo/scratch_card_view_model.dart';
import 'package:flutter_carousel/scratch_demo/scratch_card_widget.dart';
import 'package:sprintf/sprintf.dart';

class ScratchDemoPageWidget extends StatefulWidget {
  ScratchDemoPageWidget();

  factory ScratchDemoPageWidget.forDesignTime() {
    return new ScratchDemoPageWidget();
  }

  @override
  _ScratchDemoPageWidgetState createState() =>
      new _ScratchDemoPageWidgetState();
}

class _ScratchDemoPageWidgetState extends State<ScratchDemoPageWidget> {
  @override
  Widget build(BuildContext context) {
    SharedDrawerState navState = SharedDrawer.of(context);
    return ScratchCardBindingWidget(
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
                    ScratchCardBindingWidgetState state =
                        ScratchCardBindingWidget.of(context);
                    state.revealPercent = 0.0;
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
    ScratchCardBindingWidgetState state = ScratchCardBindingWidget.of(context);
    return Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
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
                          decoration: const BoxDecoration(color: Colors.indigo),
                          child: Center(
                              child: Text(
                            'Congratulations! You WON!',
                            style: res.textStyleNormalDark,
                          )),
                        ),
                        strokeWidth: 15.0,
                        finishPercent: 0,
                        onComplete: () => print('The card is now clear!'),
                        onScratch: (percent) {
                          print(sprintf("onScratch: %.5f", [percent]));
                        }),
                  ],
                ),
              )),
          Text("${sprintf("Scratched: %.5f%%", [state.revealPercent * 100])}",
              style: res.textStyleNormal),
          Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Switch.adaptive(
                    value: state.debugMode,
                    onChanged: (value) => state.debugMode = value),
                Text("Show snapshot", style: res.textStyleNormal),
              ])),
          new ScratchDebugView()
        ]));
  }
}

class ScratchDebugView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScratchCardBindingWidgetState state = ScratchCardBindingWidget.of(context);
    if (!state.debugMode) return Container();
    if (state.capturedImage != null) {
      return Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
            /* color: Colors.pink,*/
            border: Border.all(color: Colors.pink, width: 2.0)),
        child: Stack(fit: StackFit.loose, children: <Widget>[
          Image.memory(state.capturedImage),
          //state.captureInProgress ? CircularProgressIndicator() : Container()
          state.captureInProgress
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
  }
}
