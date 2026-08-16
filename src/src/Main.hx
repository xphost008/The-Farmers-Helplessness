import js.Browser.*;
import jsasync.IJSAsync;
import jsasync.JSAsyncTools.jsawait;
import jsasync.JSAsync.jsasync;
import Util.*;
import js.html.*;

class Main implements IJSAsync {
    static function main() {
        Main.run();
    }
    @:jsasync
    static function run() {
        final img = cast(document.createElement("img"), ImageElement);
        img.style.position = "absolute";
        img.style.top = "0";
        img.style.left = "0";
        img.style.bottom = "0";
        img.style.right = "0";
        img.style.width = "20cqi";
        img.style.height = "auto";
        img.style.margin = "auto";
        img.style.opacity = "0";
        img.style.transition = "opacity 1.5s ease";
        img.style.transform = "scale(0.9)";
        ROOT.appendChild(img);
        img.src = "assets/images/candyshark.png";
        img.style.animation = "";
        jsawait(sleep(100));
        img.style.opacity = "1";
        img.style.animation = "reduce 4s ease";
        jsawait(sleep(4000));
        img.style.opacity = "0";
        jsawait(sleep(1500));
        img.src = "assets/images/haxe-logo.png";
        img.style.animation = "";
        jsawait(sleep(100));
        img.style.opacity = "1";
        img.style.animation = "reduce 4s ease";
        jsawait(sleep(4000));
        img.style.opacity = "0";
        jsawait(sleep(1500));
        ROOT.innerHTML = "";
        final button = cast(document.createElement("button"), ButtonElement);
        button.style.position = "absolute";
        button.style.top = "0";
        button.style.left = "0";
        button.style.bottom = "0";
        button.style.right = "0";
        button.style.margin = "auto";
        button.style.fontSize = "3cqi";
        button.style.backgroundColor = "transparent";
        button.style.border = "none";
        button.style.outline = "none";
        button.style.color = "white";
        button.style.animation = "scalebig 3s ease infinite";
        button.style.transition = "transform 0.5s ease, opacity 2s ease";
        button.innerText = "点我开始！";
        button.addEventListener("click", jsasync(() -> {
            button.style.animation = "";
            jsawait(sleep(100));
            button.style.transform = "scale(5)";
            jsawait(sleep(3000));
            button.style.opacity = "0";
            jsawait(sleep(2000));
            jsawait(Start.run());
        }));
        ROOT.appendChild(button);
    }
}
