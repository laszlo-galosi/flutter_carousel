import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel/globals.dart';
import 'package:flutter_carousel/infinite_list/infinite_list_demo_view_model.dart';
import 'package:flutter_carousel/infinite_list/message_view.dart';
import 'package:flutter_carousel/models/winner.dart';
import 'package:flutter_carousel/navigation/navigation_view_model.dart';
import 'package:flutter_carousel/resources.dart' as res;
import 'package:flutter_carousel/widget_demo/xwidgets/widget_adaptive.dart';
import 'package:logging/logging.dart';
import 'package:scoped_model/scoped_model.dart';

class InfiniteListDemoPageWidget extends StatefulWidget {
  final InfiniteListDemoViewModel viewModel;

  InfiniteListDemoPageWidget({Key key, @required this.viewModel})
      : super(key: key);

  @override
  _InfiniteListDemoPageWidgetState createState() =>
      new _InfiniteListDemoPageWidgetState();
}

class _InfiniteListDemoPageWidgetState extends State<InfiniteListDemoPageWidget>
    with SingleTickerProviderStateMixin {
  int _currentOffset = 0;

  int get currentPage => _currentOffset;

  set currentPage(int page) {
    setState(() {
      _currentOffset = page;
    });
  }

  @override
  void initState() {
    super.initState();
    initLogger("_InfiniteListDemoPageWidgetState");
    //_loadData();
  }

  @override
  Widget build(BuildContext context) {
    SharedDrawerState navState = SharedDrawer.of(context);
    return new Scaffold(
      appBar: AppBar(
        title: Text(navState.selectedItem?.title ?? "",
            style: res.textStyleTitleDark),
        leading: IconButton(
          icon:
              Icon(navState.shouldGoBack ? res.backIcon(context) : Icons.menu),
          onPressed: () {
            if (navState.shouldGoBack) {
              navState.navigator.currentState.pop();
            } else {
              RootScaffold.openDrawer(context);
            }
          },
        ),
      ),
      body: ScopedModel<InfiniteListDemoViewModel>(
          model: widget.viewModel, child: WinnerListWidget()),
    );
  }
}

class WinnerListWidget extends StatefulWidget {
  WinnerListWidget({Key key});

  @override
  WinnerListWidgetState createState() => new WinnerListWidgetState();
}

class WinnerListWidgetState extends State<WinnerListWidget> {
  ScrollController _scrollController = new ScrollController();

  int _currentPage = 0;
  int _pageSize = 10;
  int _lastResultSize = -1;

  bool _isLoading = false;

  List<Winner> _items = [];
  List<Winner> _snapshot = [];

  static final Logger _logger = newLogger("WinnerListWidgetState");

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadMore();
      }
    });
  }

  void _loadMore() async {
    if (!_isLoading && _lastResultSize > 0) {
      setState(() {
        _isLoading = true;
        _currentPage++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _logger.fine("build items ${_items.length}");
    return ScopedModelDescendant<InfiniteListDemoViewModel>(
        builder: (context, child, model) {
      return FutureBuilder<List<Winner>>(
          future: model.loadPage(page: _currentPage, limit: _pageSize),
          builder: (_, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return ErrorPageWidget(
                message: Text("Error: ${snapshot.error}",
                    style: res.textStyleNormal),
                action: () async {
                  setState(() {
                    _currentPage = 0;
                    _isLoading = true;
                  });
                },
              );
            } else if (snapshot.hasData && snapshot.data != null) {
              _lastResultSize = snapshot.data.length;
              if (snapshot.data.isEmpty) {
                double offsetFromBottom =
                    _scrollController.position.maxScrollExtent -
                        _scrollController.position.pixels;
                _logger.fine("offsetFromBottom: $offsetFromBottom");
                double edge = 50.0;
                if (offsetFromBottom < edge) {
                  _scrollController.animateTo(
                      _scrollController.offset - (edge - offsetFromBottom),
                      duration: new Duration(milliseconds: 500),
                      curve: Curves.easeOut);
                }
              } else {
                _logger.fine(() =>
                    "\n${snapshot.data.map((w) => "${w.toString()}").join('\n')}");
                _items.addAll(snapshot.data);
                (snapshot.data as List<Winner>).clear();
                _logger.fine("snapshot data length $_lastResultSize");
                _logger.finer(() =>
                    "\n${_snapshot.map((w) => "${_items.indexOf(w)}. ${w.toString()}").join('\n')}");
              }
            }
            if (_items.isEmpty) {
              return ErrorPageWidget(
                  message: Text("Nincs megjeleníthető adat",
                      style: res.textStyleNormal));
            }
            return ListView.builder(
              itemCount: _items.length + 1,
              controller: _scrollController,
              itemBuilder: (BuildContext ctx, int index) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                    _isLoading = true;
                    break;
                  default:
                    _isLoading = false;
                }
                if (index == _items.length) {
                  return new Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Center(
                      child: new Opacity(
                        opacity: _isLoading ? 1.0 : 0.0,
                        child: new XProgressIndicator(),
                      ),
                    ),
                  );
                } else {
                  return new WinnerListItemWidget(winner: _items[index]);
                }
              },
            );
          });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class WinnerListItemWidget extends StatelessWidget {
  final Winner winner;

  const WinnerListItemWidget({@required this.winner});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(right: 16.0),
        width: double.infinity,
        decoration: new BoxDecoration(border: res.borderBottom1),
        child: Row(children: <Widget>[
          Image.network(
            winner.prizeImage,
            scale: 0.1,
            fit: BoxFit.cover,
            width: 100.0,
          ),
          new Expanded(
              flex: 10,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  children: [
                    Text("${winner.id} - ${winner.name ?? ""}",
                        style: res.textStyleNormal),
                    Text(winner.prizeName ?? "", style: res.textStyleMenu),
                    Text(winner.date ?? "", style: res.textStyleLabel),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
              )),
        ]));
  }
}
