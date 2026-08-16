package front;

import js.Browser.*;
import jsasync.JSAsyncTools;
import js.lib.Promise;
import jsasync.Nothing;

@:native("document")
extern class Document {
    public static var exitFullscreen: Dynamic;
    public static var webkitExitFullscreen: Dynamic;
    public static var mozExitFullScreen: Dynamic;
    public static var msExitFullscreen: Dynamic;

    public static var fullscreenElement: Dynamic;
    public static var webkitFullscreenElement: Dynamic;
    public static var mozFullScreenElement: Dynamic;
    public static var msFullscreenElement: Dynamic;
}

@:build(jsasync.JSAsync.build())
class End {
    @:jsasync
    static function requestFullscreen(element: Dynamic): Promise<Nothing>  {
        if (element.requestFullscreen) {
            JSAsyncTools.jsawait(element.requestFullscreen());
        } else if (element.webkitRequestFullscreen) {
            JSAsyncTools.jsawait(element.webkitRequestFullscreen());
        } else if (element.mozRequestFullScreen) {
            JSAsyncTools.jsawait(element.mozRequestFullScreen());
        } else if (element.msRequestFullscreen) {
            JSAsyncTools.jsawait(element.msRequestFullscreen());
        }
    }

    @:jsasync
    static function exitFullscreen(): Promise<Nothing> {
        if (Document.exitFullscreen) {
            JSAsyncTools.jsawait(Document.exitFullscreen());
        } else if (Document.webkitExitFullscreen) {
            JSAsyncTools.jsawait(Document.webkitExitFullscreen());
        } else if (Document.mozExitFullScreen) {
            JSAsyncTools.jsawait(Document.mozExitFullScreen());
        } else if (Document.msExitFullscreen) {
            JSAsyncTools.jsawait(Document.msExitFullscreen());
        }
    }

    static function isFullscreen(): Bool {
        return
            Document.fullscreenElement != null ||
            Document.webkitFullscreenElement != null ||
            Document.mozFullScreenElement != null ||
            Document.msFullscreenElement != null;
    }

    @:jsasync
    public static function setFullscreen(?isfullscreen: Bool): Promise<Nothing> {
        if (isfullscreen != null) {
            if (isfullscreen) {
                JSAsyncTools.jsawait(requestFullscreen(document.documentElement));
            } else {
                JSAsyncTools.jsawait(exitFullscreen());
            }
        } else {
            if (isFullscreen()) {
                JSAsyncTools.jsawait(exitFullscreen());
            } else {
                JSAsyncTools.jsawait(requestFullscreen(document.documentElement));
            }
        }
    }

    @:jsasync
    public static function exit(): Promise<Nothing> {
        alert("Please exit by manual!");
    }
}
