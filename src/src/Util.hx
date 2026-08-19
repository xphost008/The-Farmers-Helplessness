import js.lib.Promise;
import js.Browser.*;
import js.html.*;
import jsasync.IJSAsync;
import jsasync.JSAsyncTools.jsawait;
import jsasync.JSAsyncTools;

typedef Rect = {
	var x:Float;
	var y:Float;
	var width:Int;
	var height:Int;
}

typedef WindowObject = {
	var id:Int;
	var app:String;
	var title:String;
	var icon:String;
	var el:js.html.DivElement;
	var rect:Rect;
	var isMaximized:Bool;
	var isMinimized:Bool;
	var ?restoreRect:Rect;
	var zIndex:Int;
}

typedef WindowState = {
	var windows:Array<WindowObject>;
	var nextId:Int;
	var activeId:Int;
	var maxZIndex:Int;
	var ?isDragging:DragInfo;
}

typedef DragInfo = {
	id:Int,
	startX:Float,
	startY:Float,
	offsetX:Float,
	offsetY:Float,
}

typedef WindowOption = {
	?id:String,
	?app:String,
	?title:String,
	?icon:String,
	content:String,
	?width:Int,
	?height:Int,
	?top:Float,
	?left:Float,
}

class Util implements IJSAsync {
	static final LANGUAGE:Map<String, Array<String>> = [
		"lang_name" => ["English", "简体中文", "繁體中文",],
		"click_me" => ["Click me!", "点我开始！", "點我開始！",],
		"start_button" => ["Start", "开始", "開始",],
		"my_computer" => ["My Computer", "我的电脑", "我的電腦",],
		"ie" => ["Internet Explorer", "Internet Explorer", "Internet Explorer",],
		"recycle" => ["Recycle Bin", "回收站", "資源回收筒",],
		"wechat" => ["WeChat", "微信", "微信",],
		"settings" => ["Settings", "设置", "設定",],
		"settings_volume" => ["Game Volume: ${text}", "游戏音量：${text}", "遊戲音量：${text}",],
		"settings_fullscreen" => ["Is fullscreen", "是否全屏", "是否全螢幕",],
		"settings_language" => ["Language", "语言", "語言",],
		"hint_restart_game" => ["Please restart game to apply settings!", "请重启游戏以应用设置修改！", "請重新啟動遊戲以套用設定！"],
		"recycle_is_empty" => ["Recycle Bin is empty", "回收站为空", "資源回收筒是空的"],
		"contact_manager_horse" => ["Manager Horse", "马经理", "馬經理"],
		"contact_wife" => ["My dear wife", "我亲爱的老婆", "老婆大人"],
		"cp_c_backup" => ["Backup", "备份", "備份"],
		"cp_d_video" => ["Video", "视频", "影片"],
		"cp_d_document" => ["Document", "文档", "文檔"],
		"file_or_folder_cannot_open" => ["The file cannot be opened", "文件无法打开", "無法開啟此文檔"],
		"file_or_folder_need_password" => ["The file need a password, please enter:", "文件需要密码，请输入：", "此文檔需要密碼，請輸入："],
		"file_or_folder_incorrect_password" => ["Incorrect password!", "密码错误！", "密碼錯誤！"],
		"wechat_helper_call_1" => ["Manager Horse: <br>Help!!", "马经理: <br>救命！", "馬經理: <br>救命！",],
		"wechat_helper_call_2" => [
			"Manager Horse: <br>These horses are crazy!",
			"马经理：<br>这些马疯了！",
			"馬經理：<br>這些馬瘋了！",
		],
		"wechat_helper_call_3" => [
			"Manager Horse: <br>You must check the surveillance!",
			"马经理：<br>你一定要看一下监控！",
			"馬經理：<br>你一定要看一下監控！",
		],
		"wechat_helper_call_4" => [
			"Manager Horse: <br>The surveillance I sent you!",
			"马经理：<br>监控我发给你了！",
			"馬經理：<br>監控我發給你了！",
		],
		"wechat_helper_call_5" => ["Manager Horse: <br>[Video]", "马经理：<br>[视频]", "馬經理：<br>[影片]",]
	];
	public static final ROOT = cast(document.getElementById("main_box"), DivElement);
	public static final MENU_BAR = cast(document.createElement("div"), DivElement);
	public static final SCREEN = cast(document.createElement("div"), DivElement);

	public static function sleep(ms:Int):Promise<jsasync.Nothing> {
		return new Promise<jsasync.Nothing>((resolve, _) -> {
			window.setTimeout(() -> {
				resolve(null);
			}, ms);
		});
	}

	public static function getLangValue(name:String):String {
		final index = Std.parseInt(window.localStorage.getItem("the_farmer_helplessness_language") ?? "0") ?? 0;
		return LANGUAGE[name][index];
	}

	static var State:WindowState = {
		windows: [],
		nextId: 0,
		activeId: 0,
		maxZIndex: 10,
		isDragging: null,
	};

	@:jsasync
	public static function showToast(message:String, duration:Int = 3000) {
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

	public static function clamp(value:Float, min:Float, max:Float):Float {
		return Math.max(min, Math.min(max, value));
	}

	public static function calcBound(wildReal:Float, inlineReal:Float):Float {
		return 100 / wildReal * inlineReal;
	}

	public static function createWindow(index:Int, options:WindowOption):Int {
		final app_arr = ["my_computer", "ie", "recycle", "wechat", "settings"];
		final app = app_arr[index] ?? options.app ?? "App";
		final existing = Lambda.find(State.windows, (w) -> w.app == app && !w.isMinimized);
		if (existing != null) {
			existing.isMinimized = false;
			existing.el.style.display = "flex";
			bringToFront(existing.id);
			updateTaskbar();
			return existing.id;
		}
		final title_arr = [
			getLangValue("my_computer"),
			getLangValue("ie"),
			getLangValue("recycle"),
			getLangValue("wechat"),
			getLangValue("settings")
		];
		final title = title_arr[index] ?? options.title ?? "Title";
		final icon_arr = [
			"assets/images/icons/computer.png",
			"assets/images/icons/ie.png",
			"assets/images/icons/recycle.png",
			"assets/images/icons/wechat.png",
			"assets/images/icons/settings.png"
		];
		final icon = icon_arr[index] ?? options.icon ?? "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' style='color: white;' viewBox='0 0 24 24'%3E%3Cg fill='none' stroke='currentColor' stroke-width='1.5'%3E%3Cpath d='M12.25 2.75a9.5 9.5 0 1 1 0 19a9.5 9.5 0 0 1 0-19Z'/%3E%3Cpath d='M14.62 12.25a2.37 2.37 0 1 0-4.74 0a2.37 2.37 0 0 0 4.74 0Z'/%3E%3Cpath stroke-linecap='round' stroke-linejoin='round' d='M12.25 18.93a6.7 6.7 0 0 1-5.24-2.53m7.24-10.53a6.69 6.69 0 0 1 4.4 4.48'/%3E%3C/g%3E%3C/svg%3E";
		final id = State.nextId++;
		final el = cast(document.createElement("div"), DivElement);
		el.classList.add("window");
		el.setAttribute("windowId", Std.string(id));
		final header = cast(document.createElement("div"), DivElement);
		header.classList.add("window-header");
		header.innerHTML = '
            <div class="window-title">
                <img src="${icon}" alt="${title}" style="height: 3.2cqb; width: auto; margin: 0 0.2cqi;" />
                <span style="font-size: 2cqb;">${title}</span>
            </div>
            <div class="window-controls">
                <button class="btn-control btn-minimize">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" style="width: 100%; height: 100%; color: white;">
                        <path fill="currentColor" d="M5 13q-.425 0-.712-.288T4 12t.288-.712T5 11h14q.425 0 .713.288T20 12t-.288.713T19 13z"/>
                    </svg>
                </button>
                <button class="btn-control btn-maximize">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" style="width: 100%; height: 100%; color: white;">
                        <path fill="currentColor" d="M20 3H4c-1.103 0-2 .897-2 2v14c0 1.103.897 2 2 2h16c1.103 0 2-.897 2-2V5c0-1.103-.897-2-2-2M4 19V5h16l.001 14z"/>
                    </svg>
                </button>
                <button class="btn-control btn-close">
                    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 11 11" style="width: 100%; height: 100%; color: white;">
                        <path d="M2.2 1.19l3.3 3.3L8.8 1.2a.67.67 0 0 1 .5-.2a.75.75 0 0 1 .7.7a.66.66 0 0 1-.2.48L6.49 5.5L9.8 8.82c.13.126.202.3.2.48a.75.75 0 0 1-.7.7a.67.67 0 0 1-.5-.2L5.5 6.51L2.21 9.8a.67.67 0 0 1-.5.2a.75.75 0 0 1-.71-.71a.66.66 0 0 1 .2-.48L4.51 5.5L1.19 2.18A.66.66 0 0 1 1 1.7a.75.75 0 0 1 .7-.7a.67.67 0 0 1 .5.19z" fill="currentColor"/>
                    </svg>
                </button>
            </div>
        ';
		el.appendChild(header);
		final body = cast(document.createElement("div"), DivElement);
		body.classList.add("window-body");
		body.innerHTML = options.content;
		el.appendChild(body);
		SCREEN.appendChild(el);
		final defaultWidth = options.width ?? 50;
		final defaultHeight = options.height ?? 50;
		final offsetY = options.top ?? (Math.random() * 3 + 8);
		final offsetX = options.left ?? (Math.random() * 3 + 8);
		final win:WindowObject = {
			id: id,
			app: app,
			title: title,
			icon: icon,
			el: el,
			rect: {
				x: offsetX,
				y: offsetY,
				width: defaultWidth,
				height: defaultHeight,
			},
			isMinimized: false,
			isMaximized: false,
			zIndex: ++State.maxZIndex,
			restoreRect: null,
		}
		State.windows.push(win);
		State.activeId = id;
		applyWindowStyles(win);
		header.addEventListener("dblclick", (event) -> {
			if (event.target.closest("button"))
				return;
			toggleMaximize(id);
		});
		header.addEventListener("mousedown", (event) -> {
			if (event.button != 0)
				return;
			final win = Lambda.find(State.windows, (w) -> w.id == id);
			if (win == null || win.isMinimized || win.isMaximized)
				return;
			event.preventDefault();
			State.isDragging = {
				id: id,
				startX: calcBound(Std.parseFloat(Std.string(SCREEN.scrollWidth)), Std.parseFloat(Std.string(event.pageX))),
				startY: calcBound(Std.parseFloat(Std.string(SCREEN.scrollHeight)), Std.parseFloat(Std.string(event.pageY))),
				offsetX: win.rect.x,
				offsetY: win.rect.y,
			};
			bringToFront(id);
		});
		SCREEN.addEventListener("mousemove", (event) -> {
			final info = State.isDragging;
			if (info == null)
				return;
			final win = Lambda.find(State.windows, (w) -> w.id == info.id);
			if (win == null || win.isMinimized || win.isMaximized) {
				State.isDragging = null;
				return;
			}
			final deltaX = calcBound(Std.parseFloat(Std.string(SCREEN.scrollWidth)), Std.parseFloat(Std.string(event.pageX))) - State.isDragging.startX;
			final deltaY = calcBound(Std.parseFloat(Std.string(SCREEN.scrollHeight)), Std.parseFloat(Std.string(event.pageY))) - State.isDragging.startY;
			var newX = State.isDragging.offsetX + deltaX;
			var newY = State.isDragging.offsetY + deltaY;
			final maxX = 100 - win.rect.width;
			final maxY = 95 - win.rect.height;
			win.rect.x = clamp(newX, 0, maxX);
			win.rect.y = clamp(newY, 0, maxY);
			win.el.style.left = win.rect.x + "cqi";
			win.el.style.top = win.rect.y + "cqb";
		});
		SCREEN.addEventListener("mouseup", (event) -> {
			State.isDragging = null;
		});
		header.querySelector(".btn-minimize").addEventListener("click", (event) -> {
			event.preventDefault();
			event.stopPropagation();
			toggleMinimize(id);
		});
		header.querySelector(".btn-maximize").addEventListener("click", (event) -> {
			event.preventDefault();
			event.stopPropagation();
			toggleMaximize(id);
		});
		header.querySelector(".btn-close").addEventListener("click", (event) -> {
			event.preventDefault();
			event.stopPropagation();
			closeWindow(id);
		});
		el.addEventListener('mousedown', (_event) -> {
			bringToFront(id);
		});
		updateTaskbar();
		return id;
	}

	static function bringToFront(id:Int) {
		final win = Lambda.find(State.windows, (w) -> w.id == id);
		if (win == null || win.isMinimized)
			return;
		win.zIndex = ++State.maxZIndex;
		win.el.style.zIndex = Std.string(win.zIndex);
		State.activeId = id;
		updateTaskbar();
	}

	static function toggleMaximize(id:Int) {
		final win = Lambda.find(State.windows, (w) -> w.id == id);
		if (win == null)
			return;
		if (win.isMaximized) {
			final rect = win.restoreRect;
			win.rect.x = rect.x;
			win.rect.y = rect.y;
			win.rect.width = rect.width;
			win.rect.height = rect.height;
			win.isMaximized = false;
			win.restoreRect = null;
		} else {
			win.restoreRect = {
				x: win.rect.x,
				y: win.rect.y,
				width: win.rect.width,
				height: win.rect.height
			};
			win.rect.x = 0;
			win.rect.y = 0;
			win.rect.width = 100;
			win.rect.height = 100;
			win.isMaximized = true;
		}
		applyWindowStyles(win);
		bringToFront(id);
		updateTaskbar();
	}

	static function toggleMinimize(id:Int) {
		final win = Lambda.find(State.windows, (w) -> w.id == id);
		if (win == null)
			return;
		win.isMinimized = !win.isMinimized;
		applyWindowStyles(win);
		if (!win.isMinimized) {
			bringToFront(id);
		} else {
			if (State.activeId == id) {
				final visible = Lambda.filter(State.windows, (w) -> !w.isMinimized);
				if (visible.length > 0) {
					bringToFront(visible[visible.length - 1].id);
				} else {
					State.activeId = 0;
				}
			}
		}
		updateTaskbar();
	}

	static function closeWindow(id:Int) {
		final index = Lambda.findIndex(State.windows, (w) -> w.id == id);
		if (index == -1)
			return;
		final win = State.windows[index];
		win.el.remove();
		State.windows.splice(index, 1);
		if (State.activeId == id) {
			final visible = Lambda.filter(State.windows, (w) -> !w.isMinimized);
			State.activeId = visible.length > 0 ? visible[visible.length - 1].id : 0;
			if (State.activeId != 0)
				bringToFront(State.activeId);
		}
		updateTaskbar();
	}

	static function applyWindowStyles(win:WindowObject) {
		final el = win.el;
		if (win.isMaximized) {
			el.classList.add("maximized");
		} else {
			el.classList.remove("maximized");
			el.style.position = "absolute";
			el.style.left = win.rect.x + "cqi";
			el.style.top = win.rect.y + "cqb";
			el.style.width = win.rect.width + "cqi";
			el.style.height = win.rect.height + "cqb";
			el.style.borderRadius = "0.5cqi";
		}
		el.style.zIndex = Std.string(win.zIndex);
		el.style.display = win.isMinimized ? "none" : "flex";
	}

	static function updateTaskbar() {
		MENU_BAR.innerHTML = "";
		Lambda.iter(State.windows, (win) -> {
			final item = document.createElement("div");
			item.className = "taskbar-item";
			if (win.id == State.activeId && !win.isMinimized) {
				item.classList.add("active");
			}
			item.innerHTML = '
                <img src="${win.icon}" style="height: 2cqb; width: auto; margin: 0 0.2cqb;">
                <div style="font-size: 2.5cqb;">${win.title}</div>
            ';
			item.addEventListener("click", (event) -> {
				if (win.isMinimized) {
					win.isMinimized = false;
					applyWindowStyles(win);
				}
				bringToFront(win.id);
			});
			MENU_BAR.appendChild(item);
		});
	}
}
