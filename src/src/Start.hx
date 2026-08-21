import jsasync.JSAsyncTools.jsawait;
import jsasync.IJSAsync;
import jsasync.JSAsync.jsasync;
import Util.*;
import js.Browser.*;
import js.html.*;
import back.*;
import js.lib.Promise;

using StringTools;

typedef RECORD_TYPE = {
	name:String,
	send_back:Bool,
	content:String,
}

typedef WECHAT_RECORD_TYPE = {
	name:String,
	avatar:String,
	record:Array<RECORD_TYPE>,
}

typedef FILE_TYPE = {
	name:String,
	type:String,
	?keyword:String,
	?password:String,
	?content:String,
	?lock:Bool,
	?to:String,
	?title:String,
	?app:String,
}

class Start implements IJSAsync {
	static final WECHAT_SCREEN = cast(document.createElement("div"), DivElement);
	static final SETTING_SCREEN = cast(document.createElement("div"), DivElement);
	static var current_wechat:Int = -1;
	static var WECHAT_RECORD:Array<WECHAT_RECORD_TYPE> = [
		{
			name: getLangValue("contact_manager_horse"),
			avatar: "👨",
			record: [],
		},
		{
			name: getLangValue("contact_wife"),
			avatar: "👩",
			record: [
				{
					name: getLangValue("contact_wife"),
					send_back: false,
					content: getLangValue("wechat_wife_call_1"),
				},
				{
					name: getLangValue("contact_wife"),
					send_back: false,
					content: getLangValue("wechat_wife_call_2"),
				},
				{
					name: getLangValue("contact_wife"),
					send_back: false,
					content: getLangValue("wechat_wife_call_3"),
				},
				{
					name: getLangValue("contact_wife"),
					send_back: false,
					content: getLangValue("wechat_wife_call_4"),
				},
				{
					name: getLangValue("contact_wife"),
					send_back: false,
					content: getLangValue("wechat_wife_call_5"),
				},
			],
		},
	];
	static var MY_COMPUTER_FILES:Map<String, Array<FILE_TYPE>> = [
		"" => [
			{
				name: "C:",
				type: "disk",
				to: "C:\\"
			},
			{
				name: "D:",
				type: "disk",
				to: "D:\\"
			}
		],
		"C:\\" => [
			{
				name: "Windows",
				type: "folder",
				lock: true,
			},
			{
				name: getLangValue("cp_c_backup"),
				type: "folder",
				to: "C:\\Backup",
			},
		],
		"C:\\Backup" => [],
		"D:\\" => [
			{
				name: getLangValue("cp_d_video"),
				type: "folder",
				to: "D:\\Video",
			},
			{
				name: getLangValue("cp_d_document"),
				type: "folder",
				to: "D:\\Document",
			},
			{
				name: getLangValue("cp_d_picture"),
				type: "folder",
				to: "D:\\Picture",
			},
		],
		"D:\\Document" => [
			{
				name: getLangValue("cp_d_document_marry_10th"),
				type: "file",
				password: "10116",
				content: getLangValue("cp_d_document_marry_10th_doc"),
				title: getLangValue("cp_d_document_marry_10th"),
				keyword: "marry_10th",
				app: "Marry10th",
			},
		],
		"D:\\Picture" => [],
	];
	static var wechat_level:Int = 0;
	static var wechat_level_temp:Int = 0;

	static function MonitorWechatLevel():Promise<jsasync.Nothing> {
		return new Promise<jsasync.Nothing>((resolve, _) -> {
			var check:Void->Void;
			check = () -> {
				if (wechat_level != wechat_level_temp) {
					wechat_level_temp = wechat_level;
					resolve(null);
				} else {
					window.setTimeout(check, 100);
				}
			};
			check();
		});
	}

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
					<button class="computer-submit">
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
				if (files == null || files.length == 0)
					return;
				for (file in files) {
					var img = "";
					if (file.type == "disk")
						img = "assets/images/icons/disk.png";
					else if (file.type == "folder")
						img = "assets/images/icons/folder.png";
					else
						img = "assets/images/icons/file.png";
					final i_button = cast(document.createElement("button"), ButtonElement);
					i_button.classList.add("desktop-icon-button");
					i_button.style.width = "6cqi";
					i_button.style.height = "8cqb";
					i_button.innerHTML = '
                    <img src="${img}" style="height: 5cqb;">
                    <span style="font-size: 2cqb; color: black;">${file.name}</span>
					';
					i_button.addEventListener("dblclick", () -> {
						if (file.lock != null && file.lock) {
							window.alert(getLangValue("file_or_folder_cannot_open"));
							return;
						}
						if (file.password != null) {
							final password = window.prompt(getLangValue("file_or_folder_need_password"));
							if (password != file.password) {
								window.alert(getLangValue("file_or_folder_incorrect_password"));
								return;
							}
						}
						if (file.type == "file") {
							createWindow(5, {
								content: file.content,
								title: file.title,
								app: file.app,
							});
							if (file.keyword == "horse_crazy") {
								wechat_level = 1;
							} else if (file.keyword == "marry_10th") {
								wechat_level = 2;
							} else if (file.keyword == "family") {
								wechat_level = 3;
							}
						}
						if (file.type == "disk" || file.type == "folder") {
							gotoWindow(file.to);
							final di = cast(SCREEN.querySelector(".disk-input"), InputElement);
							di.value = file.to;
						}
					});
					cb.appendChild(i_button);
				}
			}
			gotoWindow("");
			SCREEN.querySelector(".computer-submit").addEventListener("click", () -> {
				final di = cast(SCREEN.querySelector(".disk-input"), InputElement);
				final value = di.value;
				gotoWindow(value);
			});
		});
		InternetExplorerButton.addEventListener("dblclick", () -> {
			createWindow(1, {
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
								<input class="url-input" style="height: 4cqb; font-size: 2cqb; flex: 1;" type="text">
								<button class="internet-submit">
								<svg xmlns="http://www.w3.org/2000/svg" style="width: 4cqb; height: 4cqb;" viewBox="0 0 24 24">
								<path fill="currentColor" d="M19 6a1 1 0 0 0-1 1v4a1 1 0 0 1-1 1H7.41l1.3-1.29a1 1 0 0 0-1.42-1.42l-3 3a1 1 0 0 0-.21.33a1 1 0 0 0 0 .76a1 1 0 0 0 .21.33l3 3a1 1 0 0 0 1.42 0a1 1 0 0 0 0-1.42L7.41 14H17a3 3 0 0 0 3-3V7a1 1 0 0 0-1-1"/>
								</svg>
								</button>
							</div>
							<div class="internet-body"></div>
						</div>',
			});
			final body = cast(SCREEN.querySelector(".internet-body"), DivElement);
			SCREEN.querySelector(".internet-submit").addEventListener("click", () -> {
				final url = cast(SCREEN.querySelector(".url-input"), InputElement).value;
				if (url.contains(getLangValue("internet_keyword_marry_1"))
					|| url.contains(getLangValue("internet_keyword_marry_2"))
					|| url.contains(getLangValue("internet_keyword_marry_3"))) {
					body.innerHTML = getLangValue("internet_marry");
				} else if (url.contains(getLangValue("internet_keyword_password_1"))) {
					body.innerHTML = getLangValue("internet_password");
				} else {
					body.innerHTML = getLangValue("internet_empty");
				}
			});
			body.innerHTML = getLangValue("internet_empty");
		});
		RecycleButton.addEventListener("dblclick", () -> {
			createWindow(2, {
				content: '
				<div class="window-screen" style="align-items: center; justify-content: center;">
				    <h1>${getLangValue("recycle_is_empty")}</h1>
				</div>
				'
			});
		});
		WeChatButton.addEventListener("dblclick", () -> {
			createWindow(3, {
				content: '
				<div class="window-screen" style="flex-direction: row;">
					<div class="wechat-screen"></div>
				</div>
				'
			});
			final d = cast(document.createElement("div"), DivElement);
			d.classList.add("window-screen");
			d.classList.add("wechat-contact-side");
			d.style.width = "30%";
			d.style.backgroundColor = "rgb(0, 87, 55)";
			for (recordi in 0...WECHAT_RECORD.length) {
				final button = createWechatButton(recordi);
				d.appendChild(button);
			}
			SCREEN.querySelector(".wechat-screen").insertAdjacentElement("beforebegin", d);
		});
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
		window.requestAnimationFrame((_dt:Float) -> {
			img.style.opacity = "1";
			start_div.style.opacity = "1";
		});
		window.setInterval(() -> {
			final date = Date.now();
			final hours = date.getHours();
			final minutes = date.getMinutes();
			time.innerText = '${hours < 10 ? "0" : ""}${hours}:${minutes < 10 ? "0" : ""}${minutes}';
		}, 1000);
		play();
	}

	static function createWechatButton(recordi:Int):ButtonElement {
		final record = WECHAT_RECORD[recordi];
		final button = cast(document.createElement("button"), ButtonElement);
		button.classList.add("wechat-contact");
		button.innerText = record.avatar + " " + record.name;
		button.addEventListener("click", () -> {
			final wc = cast(SCREEN.querySelector(".wechat-screen"), DivElement);
			current_wechat = recordi;
			wc.innerHTML = "";
			for (r in record.record) {
				final div = cast(document.createElement("div"), DivElement);
				div.classList.add("wechat-record");
				if (r.send_back) {
					div.style.alignItems = "flex-end";
					div.innerHTML = '
				<div style="font-size: 1.5cqb;">${getLangValue("contact_me")}</div>
				<div style="padding: 0.5cqb 0.3cqi; border: 0.1cqb solid #009900; background-color: #00FF00; width: auto; height: auto; font-size: 1cqi; display: flex; align-items: center; justify-content: flex-end;">
				    ${r.content}
				</div>
				';
				} else {
					div.style.alignItems = "flex-start";
					div.innerHTML = '
				<div style="font-size: 1.5cqb;">${r.name}</div>
				<div style="padding: 0.5cqb 0.3cqi; border: 0.1cqb solid #666666; background-color: #CCCCCC; width: auto; height: auto; font-size: 1cqi; display: flex; align-items: center; justify-content: flex-start;">
				    ${r.content}
				</div>
				';
				}
				wc.innerHTML += div.outerHTML;
			}
		});
		return button;
	}

	@:jsasync
	static function play() {
		final xppoweron = new Audio("assets/sounds/xppoweron.wav");
		xppoweron.volume = (Std.parseFloat(window.localStorage.getItem("the_farmer_helplessness_volume") ?? "100.0") ?? 100.0) / 100;
		xppoweron.play();
		jsawait(sleep(9000));
		showWechatToast(getLangValue("contact_manager_horse"), getLangValue("wechat_helper_call_1"));
		jsawait(sleep(4000));
		showWechatToast(getLangValue("contact_manager_horse"), getLangValue("wechat_helper_call_2"));
		jsawait(sleep(4000));
		showWechatToast(getLangValue("contact_manager_horse"), getLangValue("wechat_helper_call_3"));
		jsawait(sleep(4000));
		showWechatToast(getLangValue("contact_manager_horse"), getLangValue("wechat_helper_call_4"));
		MY_COMPUTER_FILES["C:\\Backup"].push({
			name: getLangValue("cp_c_backup_horse_crazy"),
			type: "file",
			content: '<video src="assets/media/horse_crazy.mp4" control autoplay loop style="width: 100%; height: 100%;">',
			title: getLangValue("cp_c_backup_horse_crazy"),
			keyword: "horse_crazy",
			app: "Surveillance",
		});
		while (wechat_level != 1) {
			jsawait(MonitorWechatLevel());
		}
		jsawait(sleep(6000));
		showWechatToast(getLangValue("contact_manager_horse"), getLangValue("wechat_helper_call_5"), true);
		jsawait(sleep(4000));
		showWechatToast(getLangValue("contact_manager_horse"), getLangValue("wechat_helper_call_6"));
		jsawait(sleep(4000));
		showWechatToast(getLangValue("contact_manager_horse"), getLangValue("wechat_helper_call_7"));
		jsawait(sleep(20000));
		showWechatToast(getLangValue("contact_manager_horse"), getLangValue("wechat_helper_call_8"));
		MY_COMPUTER_FILES["C:\\Backup"].push({
			name: getLangValue("cp_c_backup_ring_img"),
			type: "file",
			content: '<div class="center-item"><img src="assets/images/wallpaper/ring.png" style="max-width: 100%; max-height: 100%; height: auto; width: auto;"></div>',
			title: getLangValue("cp_c_backup_ring_img"),
			app: "ring_img",
		});
		jsawait(sleep(9000));
		showWechatToast(getLangValue("contact_manager_horse"), getLangValue("wechat_helper_call_9"), true);
		jsawait(sleep(4000));
		showWechatToast(getLangValue("contact_manager_horse"), getLangValue("wechat_helper_call_10"));
		jsawait(sleep(12000));
		showWechatToast(getLangValue("contact_manager_horse"), getLangValue("wechat_helper_call_11"));
		jsawait(sleep(4000));
		showWechatToast(getLangValue("contact_manager_horse"), getLangValue("wechat_helper_call_12"));
		jsawait(sleep(4000));
		showWechatToast(getLangValue("contact_manager_horse"), getLangValue("wechat_helper_call_13"), true);
		jsawait(sleep(4000));
		showWechatToast(getLangValue("contact_manager_horse"), getLangValue("wechat_helper_call_14"));
		jsawait(sleep(20000));
		showWechatToast(getLangValue("contact_manager_horse"), getLangValue("wechat_helper_call_15"));
		jsawait(sleep(4000));
		showWechatToast(getLangValue("contact_manager_horse"), getLangValue("wechat_helper_call_16"));
		jsawait(sleep(4000));
		showWechatToast(getLangValue("contact_manager_horse"), getLangValue("wechat_helper_call_17"), true);
		jsawait(sleep(4000));
		showWechatToast(getLangValue("contact_manager_horse"), getLangValue("wechat_helper_call_18"), true);
		jsawait(sleep(4000));
		showWechatToast(getLangValue("contact_manager_horse"), getLangValue("wechat_helper_call_19"));
		jsawait(sleep(4000));
		showWechatToast("", getLangValue("wechat_hint_call_1"), false, true);
		while (wechat_level != 2) {
			jsawait(MonitorWechatLevel());
		}
		jsawait(sleep(16000));
		showWechatToast(getLangValue("contact_manager_horse"), getLangValue("wechat_helper_call_20"), true);
		jsawait(sleep(4000));
		showWechatToast(getLangValue("contact_manager_horse"), getLangValue("wechat_helper_call_21"), true);
		jsawait(sleep(4000));
		showWechatToast(getLangValue("contact_manager_horse"), getLangValue("wechat_helper_call_22"));
		jsawait(sleep(4000));
		showWechatToast(getLangValue("contact_manager_horse"), getLangValue("wechat_helper_call_23"));
		jsawait(sleep(4000));
		showWechatToast("", getLangValue("wechat_hint_call_2"), false, true);
		jsawait(sleep(4000));
		showWechatToast(getLangValue("contact_manager_horse"), getLangValue("wechat_helper_call_24"));
		jsawait(sleep(4000));
		showWechatToast(getLangValue("contact_manager_horse"), getLangValue("wechat_helper_call_25"), true);
		jsawait(sleep(4000));
		showWechatToast(getLangValue("contact_manager_horse"), getLangValue("wechat_helper_call_26"));
		jsawait(sleep(4000));
		showWechatToast(getLangValue("contact_wife"), getLangValue("wechat_wife_call_6"), true);
		jsawait(sleep(4000));
		showWechatToast(getLangValue("contact_wife"), getLangValue("wechat_wife_call_7"), true);
		jsawait(sleep(4000));
		showWechatToast(getLangValue("contact_wife"), getLangValue("wechat_wife_call_8"));
		jsawait(sleep(4000));
		showWechatToast(getLangValue("contact_wife"), getLangValue("wechat_wife_call_9"), true);
		jsawait(sleep(4000));
		showWechatToast(getLangValue("contact_wife"), getLangValue("wechat_wife_call_10"));
		jsawait(sleep(6000));
		showWechatToast(getLangValue("contact_wife"), getLangValue("wechat_wife_call_11"));
		jsawait(sleep(4000));
		showWechatToast(getLangValue("contact_wife"), getLangValue("wechat_wife_call_12"));
		jsawait(sleep(6000));
		showWechatToast("", getLangValue("wechat_hint_call_3"), false, true);
		jsawait(sleep(4000));
		showWechatToast("", getLangValue("wechat_hint_call_4"), false, true);
		jsawait(sleep(4000));
		showWechatToast("", getLangValue("wechat_hint_call_5"), false, true);
		jsawait(sleep(4000));
		showWechatToast("", getLangValue("wechat_hint_call_6"), false, true);
		MY_COMPUTER_FILES["D:\\Picture"].push({
			name: getLangValue("cp_c_picture_family"),
			type: "file",
			content: '<div class="center-item"><img src="assets/images/wallpaper/family.png" style="max-width: 100%; max-height: 100%; height: auto; width: auto;"></div>',
			title: getLangValue("cp_c_picture_family"),
			keyword: "family",
			app: "family",
		});
		while (wechat_level != 3) {
			jsawait(MonitorWechatLevel());
		}
		jsawait(sleep(6000));
		final record = {
			name: getLangValue("contact_author"),
			avatar: '🧑',
			record: [],
		};
		WECHAT_RECORD.push(record);
		final button = createWechatButton(WECHAT_RECORD.length - 1);
		var w = document.querySelector(".wechat-contact-side");
		if (w != null)
			w.appendChild(button);
		jsawait(sleep(6000));
		showWechatToast(getLangValue("contact_author"), getLangValue("wechat_author_call_1"));
		jsawait(sleep(4000));
		showWechatToast(getLangValue("contact_author"), getLangValue("wechat_author_call_2"));
		jsawait(sleep(4000));
		showWechatToast(getLangValue("contact_author"), getLangValue("wechat_author_call_3"));
		jsawait(sleep(4000));
		showWechatToast(getLangValue("contact_author"), getLangValue("wechat_author_call_4"));
		jsawait(sleep(4000));
		showWechatToast(getLangValue("contact_author"), getLangValue("wechat_author_call_5"));
		jsawait(sleep(4000));
		showWechatToast(getLangValue("contact_author"), getLangValue("wechat_author_call_6"));
		jsawait(sleep(4000));
		showWechatToast(getLangValue("contact_author"), getLangValue("wechat_author_call_7"));
		jsawait(sleep(4000));
		showWechatToast(getLangValue("contact_author"), getLangValue("wechat_author_call_8"));
		jsawait(sleep(4000));
		showWechatToast(getLangValue("contact_author"), getLangValue("wechat_author_call_9"));
		jsawait(sleep(4000));
		showWechatToast(getLangValue("contact_author"), getLangValue("wechat_author_call_10"));
		jsawait(sleep(4000));
		showWechatToast(getLangValue("contact_author"), getLangValue("wechat_author_call_11"));
		jsawait(sleep(100));
	}

	static function showToast(name:String, content:String, img:String, duration:Int = 3000) {
		final toast = cast(document.createElement("div"), DivElement);
		toast.innerHTML = '
            <img src="${img}" style="width: 1.5cqi; height: 1.5cqi; margin-right: 0.3cqi;">
            ${name}: <br>${content}
            ';
		toast.classList.add("toast");
		toast.style.opacity = "0";
		toast.style.transform = "translateY(20%)";
		ROOT.appendChild(toast);
		window.requestAnimationFrame((_dt:Float) -> {
			toast.style.opacity = "1";
			toast.style.transform = "translateY(0)";
		});
		window.setTimeout(() -> {
			toast.style.opacity = "0";
			toast.style.transform = "translateY(20%)";
			window.setTimeout(() -> {
				toast.remove();
			}, 300);
		}, duration);
	}

	public static function showWechatToast(name:String, content:String, send_back:Bool = false, is_hint:Bool = false, duration:Int = 3000) {
		if (is_hint) {
			showToast(getLangValue("hint"), content,
				"data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' style='color: blue;' viewBox='0 0 1024 1024'%3E%3Cpath fill='currentColor' d='M512 64C264.6 64 64 264.6 64 512s200.6 448 448 448s448-200.6 448-448S759.4 64 512 64m0 820c-205.4 0-372-166.6-372-372s166.6-372 372-372s372 166.6 372 372s-166.6 372-372 372'/%3E%3Cpath fill='currentColor' fill-opacity='.15' d='M512 140c-205.4 0-372 166.6-372 372s166.6 372 372 372s372-166.6 372-372s-166.6-372-372-372m-32 156c0-4.4 3.6-8 8-8h48c4.4 0 8 3.6 8 8v272c0 4.4-3.6 8-8 8h-48c-4.4 0-8-3.6-8-8zm32 440a48.01 48.01 0 0 1 0-96a48.01 48.01 0 0 1 0 96'/%3E%3Cpath fill='currentColor' d='M488 576h48c4.4 0 8-3.6 8-8V296c0-4.4-3.6-8-8-8h-48c-4.4 0-8 3.6-8 8v272c0 4.4 3.6 8 8 8m-24 112a48 48 0 1 0 96 0a48 48 0 1 0-96 0'/%3E%3C/svg%3E",
				duration);
			return;
		}
		final current_wechat_m = Lambda.findIndex(WECHAT_RECORD, (w) -> w.name == name);
		if (current_wechat_m == -1)
			return;
		WECHAT_RECORD[current_wechat_m].record.push({name: name, send_back: send_back, content: content});
		if (current_wechat_m == current_wechat) {
			final win = Lambda.find(State.windows, (w) -> w.app == "wechat");
			if (win != null) {
				final wc = cast(win.el.querySelector(".wechat-screen"), DivElement);
				final div = cast(document.createElement("div"), DivElement);
				div.classList.add("wechat-record");
				if (send_back) {
					div.style.alignItems = "flex-end";
					div.innerHTML = '
    				<div style="font-size: 1.5cqb;">${getLangValue("contact_me")}</div>
    				<div style="padding: 0.5cqb 0.3cqi; border: 0.1cqb solid #009900; background-color: #00FF00; width: auto; height: auto; font-size: 1cqi; display: flex; align-items: center; justify-content: flex-end;">
    				    ${content}
    				</div>
    				';
				} else {
					div.style.alignItems = "flex-start";
					div.innerHTML = '
				<div style="font-size: 1.5cqb;">${name}</div>
				<div style="padding: 0.5cqb 0.3cqi; border: 0.1cqb solid #666666; background-color: #CCCCCC; width: auto; height: auto; font-size: 1cqi; display: flex; align-items: center; justify-content: flex-start;">
				    ${content}
				</div>
				';
				}
				wc.appendChild(div);
				return;
			}
		} else {
			showToast(send_back ? getLangValue("contact_me") : name, content, "assets/images/icons/wechat.png", duration);
		}
	}
}
