import js.lib.Promise;
import js.Browser.*;
import js.html.*;

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

class Util {
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
		"settings_fullscreen" => ["Is fullscreen", "全屏模式", "全螢幕模式",],
		"settings_language" => ["Language", "语言", "語言",],
		"hint_restart_game" => ["Please restart game to apply settings!", "请重启游戏以应用设置修改！", "請重新啟動遊戲以套用設定！"],
		"recycle_is_empty" => ["Recycle Bin is empty", "回收站为空", "資源回收筒是空的"],
		"hint" => ["Hint", "提示", "提示",],
		"contact_me" => ["Me", "我", "我"],
		"contact_manager_horse" => ["Manager Horse", "马经理", "馬經理"],
		"contact_wife" => ["My dear wife", "我亲爱的老婆", "老婆大人"],
		"contact_author" => ["The Author", "作者", "作者"],
		"cp_c_backup" => ["Backup", "备份", "備份"],
		"cp_c_backup_horse_crazy" => ["Surveillance.mp4", "监控视频.mp4", "監控錄像.mp4"],
		"cp_d_video" => ["Video", "视频", "影片"],
		"cp_d_document" => ["Document", "文档", "文檔"],
		"cp_d_picture" => ["Picture", "图片", "圖片"],
		"file_or_folder_cannot_open" => ["The file cannot be opened", "此文件无法打开", "無法開啟此文件"],
		"file_or_folder_need_password" => ["The file requires a password. Please enter it:", "此文件需要密码，请输入：", "此文件需要密碼，請輸入："],
		"file_or_folder_incorrect_password" => ["Incorrect password!", "密码错误！", "密碼錯誤！"],
		"cp_d_document_marry_10th" => ["secret_10th_anniversary.txt", "结婚 10 周年的秘密.txt", "結婚 10 週年的祕密.txt"],
		"internet_keyword_marry_1" => ["wife", "老婆", "老婆"],
		"internet_keyword_marry_2" => ["marry", "结婚", "結婚"],
		"internet_keyword_marry_3" => ["10th", "十周年", "十週年"],
		"internet_keyword_password_1" => ["password", "密码", "密碼"],
		"internet_marry" => [
			'<p>marry date, plus 10th_anniversary, the date in front, 10 year in back, combine to get password!</p>',
			'<p>相遇日期，配上 10 周年，日期在前，10 周年在后，组合起来是什么密码呢？</p>',
			'<p>相遇日期，配上 10 週年，日期在前，10 週年在後，組合起來是什麼密碼呢？</p>'
		],
		"internet_password" => [
			'<p>Passwords are always pure numbers, never mixed with some English letters</p>',
			'<p>密码永远都是纯数字，不包含任何英文字母</p>',
			'<p>密碼永遠都是純數字，不包含任何英文字母</p>'
		],
		"internet_empty" => [
			'<h1>Prompt Browser</h1>
		<p>If you enter some words in the website bar, you will receive corresponding prompts!</p>
		<p>By the way, this is only a hint for the game, even if you never open the browser, you can continue playing!</p>
		<p>Current, all keywords is:</p>
		<ul>
			<li>wife</li>
			<li>password</li>
		</ul>',
			'<h1>提示浏览器</h1>
		<p>如果你在网址栏输入一些词语，你会得到一些提示！</p>
		<p>顺便提一嘴，这个仅作为游戏的提示，如果你从不打开浏览器，也是可以顺利游玩游戏的！</p>
		<p>目前，所有提示词如下：</p>
		<ul>
			<li>老婆</li>
			<li>密码</li>
		</ul>',
			'<h1>提示瀏覽器</h1>
		<p>如果你在網址欄輸入一些詞語，你會得到相應的提示！</p>
		<p>順帶一提，這僅作為遊戲的提示，即使你從不打開瀏覽器，也能順利遊玩！</p>
		<p>目前，所有提示詞如下：</p>
		<ul>
			<li>老婆</li>
			<li>密碼</li>
		</ul>',
		],
		"cp_d_document_marry_10th_doc" => [
			'<p>Haha, I\'m your wife, I\'m so sorry to open your computer.. I just want to record where I put the gift in your farm!</p>
		<p>This gift is in the haystack of your farm. Perhaps you have forgotten, But I told your horse.</p>
		<p>Before the approaching date, your horse will remind you!</p>',
			'<p>嘿嘿！我是你的妻子哦！我很抱歉打开了你的电脑，我只是想记录一下我把礼物放在你农场的哪个位置罢了！</p>
		<p>这个礼物在你的农场的干草垛里面。也许你已经忘了，但是我把这个消息告诉了你的马儿。</p>
		<p>在日期临近时，你的马儿会告诉你礼物的位置的！</p>',
			'<p>嘿嘿！我是你的妻子哦！我很抱歉打開了你的電腦，我只是想記錄一下我把禮物放在你農場的哪個位置罷了！</p>
		<p>這個禮物在你的農場的乾草堆裡面。也許你已經忘了，但是我把這個消息告訴了你的馬兒。</p>
		<p>在日期臨近時，你的馬兒會告訴你禮物的位置的！</p>',
		],
		"cp_c_backup_ring_img" => ["Metal_Becket.png", "金属环图片.png", "金屬環圖片.png"],
		"cp_c_picture_family" => ["Family.png", "全家福.png", "全家福.png"],
		"wechat_wife_call_1" => ["Happy 10th anniversary, honey!", "十周年快乐，亲爱的！", "結婚十週年快樂，親愛的！",],
		"wechat_wife_call_2" => ["I can't believe it's been 10 years!", "真不敢相信已经十年了！", "真不敢信已經十週年了哦！",],
		"wechat_wife_call_3" => ["If you are busy, I can come back later~~", "如果你在忙的话，那等会见~~", "你要是在忙的話，那等會見~~",], // 修正：I you -> If you
		"wechat_wife_call_4" => [
			"If you think back to January 16th, it was our first meeting.",
			"如果你想起了 1 月 16 日，那是我们的第一次相遇。",
			"想到了當初 1 月 16 日，那是我們的第一次相遇。",
		],
		"wechat_wife_call_5" => [
			"We only met for 3 months before getting married! Sounds great! don't you?",
			"我们只过了 3 个月多天就结婚了！听起来可太棒了！不是吗？",
			"我們只過了 3 個月多天就結婚了！聽起來可太棒了！不是嗎？",
		],
		"wechat_helper_call_1" => ["Help!!", "救命！", "救命！",],
		"wechat_helper_call_2" => ["These horses are crazy!", "这些马疯了！", "這些馬瘋了！",],
		"wechat_helper_call_3" => ["You must check the surveillance!", "你一定要看一下监控！", "你一定要看一下監控！",],
		"wechat_helper_call_4" => [
			"The surveillance is saved in your computer's C:\\Backup\\Surveillance.mp4, remember to check it!",
			"监控存在你电脑上的 C:\\Backup\\监控视频.mp4，记得看！",
			"監控錄像已儲存於你電腦的 C:\\Backup\\監控錄像.mp4，記得查看！",
		],
		"wechat_helper_call_5" => ["Ok, I just checked it, what happened?", "好，我刚检查了，发生了什么？", "好，我剛檢查了，發生了什麼？",],
		"wechat_helper_call_6" => [
			"I don't know, the horse suddenly went crazy. I really don't know what happened...",
			"我不知道，马突然间就疯掉了。我真不知道发生了什么……",
			"我不知道，馬突然間就瘋掉了。我真不知道發生了什麼……",
		],
		"wechat_helper_call_7" => [
			"Please wait a moment, I can handle this trouble!",
			"请等一会，我能搞定这个麻烦！",
			"請等一會，我能搞定這個麻煩！",
		],
		"wechat_helper_call_8" => [
			"Hmm, I discovered something shining brightly in your haystack, the image is sent to your C:\\Backup\\Metal_Becket.png",
			"嗯，我在你的干草垛发现了一个闪闪发光的东西。图片发到你的 C:\\Backup\\金属环图片.png 了",
			"嗯，我在你的乾草堆發現了一個閃閃發光的東西。圖片發到你的 C:\\Backup\\金屬環圖片.png 了",
		],
		"wechat_helper_call_9" => ["wait, a shining brightly thing?", "等等，是一个闪闪发光的东西吗？", "等等，是一個閃閃發光的東西嗎？",],
		"wechat_helper_call_10" => [
			"Horses are startled when they see shiny things, the farm lights are so bright. No wonder horses run around!",
			"马匹看见闪亮的东西会受惊，农场的灯这么亮。怪不得马会乱跑！",
			"馬兒看見閃閃的東西會受驚，農場的燈這麼亮，怪不得馬會亂跑！",
		],
		"wechat_helper_call_11" => ["Oh no!", "哦不！", "哦不！",],
		"wechat_helper_call_12" => [
			"The horse doesn't allow me to pick up that thing!",
			"马根本不允许我捡起那个东西！",
			"馬根本不允許我撿起那個東西！",
		],
		"wechat_helper_call_13" => ["Trying to pick it out with a stick?", "试试用一根木棍挑出来？", "試試用一根木棍挑出來？",],
		"wechat_helper_call_14" => ["Okay, I'll try!", "好的，我会试试看！", "好的，我會試試看！",],
		"wechat_helper_call_15" => [
			"No, the horse still doesn't allow me to pick it out! but I see, it's a ring!",
			"不，马还是不允许我捡起那个东西！但是我看见了，那是一枚戒指！",
			"不，馬還是不允許我撿起那個東西！但是我看見了，那是一枚戒指！",
		],
		"wechat_helper_call_16" => ["maybe the horse is protecting it?", "马该不会是在保护它？", "馬該不會是在保護它？",], // 修正：are -> is
		"wechat_helper_call_17" => [
			"Protecting? are you crazy? it's just an animal!",
			"保护？你疯了吗？它们不过只是动物！",
			"保護？你瘋了嗎？它們不過只是動物！",
		],
		"wechat_helper_call_18" => [
			"Anyway, To prevent the horse from going crazy again, you need to pick it!",
			"无论如何，为了防止马再次发疯，你需要把它捡起来！",
			"無論如何，為了防止馬再次發瘋，你需要把它撿起來！",
		],
		"wechat_helper_call_19" => [
			"Okay, I'll try! During this period, you can check if there are any clues on your computer",
			"好的，我会试试看！在此之前，你可以检查一下你的电脑上有没有什么线索。",
			"好的，我會試試看！在此之前，你可以檢查一下你的電腦上有沒有什麼線索。",
		],
		"wechat_hint_call_1" => [
			"Find some clues on your computer pointing to that ring-like thing.",
			"在你的电脑上找到一些指向那个看似戒指的东西的线索。",
			"在你的電腦上找到一些指向那個看似戒指的東西的線索。",
		],
		"wechat_helper_call_20" => ["hmm, I found a file about my wife.", "嗯，我找到了一个关于我妻子的文件。", "嗯，我找到了一個關於我妻子的文件。",],
		"wechat_helper_call_21" => ["maybe that ring is my wife's gift!", "也许那枚戒指是我妻子送我的礼物。", "也許那枚戒指是我妻子送我的禮物。",],
		"wechat_helper_call_22" => [
			"Oh Jesus, I forgot... You and your wife's 10th Anniversary is next week.",
			"我的天，我忘了，你和你妻子的 10 周年纪念日就在下周。",
			"我的天，我忘了，你和你妻子的 10 周年紀念日就在下週。",
		],
		"wechat_helper_call_23" => [
			"Your horse is also helping you keep the secret!",
			"你的马儿也在帮你保守秘密呢！",
			"你的馬兒也在幫你保守祕密呢！",
		],
		"wechat_hint_call_2" => [
			"The 10th Anniversary is next week, go say hi to your wife!",
			"十周年纪念日就在下周，快和你的妻子打个招呼吧！",
			"十周年紀念日就在下週，快和你的妻子打個招呼吧！",
		],
		"wechat_helper_call_24" => ["Alright, I just helped you pick it up!", "好啦，我刚帮你把它拿出来了！", "好啦，我剛幫你把它拿出來了！",],
		"wechat_helper_call_25" => ["Ok, thank you!", "好啦，谢谢你啦！", "好啦，謝謝你啦！",],
		"wechat_helper_call_26" => [
			"Your wife is really hardworking, she can come up with this method of hiding in a haystack.",
			"你老婆也真是够拼的，藏草垛里这种办法也能想出！",
			"你老婆也真是夠拼的，藏草堆裡這種辦法也能想出！",
		],
		"wechat_wife_call_6" => [
			"Good morning, my dear, You have some little secrets that I have found~",
			"早上好，亲爱的，你有一些小秘密被我发现咯~",
			"早上好，親愛的，你有一些小祕密被我發現咯~",
		],
		"wechat_wife_call_7" => ["Give you a keyword: THE HAYSTACK!", "给你个关键词：草垛！", "給你個關鍵詞：草堆！",],
		"wechat_wife_call_8" => ["Oh, you found it! who told you?", "哦，你发现了！是谁告诉你的？", "哦，你發現了！是誰告訴你的？",],
		"wechat_wife_call_9" => [
			"It's our horse! you told it your gift is here, then it promised to protect your gift!",
			"是我们的马！你告诉了你的礼物在这，于是它就保证要保护这个礼物！",
			"是我們的馬！你告訴了你的禮物在這，因此它就保證要保護這個禮物！",
		],
		"wechat_wife_call_10" => [
			"Really? That's fantastic! I never thought about this!",
			"真的吗？太不可思议了！我从未想过这个！",
			"真的嗎？太不可思議了！我從未想過這個！",
		],
		"wechat_wife_call_11" => [
			"Hey, Why not go to the farm and hug me?",
			"嘿，为什么不去农舍，随后拥抱我？",
			"嘿，為什麼不去農舍，隨後擁抱我？",
		],
		"wechat_wife_call_12" => ["I'm sure! why not?", "当然啦，为什么不？", "當然啦，為什麼不？",],
		"wechat_hint_call_3" => [
			"Soon after, you and your wife arrive at the farm. The Manager Horse has already set up the camera.",
			"一会后，你和你的妻子到达了农舍。马经理已经架好了摄像机。",
			"一會後，你和你的妻子到達了農舍。馬經理已經架好了攝像機。",
		],
		"wechat_hint_call_4" => [
			"You and your wife stood up, and then Manager Horse gave the order.",
			"你和你的妻子站好了，随后马经理一声令下。",
			"你和你的妻子站好了，隨後馬經理一聲令下。",
		],
		"wechat_hint_call_5" => ["Ok, three two one, smile!", "好啦！3，2，1，茄子！", "好啦！3，2，1，茄子！",],
		"wechat_hint_call_6" => [
			"The photo is saved on your D:\\Picture\\Family.png",
			"照片已经存在你的 D:\\Picture\\全家福.png",
			"照片已經存在你的 D:\\Picture\\全家福.png",
		],
		"wechat_author_call_1" => [
			"Hello, I'm the author of this visual novel game.",
			"你好，我是这个视觉小说的作者！",
			"你好，我是這個視覺小說的作者！",
		],
		"wechat_author_call_2" => ["Anyway, the game is over!", "无论如何，游戏已经结束了！", "無論如何，遊戲已經結束了！",],
		"wechat_author_call_3" => [
			"This is a framework that my partner and I spent 5 days cobbling together.",
			"这是我和我另一位同伴花了 5 天时间搓出来的框架。",
			"這是我和我另一位同伴花了 5 天時間搓出來的框架。",
		],
		"wechat_author_call_4" => [
			"The remaining two days were for localization translation and writing copy logic.",
			"剩下两天分别是本地化翻译和书写文案逻辑。",
			"剩下兩天分別是本地化翻譯和書寫文案邏輯。",
		],
		"wechat_author_call_5" => [
			"My partner is in charge of UI design and translation, while I'm responsible for programming.",
			"我同伴担任画 UI 和翻译，我负责写程序。",
			"我同伴擔任畫 UI 和翻譯，我負責寫程式。",
		],
		"wechat_author_call_6" => [
			"Before this, I only wrote front-end JavaScript. Ever since I encountered Haxe, I've been hooked!",
			"在此之前，我只写过前端 JavaScript，自从我遇到了 Haxe，我就一发不可收拾！",
			"在此之前，我只寫過前端 JavaScript，自從我遇到了 Haxe，我就一發不可收拾！",
		],
		"wechat_author_call_7" => [
			"Haxe's type system makes me happy! I know exactly how to write this part, and how to write that part.",
			"Haxe 的类型让我感到愉悦！我非常清楚这个地方应该这么写。那个地方应该那样写。",
			"Haxe 的類型讓我感到愉悅！我非常清楚這個地方應該這麼寫，那個地方應該那樣寫。",
		],
		"wechat_author_call_8" => [
			"Its type constraints are even better than TypeScript!",
			"它的类型约束甚至比 TypeScript 还要棒！",
			"它的類型約束甚至比 TypeScript 還要棒！",
		],
		"wechat_author_call_9" => [
			"My team and I are well aware that this novel is very short, but it was all typed word by word, letter by letter, by hand!",
			"我和我的团队十分清楚这篇小说写的非常短，但全程都是我们一句话一句话一个字母一个字母手敲的！",
			"我和我的團隊十分清楚這篇小說寫的非常短，但全程都是我們一句話一句話一個字母一個字母手敲的！",
		],
		"wechat_author_call_10" => [
			"Anyway, thank you very much for playing! thanks pixabay for providing the pictures, thanks Photoshop for editing picture!",
			"无论如何，还是非常感谢您的游玩！感谢 pixabay 提供了图片素材，感谢 PS 供我修图！",
			"無論如何，還是非常感謝您的遊玩！感謝 pixabay 提供了圖片素材，感謝 PS 供我修圖！",
		],
		"wechat_author_call_11" => ["Looking forward to our next meeting!", "期待我们的下次见面吧！", "期待我們的下次見面吧！",],
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

	public static var State:WindowState = {
		windows: [],
		nextId: 0,
		activeId: 0,
		maxZIndex: 10,
		isDragging: null,
	};

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
