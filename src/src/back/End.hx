package back;

import jsasync.JSAsyncTools;
import js.lib.Promise;

@:native("window.__TAURI__.window")
extern class TauriWindowAPI {
    public static function getCurrentWindow(): Dynamic;
}

@:build(jsasync.JSAsync.build())
class End {
    static final currentWindow = TauriWindowAPI.getCurrentWindow();
    @:jsasync
    public static function setFullscreen(?isfullscreen: Bool): Promise<jsasync.Nothing> {
        if(isfullscreen != null) {
            JSAsyncTools.jsawait(currentWindow.setFullscreen(isfullscreen));
        } else {
            JSAsyncTools.jsawait(currentWindow.setFullscreen(currentWindow.isFullscreen()));
        }
    }
    @:jsasync
    public static function exit(): Promise<jsasync.Nothing>  {
        JSAsyncTools.jsawait(TauriWindowAPI.getCurrentWindow().close());
    }
}
