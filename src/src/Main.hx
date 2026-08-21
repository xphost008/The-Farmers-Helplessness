import js.Browser.*;
import jsasync.IJSAsync;
import jsasync.JSAsyncTools.jsawait;
import jsasync.JSAsync.jsasync;
import Util.*;
import js.html.*;

class Main implements IJSAsync {
	static function main() {
		run();
	}

	@:jsasync
	static function run() {
		final img = cast(document.createElement("img"), ImageElement);
		img.classList.add("center");
		img.style.width = "20cqi";
		img.style.height = "auto";
		img.style.opacity = "0";
		img.style.transition = "opacity 1s ease";
		img.style.transform = "scale(0.9)";
		ROOT.appendChild(img);
		img.src = "assets/images/candyshark.png";
		img.style.animation = "";
		jsawait(sleep(100));
		img.style.opacity = "1";
		img.style.animation = "reduce 4s ease";
		jsawait(sleep(4000));
		img.style.opacity = "0";
		jsawait(sleep(1000));
		img.src = "assets/images/haxe-logo.png";
		img.style.animation = "";
		jsawait(sleep(100));
		img.style.opacity = "1";
		img.style.animation = "reduce 4s ease";
		jsawait(sleep(4000));
		img.style.opacity = "0";
		jsawait(sleep(1000));
		ROOT.innerHTML = "";
		final button = cast(document.createElement("button"), ButtonElement);
		button.classList.add("center");
		button.classList.add("click_me");
		button.style.animation = "scalebig 3s ease infinite";
		button.innerText = getLangValue("click_me");
		var is_click = false;
		button.addEventListener("click", () -> {
			if (is_click)
				return null;
			is_click = true;
			button.style.animation = "";
			sleep(100).then((_) -> {
				button.style.transform = "scale(5)";
				return sleep(2000);
			}).then((_) -> {
				button.style.opacity = "0";
				return sleep(2000);
			}).then((_) -> {
				Start.run();
			});
		});
		ROOT.appendChild(button);
	}
}
