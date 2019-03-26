import 'package:flutter/material.dart';
import 'package:flutter_carousel/carousel_widget/carousel_widget_view.dart';
import 'package:flutter_carousel/form_demo/form_demo_view.dart';
import 'package:flutter_carousel/form_demo/form_demo_view_model.dart';
import 'package:flutter_carousel/home_page/home_page_view.dart';
import 'package:flutter_carousel/infinite_list/infinite_list_demo_view_model.dart';
import 'package:flutter_carousel/infinite_list/infinite_list_view.dart';
import 'package:flutter_carousel/navigation/navigation_view_model.dart';
import 'package:flutter_carousel/resources.dart' as res;
import 'package:flutter_carousel/scratch_demo/scratch_card_view_model.dart';
import 'package:flutter_carousel/scratch_demo/scratch_demo_view.dart';
import 'package:flutter_carousel/services/napisorsjegy_api.dart';
import 'package:flutter_carousel/shopping_cart/shopping_cart_view.dart';
import 'package:flutter_carousel/widget_demo/widget_demo_view.dart';

class NavigationDrawerWidget extends StatelessWidget {
  NavigationDrawerWidget({Key key});

  @override
  Widget build(BuildContext context) {
    final rootDrawerState = RootDrawer.of(context);
    final state = SharedDrawer.of(context);
//    state.setDrawerControllerState(rootDrawerState);
    return Drawer(
      child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: state.itemCount + 1,
          itemBuilder: (BuildContext ctx, int index) {
            NavigationItem item = state.getItemAt(index - 1);
            if (index == 0)
              return _drawerHeader(context);
            else
              return new ListTile(
                title: new Text(item?.title ?? "Title is null.",
                    style: res.textStyleMenu),
                leading: item?.icon ?? null,
                onTap: () {
                  state.setSelectedItemIndex(index - 1);
                  if (item.navigationCallback != null &&
                      state.navigator != null) {
                    item.navigationCallback(state, rootDrawerState);
                  }
                },
              );
          }),
    );
  }

  Widget _drawerHeader(BuildContext context) => Container(
        padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
        height: MediaQuery.of(context).padding.top + 56.0,
        alignment: AlignmentDirectional.centerStart,
        /*child: Container(*/
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              FlutterLogo(size: 32.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Text("Flutter Demo", style: res.textStyleTitleDark),
              ),
            ]),

//    ),
        decoration: new BoxDecoration(color: Colors.indigo),
      );
}

class FadeInSlideOutRoute<T> extends MaterialPageRoute<T> {
  FadeInSlideOutRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.isInitialRoute) return child;
    // Fades between routes. (If you don't want any animation,
    // just return child.)
    if (animation.status == AnimationStatus.reverse)
      return super
          .buildTransitions(context, animation, secondaryAnimation, child);
    return FadeTransition(opacity: animation, child: child);
  }
}

Widget getPageForRouteName(String routeName) {
  switch (routeName) {
    case '/':
      return MainMenuWidget();
    case '/carousel':
      return CarouselPageWidget();
    case '/shopping':
      return ShoppingPageWidget();
    case '/widget_demo':
      return new WidgetDemoPage(viewModel: new WidgetDemoPageViewModel());
    case "/scratch":
      return new ScratchDemoPageWidget(
        viewModel: new ScratchCardViewModel(),
      );
    case "/infinite_list":
      return new InfiniteListDemoPageWidget(
          viewModel: InfiniteListDemoViewModel(api: NapisorsjegyApiService()));
    case "/form_demo":
      return new FormDemoPageWidget(viewModel: FormDemoViewModel());
    default:
      return Center(
          child: Container(
              width: double.infinity,
              padding: res.edgeInsetsItemH16V8,
              child: Text(
                "Route '$routeName' not yet implemented.",
                style: res.textStyleNormal,
                textAlign: TextAlign.center,
              )));
  }
}
