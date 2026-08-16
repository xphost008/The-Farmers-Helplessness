import jsasync.JSAsyncTools.jsawait;
import jsasync.IJSAsync;
import Util.*;
import js.Browser.*;
import js.html.*;

class Start implements IJSAsync {
    @:jsasync
    public static function run() {
        ROOT.innerHTML = "";
        final img = cast(document.createElement("img"), ImageElement);
        final xppoweron = new Audio("assets/sounds/xppoweron.wav");
        xppoweron.play();
        img.src = "assets/images/wallpaper/xp.jpg";
        img.style.position = "absolute";
        img.style.top = "0";
        img.style.left = "0";
        img.style.width = "100cqi";
        img.style.height = "100cqb";
        img.style.opacity = "0";
        img.style.transition = "opacity 7s ease";
        ROOT.appendChild(img);
        jsawait(sleep(100));
        img.style.opacity = "1";
    }
}
