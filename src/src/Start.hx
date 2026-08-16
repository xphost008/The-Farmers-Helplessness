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
        img.src = "assets/images/wallpaper/xp.jpg";
        img.classList.add("fullscreen-image");
        img.style.opacity = "0";
        img.style.transition = "opacity 7s ease";
        ROOT.appendChild(img);
        final start_div = cast(document.createElement("div"), DivElement);
        start_div.classList.add("fullscreen-image");
        start_div.style.opacity = "0";
        start_div.style.transition = "opacity 7s ease";
        start_div.style.zIndex = "10";
        ROOT.appendChild(start_div);
        final menu_bar = cast(document.createElement("div"), DivElement);
        menu_bar.style.position = "absolute";
        menu_bar.style.bottom = "0";
        menu_bar.style.left = "0";
        menu_bar.style.width = "100cqi";
        menu_bar.style.height = "5cqb";
        menu_bar.style.display = "flex";
        menu_bar.style.alignItems = "center";
        menu_bar.style.background = "linear-gradient(to bottom, rgb(99, 141, 210), rgb(65, 90, 208) 70%, rgb(99, 141, 210))";
        start_div.appendChild(menu_bar);
        final start_button = cast(document.createElement("button"), ButtonElement);
        start_button.style.display = "flex";
        start_button.style.alignItems = "center";
        start_button.style.gap = "1cqi";
        start_button.style.background = "linear-gradient(to bottom, rgb(90, 141, 73), rgb(95, 154, 74) 70%, rgb(90, 141, 73))";
        start_button.style.height = "100%";
        start_button.style.width = "auto";
        start_button.style.borderTopRightRadius = "99999px";
        start_button.style.borderBottomRightRadius = "99999px";
        start_button.style.padding = "0 1cqi";
        start_button.innerHTML = '
        <img src="assets/images/icon/xpicon.png" style="height: 3cqb">
        <span style="font-size: 2.5cqb; color: white;">${getLangValue("start_button")}</span>
        ';
        menu_bar.appendChild(start_button);
        MyScreen.MENU_BAR.style.display = "flex";
        MyScreen.MENU_BAR.style.alignItems = "center";
        MyScreen.MENU_BAR.style.height = "100%";
        MyScreen.MENU_BAR.style.flex = "1";
        menu_bar.appendChild(MyScreen.MENU_BAR);
        final time = cast(document.createElement("div"), DivElement);
        time.style.display = "flex";
        time.style.alignItems = "center";
        time.style.justifyContent = "center";
        time.style.height = "100%";
        time.style.width = "auto";
        time.style.padding = "0 1cqi";
        time.style.color = "white";
        time.style.background = "linear-gradient(to bottom, rgb(105, 180, 237), rgb(82, 138, 224) 80%, rgb(105, 180, 237))";
        final date = Date.now();
        final hours = date.getHours();
        final minutes = date.getMinutes();
        time.style.fontSize = "2cqb";
        time.innerText = '${hours < 10 ? "0" : ""}${hours}:${minutes < 10 ? "0" : ""}${minutes}';
        menu_bar.appendChild(time);
        jsawait(sleep(100));
        img.style.opacity = "1";
        start_div.style.opacity = "1";
        final xppoweron = new Audio("assets/sounds/xppoweron.wav");
        xppoweron.play();
    }
}
