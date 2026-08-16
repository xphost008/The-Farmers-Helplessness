import js.Browser.*;
import jsasync.IJSAsync;
import jsasync.JSAsyncTools;

import front.*;

class Main implements IJSAsync {
    static function main() {
        var hello = document.createElement("div");
        hello.innerText = "Hello World!!";
        hello.style.color = "red";
        var main = document.getElementById("main_box");
        main.appendChild(hello);
        Main.hello();
    }
    @:jsasync
    static function hello() {
        JSAsyncTools.jsawait(Util.sleep(5000));
        JSAsyncTools.jsawait(End.setFullscreen(true));
        JSAsyncTools.jsawait(Util.sleep(5000));
        JSAsyncTools.jsawait(End.setFullscreen(false));
        JSAsyncTools.jsawait(Util.sleep(5000));
        JSAsyncTools.jsawait(End.exit());
        trace("Hello World!!");
    }
}
