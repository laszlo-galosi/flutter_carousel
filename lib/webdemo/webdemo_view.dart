import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel/globals.dart';
import 'package:flutter_carousel/navigation/navigation_view_model.dart';
import 'package:flutter_carousel/resources.dart' as res;
import 'package:flutter_carousel/widget_demo/xwidgets/real_rich_text.dart';
import 'package:flutter_carousel/widget_demo/xwidgets/widget_adaptive.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:html/dom.dart' as dom;
import 'package:jaguar/serve/server.dart';
import 'package:jaguar_flutter_asset/jaguar_flutter_asset.dart';
import 'package:logging/logging.dart';
import 'package:mime/mime.dart';
import 'package:webview_flutter/webview_flutter.dart';

final int jsFiddleVersion = 63;
final String _imageChooserUrl = Uri.dataFromString("""
      <!DOCTYPE html>
<html>
    <title>filechooser</title>
<head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <title>File choose Demo</title>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <meta name="robots" content="noindex, nofollow">
    <meta name="googlebot" content="noindex, nofollow">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <script type="text/javascript" src="https://code.jquery.com/jquery-1.9.1.js"></script>
    <!-- <script type="text/javascript"
        src="https://raw.githubusercontent.com/danguer/blog-examples/master/js/base64-binary.js"></script-->
    <script type="text/javascript">
        function readURL(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function (e) {
                    \$('#blah').attr('src', e.target.result);
                }
                reader.readAsDataURL(input.files[0]);
            }
        }

        function readFileAsBase64(base64Data, mimeType) {
            if (base64Data) {
                console.log('readFile: ' + base64Data + ', mime: ' + mimeType);
                var blob = b64toBlob(base64Data, mimeType);
                console.log('blob:' + blob);
                var reader = new FileReader();
                reader.onload = function (e) {
                    \$('#blah').attr('src', e.target.result);
                }
                reader.readAsDataURL(blob);
            }
        }



        const b64toBlob = (b64Data, contentType = '', sliceSize = 512) => {
            const byteCharacters = atob(b64Data);
            const byteArrays = [];

            for (let offset = 0; offset < byteCharacters.length; offset += sliceSize) {
                const slice = byteCharacters.slice(offset, offset + sliceSize);

                const byteNumbers = new Array(slice.length);
                for (let i = 0; i < slice.length; i++) {
                    byteNumbers[i] = slice.charCodeAt(i);
                }

                const byteArray = new Uint8Array(byteNumbers);
                byteArrays.push(byteArray);
            }

            const blob = new Blob(byteArrays, { type: contentType });
            return blob;
        };

        function showImageUri(imgUri) {
            window.resolveLocalFileSystemURL(imgUri, function success(fileEntry) {
                console.log("got file: " + fileEntry.fullPath);
                console.log('file URI: ' + fileEntry.toInternalURL());
                \$('#blah').attr("src", fileEntry.toInternalURL());
            });
        }

        function postMessage(message) {
            console.log('postMessage:' + message);
            if (FlutterBridge == undefined) return;
            FlutterBridge.postMessage(message);
        }

        \$(document).ready(function () {
            \$("#imgInp").change(function () {
                readURL(this);
            });


            \$('#button').click(function (e) {
                \$('#imgInp').click();
                postMessage('choosefile');
                e.preventDefault();
            });
        });

    </script>
</head>

<body>
    <p><form id="form1">
        <input type='file' id="imgInp" style="display:none;" />
        <button id="button" type="submit">Pick an image...</button>
        <img style="width: 100%; height: auto;" id="blah" alt="Picked image file" src="#" alt="your image" />
    </form></p>
</body>

</html>
   """, mimeType: 'text/html').toString();

final String _homeUrl = 'https://pub.dartlang.org/packages/webview_flutter';
final String _homeUrl2 =
    'https://github.com/fluttercommunity/flutter_webview_plugin';
final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class WebDemoPageWidget extends StatelessWidget {
  WebDemoPageWidget();

  factory WebDemoPageWidget.forDesignTime() {
    return new WebDemoPageWidget();
  }

  @override
  Widget build(BuildContext context) {
    SharedDrawerState navState = SharedDrawer.of(context);
    return new Scaffold(
      appBar: AppBar(
        key: _scaffoldKey,
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
      body: new WebDemoWidget(),
    );
  }
}

class WebDemoWidget extends StatefulWidget {
  WebDemoWidget({Key key});

  @override
  _WebDemoWidgetState createState() => _WebDemoWidgetState();
}

class _WebDemoWidgetState extends State<WebDemoWidget> {
  Logger _logger = newLogger('_WebDemoWidgetState');

  String _initialUrl;

  String get initialUrl => _initialUrl;

  set initialUrl(String initialUrl) {
    setState(() {
//      webviewPlugin.hide();
      _initialUrl = initialUrl;
//      webviewPlugin.show();
    });
  }

  String _currentUrl;

  String get currentUrl => _currentUrl;

  set currentUrl(String currentUrl) {
    setState(() => _currentUrl = currentUrl);
  }

  WebViewController _controller;

  // ScrollController _scrollController = new ScrollController();

  GlobalKey _webViewKey = new GlobalKey(debugLabel: 'WebView');
  GlobalKey _listViewKey = new GlobalKey(debugLabel: 'ListView');

  double _webViewHeight = 100;

  double get webViewHeight => _webViewHeight;

  set webViewHeight(double webViewHeight) {
    setState(() => _webViewHeight = webViewHeight);
  }

  TextStyle get linkStyle => res.textStyleLabel.copyWith(
        color: Theme.of(context).accentColor,
        decoration: TextDecoration.underline,
        fontWeight: FontWeight.w500,
      );

  FlutterWebviewPlugin _webviewPlugin = new FlutterWebviewPlugin();

  FlutterWebviewPlugin get webviewPlugin => _webviewPlugin;

  Jaguar _server;

  @override
  void initState() {
    super.initState();
    _initJaguar();
    _initAssetUrl().then((url) {
      initialUrl = url;
      currentUrl = url;
    });
  }

  void _initJaguar() async {
    _server = Jaguar();
    _server.addRoute(serveFlutterAssets());
    await _server.serve(logRequests: true);
    _server.log.onRecord.listen((r) => _logger.fine(r));
  }

  Future<String> _initAssetUrl() async {
    return readAssetFile('assets/filechooser.html', context).then((content) {
      return Uri.dataFromString(content, mimeType: 'text/html').toString();
    });
  }

  Widget get _staticHtml => Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      alignment: AlignmentDirectional.center,
      child: Html(
        data: """
                <h4>This is a simple <a href='https://pub.dartlang.org/packages/flutter_html' class='external_open'>flutter_html</a> widget with static html content.</h4>
                 <br/>Tap on the urls to load them into the WebView, or tap on the <span class='open_icon'></span> icon to open in external browser via 
                 <a href="https://pub.dartlang.org/packages/url_launcher" class='external_open'>url_launcher.</a> (This icon demonstrates the WebView customRender feature.)                              
                 <ul>
                 <li>Bottom of the screen is a  <a href='https://pub.dartlang.org/packages/webview_flutter' class='external_open'>webview_flutter</a> widget.</li>
                 <li>Click on  <a href='http://localhost:8080/filechooser.html' class='external_open'>this example html</a></li> 
                 <li>Open a <span class='html_picker'>html file</span> to load into the WebView.</li>.          
                 </ul>                           
             """,
        renderNewlines: false,
        defaultTextStyle: res.textStyleLabel.copyWith(color: Colors.blueGrey),
        linkStyle: linkStyle,
        onLinkTap: (url) {
          loadUrl(url);
//          launchURL(url);
        },
        customRender: (node, children) {
          if (node is dom.Element) {
            final className = node.attributes['class'];
            final href = node.attributes['href'];
            switch (node.localName) {
              case "span":
              case "a":
                {
//                  _logger.fine(
//                      'customRender ${node.localName}, class: $className');
                  if ('external_open' == className) {
                    return RealRichText([
                      TextSpan(
                          text: '${node.innerHtml}',
                          style: linkStyle,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => loadUrl(href)),
                      ImageSpan(Image.asset('images/open_in_new.png').image,
                          margin: EdgeInsets.all(2.0),
                          imageWidth: 12.0,
                          imageHeight: 12.0,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => launchURL(href))
                    ]);
                  } else if ('open_icon' == className) {
                    return Image.asset('images/open_in_new.png', width: 14.0);
                  } else if ('html_picker' == className) {
                    return RealRichText([
                      TextSpan(
                          text: '${node.innerHtml}',
                          style: linkStyle,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              final file =
                                  await FilePicker.getFile(type: FileType.ANY);
                              final mimeType = lookupMimeType(file.path);
                              _logger.fine(
                                  'open: ${file.path}, mimeType: $mimeType');
                              if ('text/html' != mimeType) {
                                makeDialog(context,
                                    message:
                                        'Please select a htl file to show in webview.',
                                    scaffoldKey: _scaffoldKey);
                                return;
                              }
                              final htmlContent = await file.readAsString();
                              loadUrl(Uri.dataFromString(htmlContent,
                                      mimeType: mimeType)
                                  .toString());
                            }),
                    ]);
                  }
                }
            }
          }
        },
      ));

  Widget get _webView => WebView(
        key: _webViewKey,
        initialUrl: currentUrl,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (c) => _controller = c,
        navigationDelegate: (request) {
          _logger.fine('navigationDelegate: $request');
          loadUrl(request.url);
        },
        onPageFinished: (url) {
          final heightFromUrl = url.split('height:');
          var height = 200;
          if (heightFromUrl?.length == 2) {
            height = int.tryParse(heightFromUrl[1].trim());
          }
          webViewHeight = height ?? getSize(_listViewKey)?.height ?? 200;
          _logger
            ..fine('onPageFinished: $url')
            ..finer('urlHeight: $height')
            ..finer('webViewHeight: $webViewHeight');
        },
        javascriptChannels: Set.from([
          JavascriptChannel(
              name: 'FlutterBridge',
              onMessageReceived: (JavascriptMessage message) async {
                //This is where you receive message from
                //javascript code and handle in Flutter/Dart
                //like here, the message is just being printed
                //in Run/LogCat window of android studio
                _logger.fine('onMessageReceived ${message.message}');
                if (message.message == 'choosefile') {
                  _logger.fine(message.message);
                  final result = await pickFile();
                } else {
                  makeDialog(context,
                      message: message.message, scaffoldKey: _scaffoldKey);
                }
              })
        ]),
//        gestureRecognizers: Set()
//          ..add(Factory<TapGestureRecognizer>(() => TapGestureRecognizer())),
      );

  Widget get _webViewScaffold => WebviewScaffold(
        url: currentUrl,
        hidden: false,
        appBar: new AppBar(
          title: const Text('Widget webview'),
        ),
        initialChild: Center(child: XProgressIndicator()),
      );

  Future pickFile() async {
    final file = await FilePicker.getFile(type: FileType.IMAGE);
    _logger.fine('pickFile result: $file');
    final bytes = await file.readAsBytes();
    final fileData = base64.encode(bytes);
    final mimeType = lookupMimeType(file.path);
    final fileName = file.path.substring(file.path.lastIndexOf('/') + 1);
    var javascriptString =
        'readFileAsBase64("$fileData", "$mimeType", "$fileName")';
//    var queryString = "\$('#imgFileName').innerHtml=${file.path}";
    final result = await _controller.evaluateJavascript(javascriptString);
//    await _controller.evaluateJavascript(queryString);
    _logger
      ..fine('loadUrl ${file.path}')
      ..fine('mimeType: $mimeType')
      ..fine('evaluateJavascript: $javascriptString')
      ..fine('result: $result');
    return result;
  }

  Future showImageFile(File file) async {
    final bytes = await file.readAsBytes();
    var javascriptString = 'readFileAsBase64("${file.path}")';
    var jqueryString = "\$('#blah').attr('src', '${file.path}');";
    _logger
      ..fine('evaluateJavascript:$javascriptString')
      ..fine('jQueryString: $jqueryString');
    return _controller.evaluateJavascript(jqueryString);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
        key: _listViewKey,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(height: 16.0),
              _staticHtml,
//              _webView,
              Container(
                child: currentUrl?.contains('filechooser')
                    ? ListTile(
//                  leading: Icon(Icons.image, color: Colors.indigo),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 16.0),
                        title: XButton(
                          child: Text('Pick an Image',
                              style: res.textStyleMenu
                                  .copyWith(color: Colors.white)),
                          onPressed: () async => await pickFile(),
                        ),
                        subtitle: Text(
                            'The slected image displayed in the WebView below via the WebView JavaScriptChannel',
                            style: res.textStyleLabel
                                .copyWith(color: Colors.grey)),
                        onTap: () async {
                          final result = await pickFile();
                        },
                      )
                    : null,
              ),
              Container(
                  height: webViewHeight,
                  alignment: AlignmentDirectional.center,
                  child: _webView),
            ]));
  }

  @override
  void deactivate() {
    webviewPlugin?.close();
    _server?.close();
    super.deactivate();
  }

  @override
  void dispose() {
    _webviewPlugin.dispose();
    super.dispose();
  }

  void loadUrl(String url) async {
    final size = getSize(_listViewKey) ??
        Size(MediaQuery.of(context).size.width, webViewHeight);
    final rect = new Rect.fromLTWH(0.0, size.height, size.width, size.height);
    _logger.finest('loadUrl: $url');
    _controller?.loadUrl(url);
    currentUrl = url;
//    await webviewPlugin
//      ..close()
//      ..launch(url, rect: rect);
//    webviewPlugin.resize(rect);
  }

  Future<String> readAssetFile(String path, BuildContext context) async {
    return await DefaultAssetBundle.of(context).loadString(path);
  }
}
