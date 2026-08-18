import js.lib.Promise;
import js.Browser.*;
import js.html.*;
import jsasync.IJSAsync;
import jsasync.JSAsyncTools.jsawait;
import jsasync.JSAsyncTools;

typedef Rect = {
    var x: Float;
    var y: Float;
    var width: Float;
    var height: Float;
}
typedef WindowObject = {
    var id: Int;
    var app: String;
    var title: String;
    var el: js.html.DivElement;
    var rect: Rect;
    var isMaximized: Bool;
    var isMinimized: Bool;
    var restoreRect: Rect;
    var zIndex: Int;
}
typedef WindowState = {
    var window: Array<WindowObject>;
    var nextId: Int;
    var activeId: String;
    var maxZIndex: Int;
    var isDragging: Bool;
}


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
        "wechat_helper_call_1" => [
            "Manager House: <br>Help!!",
            "马经理: <br>救命！",
            "马经理: <br>救命！",
        ],
        "wechat_helper_call_2" => [
            "Manager House: <br>These horses are crazy!",
            "马经理：<br>这些马疯了！",
            "马经理：<br>這些馬瘋了！",
        ],
        "wechat_helper_call_3" => [
            "Manager House: <br>You must check the surveillance!",
            "马经理：<br>你一定要看一下监控！",
            "马经理：<br>你一定要看一下監控！",
        ],
        "wechat_helper_call_4" => [
            "Manager House: <br>The surveillance I sent you!",
            "马经理：<br>监控我发给你了！",
            "马经理：<br>監控我發給你了！",
        ],
        "wechat_helper_call_5" => [
            "Manager House: <br>[Video]",
            "马经理：<br>视频",
            "马经理：<br>視頻",
        ]
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
    @:jsasync
    public static function showToast(message: String, duration: Int = 3000) {
        final toast = cast(document.createElement("div"), DivElement);
        toast.innerHTML = '
<img src="assets/images/icons/wechat.png" style="width: 1.5cqi; height: 1.5cqi; margin-right: 0.3cqi;">
${message}
        ';
        toast.classList.add("toast");
        toast.style.opacity = "0";
        toast.style.transform = "translateY(20%)";
        ROOT.appendChild(toast);
        jsawait(sleep(100));
        toast.style.opacity = "1";
        toast.style.transform = "translateY(0)";
        window.setTimeout(() -> {
            toast.style.opacity = "0";
            toast.style.transform = "translateY(20%)";
            window.setTimeout(() -> {
                toast.remove();
            }, 300);
        }, duration);
    }
    public static function clamp(value: Float, min: Float, max: Float): Float {
        return Math.max(min, Math.min(max, value));
    }

    public static function createWindow(app: String, title: String, options: Dynamic): Int {

    }
}
