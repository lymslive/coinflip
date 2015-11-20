local tipLine

tipLine = {
    [1] = {
	id = "welcome",
	en = "Welcome to Coin Flip, tap START to have fun",
	zh = "翻金币欢迎您，点击 START 开始游戏吧",
	tag = "mainsc",
    },
    [2] = {
	id = "quick", 
	en = "Many Thanks to Quick-Cocos2d-x 3.5",
	zh = "本游戏用 Quick-Cocos2d-x 3.5 开发", 
	tag = "mainsc",
    },
    [3] = {
	id = "author",
	en = "Author: lymslive (403708621@qq.com)",
	zh = "制作者：lymslive (403708621@qq.com)",
	tag = "mainsc",
    },
    [4] = {
	id = "sample",
	en = "Based and Sourced from: quick/samples/coinflip",
	zh = "本游戏源自 quick 自带的例程 coinflip",
	tag = "mainsc",
    },
    [5] = {
	id = "select",
	en = "Tap a unlocked button which isn't under gray",
	zh = "请选择一个关卡，灰色按钮是暂时锁定未过关的",
	tag = "choosesc",
    },
    [6] = {
	id = "slide",
	en = "The levels panel can scroll right or left",
	zh = "关卡选择页可以左右滑动哦",
	tag = "choosesc",
    },
    [7] = {
	id = "caselevel",
	en = "Yellow complete, pink new, and gray is locked level",
	zh = "三种关卡状态，黄色的已过关，粉晕的新开启，灰色的未解锁",
	tag = "choosesc",
    },
    [8] = {
	id = "unlocknext",
	en = "Auto unlock next level if complete one new level",
	zh = "过关后将自动解锁下一关",
	tag = "choosesc",
    },
    [9] = {
	id = "target",
	en = "Flip all the coins to gold face, and win",
	zh = "将所有硬币翻到金色朝上即为胜利",
	tag = "playsc",
    },
    [10] = {
	id = "retry",
	en = "Tap Retry and recover the original board",
	zh = "Retry 按钮可重置到开局局面",
	tag = "playsc",
    },
    [11] = {
	id = "backchoose",
	en = "Tap Back to return the choose level panel",
	zh = "Back 按钮可返回到关卡选择界面",
	tag = "playsc",
    },
    [12] = {
	id = "moregame",
	en = "Here list cumstom levels, yes, you can create",
	zh = "这里列出自定义的关卡，你也可以自己创建关卡的",
	tag = "moresc",
    },
    [13] = {
	id = "mostsave",
	en = "Save 16 cumstom levels at most, push out the oldest if needed",
	zh = "注意最多保存16个自定义关卡，过量时将挤出最早创建的关卡",
	tag = "moresc",
    },
    [14] = {
	id = "lastsave",
	en = "The newly created level is always save as the last button",
	zh = "最近创建的关卡总是保存在最后一个按钮",
	tag = "moresc",
    },
    [15] = {
	id = "creat",
	en = "Flip some coin face to silver, then Export the bord",
	zh = "将一些硬币翻成银币，然后按 Export 导出当前局面",
	tag = "createsc",
    },
    [16] = {
	id = "random",
	en = "Tap Random if be lazy to design the board",
	zh = "如果不想费心去设计局面，按 Random 随机翻币吧",
	tag = "createsc",
    },
    [17] = {
	id = "resume",
	en = "Tap Resume to recover all coins",
	zh = "Rrsume 按钮重置所有硬币，重新设计",
	tag = "createsc",
    },
    [18] = {
	id = "set",
	en = "Tap Set to set the board template",
	zh = "Set 按钮用于设计棋盘模板",
	tag = "createsc",
    },
    [19] = {
	id = "corner",
	en = "Touch a grid as the top-right corner to define board range",
	zh = "点击一个格子，作为棋盘大小范围的右上角",
	tag = "setsc",
    },
    [20] = {
	id = "minrange",
	en = "The minimum board size is 2 rows by 2 colums",
	zh = "棋盘最小允许是2行2列",
	tag = "setsc",
    },
    [21] = {
	id = "hole",
	en = "Try to tap Hole if want to define a hold in the board",
	zh = "Hole 按钮可用于定义棋盘中的一个空洞",
	tag = "setsc",
    },
    [22] = {
	id = "togglehole",
	en = "In Hole mode touch to add a hole or remove a existed hole",
	zh = "在空洞模式点击某格，增加空洞或移除原来的空洞",
	tag = "setsc",
    },
    [23] = {
	id = "labelbutton",
	en = "Text labels are almost functional button except with colon :",
	zh = "文本标签几乎都是可点击按钮，当然带冒号的说明文字除外",
	tag = "common",
    },
    [24] = {
	id = "strategy",
	en = "Have some strategy to flip the coins? I don't known either",
	zh = "翻金币有什么技巧策略吗，我不知道，不用谢",
	tag = "common",
    },
    [25] = {
	id = "solvable",
	en = "Is some board unsolvable? The created custome must be solvable",
	zh = "是否有些局不可解呢？至少自定义创建的关卡肯定可逆可解",
	tag = "common",
    },
    [26] = {
	id = "baserule",
	en = "Touch coin to flip, and the cross neighbour flip too",
	zh = "点击翻金币，相邻十字形的金币一起翻",
	tag = "common",
    },
    [27] = {
	id = "love",
	en = "I love vim, I love lua, and now quick cocos2d-x",
	zh = "某人说，他喜欢 vim, lua, 还有 quick cocos2d-x",
	tag = "common",
    },
    [28] = {
	id = "backpre",
	en = "Each sub-scene has a Back in right-bottom to return previous",
	zh = "每个子场景右下都有一个 Back 按钮，用以返回前一场景",
	tag = "common",
    },
}

return tipLine
