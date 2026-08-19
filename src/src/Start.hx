import jsasync.JSAsyncTools.jsawait;
import jsasync.IJSAsync;
import jsasync.JSAsync.jsasync;
import Util.*;
import js.Browser.*;
import js.html.*;
import back.*;

using StringTools;

class Start implements IJSAsync {
	static final WECHAT_SCREEN = cast(document.createElement("div"), DivElement);
	static final SETTING_SCREEN = cast(document.createElement("div"), DivElement);
	static final WECHAT_RECORD:Array<Dynamic> = [
		{
			"name": getLangValue("contact_manager_horse"),
			"record": []
		},
		{
			"name": getLangValue("contact_wife"),
			"record": []
		},
	];
	static final MY_COMPUTER_FILES:Map<String, Array<Map<String, String>>> = [
		"" => [
			["name" => "C:", "type" => "disk", "to" => "C:\\"],
			["name" => "D:", "type" => "disk", "to" => "D:\\"],
		],
		"C:\\" => [
			["name" => "Windows", "type" => "folder", "lock" => "true"],
			["name" => getLangValue("cp_c_backup"), "type" => "folder", "to" => "C:\\Backup"],
		],
		"D:\\" => [
			["name" => getLangValue("cp_d_video"), "type" => "folder", "to" => "D:\\Video"],
			[
				"name" => getLangValue("cp_d_document"),
				"type" => "folder",
				"to" => "D:\\Document"
			],
		]
	];

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
		MENU_BAR.style.gap = "0.1cqi";
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
		MyComputerButton.addEventListener("dblclick", () -> {
			createWindow(0, {
				content: '
			<div class="window-screen" style="padding: 0 1cqi;">
			    <div style="width: 100%; height: 5cqb; display: flex; align-items: center; gap: 0.5cqi;">
					<button class="button-back">
					<svg xmlns="http://www.w3.org/2000/svg" style="width: 4cqb; height: 4cqb;" viewBox="0 0 24 24">
					<g fill="none">
					<path fill="#33FF33" d="M22.518 9.59H9.99l5.1-5.95a.483.483 0 0 0-.366-.795H9.24a.48.48 0 0 0-.359.16l-7.76 8.674a.48.48 0 0 0 0 .642l7.76 8.673a.48.48 0 0 0 .36.161h5.482a.481.481 0 0 0 .366-.795l-5.1-5.95h12.528a.48.48 0 0 0 .482-.483v-3.854a.48.48 0 0 0-.482-.482"/>
					<path fill="#009900" d="M1 12c0 .118.044.233.122.32l7.76 8.674a.48.48 0 0 0 .36.16h5.482a.482.482 0 0 0 .366-.794l-5.1-5.95h12.528a.48.48 0 0 0 .482-.483V12z"/>
					<path stroke="#003319" stroke-linecap="round" stroke-linejoin="round" d="M22.518 9.59H9.99l5.1-5.95a.483.483 0 0 0-.366-.795H9.24a.48.48 0 0 0-.359.16l-7.76 8.674a.48.48 0 0 0 0 .642l7.76 8.673a.48.48 0 0 0 .36.161h5.482a.481.481 0 0 0 .366-.795l-5.1-5.95h12.528a.48.48 0 0 0 .482-.483v-3.854a.48.48 0 0 0-.482-.482"/>
					</g>
					</svg>
					</button>
					<button class="button-front">
					<svg xmlns="http://www.w3.org/2000/svg" style="width: 4cqb; height: 4cqb; transform: rotate(180deg);" viewBox="0 0 24 24">
					<g fill="none">
					<path fill="#33FF33" d="M22.518 9.59H9.99l5.1-5.95a.483.483 0 0 0-.366-.795H9.24a.48.48 0 0 0-.359.16l-7.76 8.674a.48.48 0 0 0 0 .642l7.76 8.673a.48.48 0 0 0 .36.161h5.482a.481.481 0 0 0 .366-.795l-5.1-5.95h12.528a.48.48 0 0 0 .482-.483v-3.854a.48.48 0 0 0-.482-.482"/>
					<path fill="#009900" d="M1 12c0 .118.044.233.122.32l7.76 8.674a.48.48 0 0 0 .36.16h5.482a.482.482 0 0 0 .366-.794l-5.1-5.95h12.528a.48.48 0 0 0 .482-.483V12z"/>
					<path stroke="#003319" stroke-linecap="round" stroke-linejoin="round" d="M22.518 9.59H9.99l5.1-5.95a.483.483 0 0 0-.366-.795H9.24a.48.48 0 0 0-.359.16l-7.76 8.674a.48.48 0 0 0 0 .642l7.76 8.673a.48.48 0 0 0 .36.161h5.482a.481.481 0 0 0 .366-.795l-5.1-5.95h12.528a.48.48 0 0 0 .482-.483v-3.854a.48.48 0 0 0-.482-.482"/>
					</g>
					</svg>
					</button>
					<input class="disk-input" style="height: 4cqb; font-size: 2cqb; flex: 1;" type="text">
					<button class="button-submit">
					<svg xmlns="http://www.w3.org/2000/svg" style="width: 4cqb; height: 4cqb;" viewBox="0 0 24 24">
					<path fill="currentColor" d="M19 6a1 1 0 0 0-1 1v4a1 1 0 0 1-1 1H7.41l1.3-1.29a1 1 0 0 0-1.42-1.42l-3 3a1 1 0 0 0-.21.33a1 1 0 0 0 0 .76a1 1 0 0 0 .21.33l3 3a1 1 0 0 0 1.42 0a1 1 0 0 0 0-1.42L7.41 14H17a3 3 0 0 0 3-3V7a1 1 0 0 0-1-1"/>
					</svg>
					</button>
				</div>
				<div class="computer-body"></div>
			</div>
			'
			});
			function gotoWindow(disk:String) {
				final cb = SCREEN.querySelector(".computer-body");
				cb.innerHTML = '';
				final files = MY_COMPUTER_FILES[disk];
				if (files == null || files.length == 0) return;
				for (file in files) {
					var img = "";
					if (file["type"] == "disk")
						img = "assets/images/icons/disk.png";
					else if (file["type"] == "folder")
						img = "assets/images/icons/folder.png";
					else
						img = "assets/images/icons/file.png";
					final i_button = cast(document.createElement("button"), ButtonElement);
					i_button.classList.add("desktop-icon-button");
					i_button.style.width = "6cqi";
					i_button.style.height = "8cqb";
					i_button.innerHTML = '
                    <img src="${img}" style="height: 5cqb;">
                    <span style="font-size: 2cqb; color: black;">${file["name"]}</span>
					';
					i_button.addEventListener("dblclick", (e) -> {
						if (file["lock"] == "true") {
							window.alert(getLangValue("file_or_folder_cannot_open"));
							return;
						}
						if (file["password"] != null) {
							final password = window.prompt(getLangValue("file_or_folder_need_password"));
							if (password != file["password"]) {
								window.alert(getLangValue("file_or_folder_incorrect_password"));
								return;
							}
						}
						if (file["type"] == "file") {
							createWindow(5, {
								content: file["content"],
							});
						}
						if (file["type"] == "disk" || file["type"] == "folder") {
							gotoWindow(file["to"]);
							final di = cast(SCREEN.querySelector(".disk-input"), InputElement);
							di.value = file["to"];
						}
					});
					cb.appendChild(i_button);
				}
			}
			gotoWindow("");
			SCREEN.querySelector(".button-submit").addEventListener("click", (e) -> {
			    final di = cast(SCREEN.querySelector(".disk-input"), InputElement);
				final value = di.value;
				gotoWindow(value);
			});
		});
		InternetExplorerButton.addEventListener("dblclick", jsasync(() -> {}));
		RecycleButton.addEventListener("dblclick", jsasync(() -> {
			createWindow(2, {
				content: '
				<div class="window-screen" style="align-items: center; justify-content: center;">
				    <h1>${getLangValue("recycle_is_empty")}</h1>
				</div>
				'
			});
		}));
		WeChatButton.addEventListener("dblclick", jsasync(() -> {}));
		SettingsButton.addEventListener("dblclick", () -> {
			createWindow(4, {
				content: '
				<div class="window-screen" style="padding: 1cqb 1cqi;">
				    <div class="settings-volume-text" style="font-size: 1cqi; font-weight: bold;">${getLangValue("settings_volume").replace("${text}", window.localStorage.getItem("the_farmer_helplessness_volume") ?? "100")}</div>
					<input class="settings-volume-scroll" type="range" min="0" max="100" value="${window.localStorage.getItem("the_farmer_helplessness_volume") ?? "100"}"/>
			        <div class="settings-fullscreen-text" style="font-size: 1cqi; font-weight: bold;">${getLangValue("settings_fullscreen")}</div>
					<input class="settings-fullscreen-checkbox" type="checkbox" ${window.localStorage.getItem("the_farmer_helplessness_fullscreen") == "true" ? "checked" : ""}/>
			        <div class="settings-language-text" style="font-size: 1cqi; font-weight: bold;">${getLangValue("settings_language")}</div>
			        <select class="settings-language-select">
			            <option value="0" ${window.localStorage.getItem("the_farmer_helplessness_language") == "0" ? "selected" : ""}>English</option>
			            <option value="1" ${window.localStorage.getItem("the_farmer_helplessness_language") == "1" ? "selected" : ""}>简体中文</option>
			            <option value="2" ${window.localStorage.getItem("the_farmer_helplessness_language") == "2" ? "selected" : ""}>繁體中文</option>
			        </select>
			    </div>
				',
			});
			SCREEN.querySelector(".settings-volume-scroll").addEventListener("input", (e) -> {
				var value = Std.string(e.target.value);
				window.localStorage.setItem("the_farmer_helplessness_volume", value);
				SCREEN.querySelector(".settings-volume-text").innerText = getLangValue("settings_volume").replace("${text}", value);
			});
			SCREEN.querySelector(".settings-fullscreen-checkbox").addEventListener("change", (e) -> {
				var isChecked = cast(e.target, InputElement).checked;
				End.setFullscreen(isChecked);
				window.localStorage.setItem("the_farmer_helplessness_fullscreen", isChecked ? "true" : "false");
			});
			SCREEN.querySelector(".settings-language-select").addEventListener("change", (e) -> {
				var value = cast(e.target, SelectElement).value;
				window.localStorage.setItem("the_farmer_helplessness_language", value);
				window.alert(getLangValue("hint_restart_game"));
			});
		});
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
		jsawait(play());
	}

	@:jsasync
	static function play() {
		final xppoweron = new Audio("assets/sounds/xppoweron.wav");
		xppoweron.volume = (Std.parseFloat(window.localStorage.getItem("the_farmer_helplessness_volume") ?? "100.0") ?? 100.0) / 100;
		xppoweron.play();
		jsawait(sleep(9000));
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

	static function initWechat() {}
}
