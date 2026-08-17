import js.lib.Promise;
import js.Browser.*;
import js.html.*;
import jsasync.IJSAsync;
import jsasync.JSAsyncTools;

class Util implements IJSAsync {
    static final LANGUAGE: Map<String, Array<String>> = [
        "lang_name" => [
            "English",
            "简体中文",
            "繁體中文",
        ],
        "click_me" => [
            "Click me!",
            "点我开始！",
            "點我開始！",
        ],
        "start_button" => [
            "Start",
            "开始",
            "開始",
        ],
        "my_computer" => [
            "My Computer",
            "我的电脑",
            "我的電腦",
        ],
        "ie" => [
            "Internet Explorer",
            "Internet Explorer",
            "Internet Explorer",
        ],
        "recycle" => [
            "Recycle Bin",
            "回收站",
            "資源回收筒",
        ],
        "wechat" => [
            "WeChat",
            "微信",
            "微信",
        ],
        "settings" => [
            "Settings",
            "设置",
            "設定",
        ],
    ];
    public static final ROOT = cast(document.getElementById("main_box"), DivElement);
    public static final MENU_BAR = cast(document.createElement("div"), DivElement);
    public static final SCREEN = cast(document.createElement("div"), DivElement);
    public static function sleep(ms: Int): Promise<jsasync.Nothing> {
        return new Promise<jsasync.Nothing>((resolve, _) -> {
            window.setTimeout(() -> {
                resolve(null);
            }, ms);
        });
    }
    public static function getLangValue(name: String): String {
        final index = Std.parseInt(window.localStorage.getItem("judgment-of-ash-config-language") ?? "0") ?? 0;
        return LANGUAGE[name][index];
    }
}
