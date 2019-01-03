import 'package:flutter/material.dart';

import './home_page_view.dart';

class HomePage extends StatefulWidget {
  final String title;

  HomePage({Key key, this.title}) : super(key: key);

  @override
  HomePageView createState() => new HomePageView();
}
