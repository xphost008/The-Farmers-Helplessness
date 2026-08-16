import js.lib.Promise;
import js.Browser.*;
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
        ]
    ];
    public static final ROOT = cast(document.getElementById("main_box"), js.html.DivElement);
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
