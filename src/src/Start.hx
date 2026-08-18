import jsasync.JSAsyncTools.jsawait;
import jsasync.IJSAsync;
import jsasync.JSAsync.jsasync;
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
        menu_bar.classList.add("menu-bar");
        start_div.appendChild(menu_bar);
        final start_button = cast(document.createElement("button"), ButtonElement);
        start_button.classList.add("start-button");
        start_button.innerHTML = '
        <img src="assets/images/icons/xpicon.png" style="height: 3cqb">
        <span style="font-size: 2.5cqb; color: white;">${getLangValue("start_button")}</span>
        ';
        menu_bar.appendChild(start_button);
        MENU_BAR.style.display = "flex";
        MENU_BAR.style.alignItems = "center";
        MENU_BAR.style.height = "100%";
        MENU_BAR.style.flex = "1";
        menu_bar.appendChild(MENU_BAR);
        final time = cast(document.createElement("div"), DivElement);
        time.classList.add("time");
        final date = Date.now();
        final hours = date.getHours();
        final minutes = date.getMinutes();
        time.innerText = '${hours < 10 ? "0" : ""}${hours}:${minutes < 10 ? "0" : ""}${minutes}';
        menu_bar.appendChild(time);
        SCREEN.classList.add("screen");
        final MyComputerButton = cast(document.createElement("button"), ButtonElement);
        MyComputerButton.classList.add("desktop-icon-button");
        MyComputerButton.innerHTML = '
        <img src="assets/images/icons/computer.png" style="height: 8cqb;">
        <span style="font-size: 2cqb; color: white;">${getLangValue("my_computer")}</span>
        ';
        final InternetExplorerButton = cast(document.createElement("button"), ButtonElement);
        InternetExplorerButton.classList.add("desktop-icon-button");
        InternetExplorerButton.innerHTML = '
        <img src="assets/images/icons/ie.png" style="height: 8cqb;">
        <span style="font-size: 2cqb; color: white;">${getLangValue("ie")}</span>
        ';
        final RecycleButton = cast(document.createElement("button"), ButtonElement);
        RecycleButton.classList.add("desktop-icon-button");
        RecycleButton.innerHTML = '
        <img src="assets/images/icons/recycle.png" style="height: 8cqb;">
        <span style="font-size: 2cqb; color: white;">${getLangValue("recycle")}</span>
        ';
        final WeChatButton = cast(document.createElement("button"), ButtonElement);
        WeChatButton.classList.add("desktop-icon-button");
        WeChatButton.innerHTML = '
        <img src="assets/images/icons/wechat.png" style="height: 8cqb;">
        <span style="font-size: 2cqb; color: white;">${getLangValue("wechat")}</span>
        ';
        final SettingsButton = cast(document.createElement("button"), ButtonElement);
        SettingsButton.classList.add("desktop-icon-button");
        SettingsButton.innerHTML = '
        <img src="assets/images/icons/settings.png" style="height: 8cqb;">
        <span style="font-size: 2cqb; color: white;">${getLangValue("settings")}</span>
        ';
        SCREEN.appendChild(MyComputerButton);
        SCREEN.appendChild(InternetExplorerButton);
        SCREEN.appendChild(RecycleButton);
        SCREEN.appendChild(WeChatButton);
        SCREEN.appendChild(SettingsButton);
        MyComputerButton.addEventListener("dblclick", jsasync(() -> {
        }));
        InternetExplorerButton.addEventListener("dblclick", jsasync(() -> {
        }));
        RecycleButton.addEventListener("dblclick", jsasync(() -> {
        }));
        WeChatButton.addEventListener("dblclick", jsasync(() -> {
        }));
        SettingsButton.addEventListener("dblclick", jsasync(() -> {

        }));
        start_div.appendChild(SCREEN);
        jsawait(sleep(100));
        img.style.opacity = "1";
        start_div.style.opacity = "1";
        window.setInterval(() -> {
            final date = Date.now();
            final hours = date.getHours();
            final minutes = date.getMinutes();
            time.innerText = '${hours < 10 ? "0" : ""}${hours}:${minutes < 10 ? "0" : ""}${minutes}';
        }, 1000);
        jsawait(sleep(7000));
        jsawait(play());
    }
    @:jsasync
    static function play() {
        //final xppoweron = new Audio("assets/sounds/xppoweron.wav");
        //xppoweron.play();
        jsawait(sleep(2000));
        showToast('${getLangValue("wechat_helper_call_1")}');
        jsawait(sleep(3600));
        showToast('${getLangValue("wechat_helper_call_2")}');
        jsawait(sleep(3600));
        showToast('${getLangValue("wechat_helper_call_3")}');
        jsawait(sleep(3600));
        showToast('${getLangValue("wechat_helper_call_4")}');
        jsawait(sleep(3600));
        showToast('${getLangValue("wechat_helper_call_5")}');
    }
}
