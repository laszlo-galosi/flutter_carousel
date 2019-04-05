package hu.extremenet.fluttercarousel

import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import android.view.WindowManager;
import android.view.ViewTreeObserver.OnGlobalLayoutListener
import com.flutter_webview_plugin.FlutterWebviewPlugin

class MainActivity : FlutterActivity(), OnGlobalLayoutListener {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        //make transparent status bar
        getWindow().setStatusBarColor(0x00000000)
        GeneratedPluginRegistrant.registerWith(this@MainActivity)
//        FlutterWebviewPlugin.registerWith(this.registrarFor("com.flutter_webview_plugin.FlutterWebviewPlugin"))

        getFlutterView().viewTreeObserver.addOnGlobalLayoutListener(this)
    }

    override fun onGlobalLayout() {
        //Remove full screen flag after load
        getFlutterView().viewTreeObserver.removeOnGlobalLayoutListener(this)
        getWindow().clearFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN)
    }

}
