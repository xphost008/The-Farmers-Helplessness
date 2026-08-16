import js.lib.Promise;
import js.Browser.*;
import jsasync.IJSAsync;
import jsasync.JSAsyncTools;

class Util implements IJSAsync {
    public static function sleep(ms: Int): Promise<jsasync.Nothing> {
        return new Promise<jsasync.Nothing>((resolve, _) -> {
            window.setTimeout(() -> {
                resolve(null);
            }, ms);
        });
    }
}
