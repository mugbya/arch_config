-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")

-- local empathy = require("empathy")
-- local myutil = require("myutil")
local fixwidthtextbox = require("fixwidthtextbox")
-- local menu = require("menu")

os.setlocale("")
-- A debugging func
n = function(n) naughty.notify{title="消息", text=tostring(n)} end
last_bat_warning = 0

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
-- beautiful.init("/usr/share/awesome/themes/zenburn/theme.lua")
beautiful.init("/home/mugbya/.config/awesome/theme.lua")


-- This is used later as the default terminal and editor to run.
terminal = "xfce4-terminal"
-- terminal = "xterm"
-- editor = os.getenv("EDITOR") or "nano"
editor = "vim"
--editor_cmd = editor
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    --awful.layout.suit.max.fullscreen,
    --awful.layout.suit.magnifier
}
-- }}}

-- {{{ Functions
function get_memory_usage()
    local ret = {}
    for l in io.lines('/proc/meminfo') do
        local k, v = l:match("([^:]+):%s+(%d+)")
        ret[k] = tonumber(v)
    end
    return ret
end

function string_split(string, pat, plain)
    local ret = {}
    local pos = 0
    local start, stop
    local t_insert = table.insert
    while true do
        start, stop = string:find(pat, pos, plain)
        if not start then
            t_insert(ret, string:sub(pos))
            break
        end
        t_insert(ret, string:sub(pos, start-1))
        pos = stop + 1
    end
    return ret
end

function parse_key(string)
    local t_insert = table.insert
    local parts = string_split(string, '[+-]')
    local last = table.remove(parts)
    local ret = {}
    for _, p in ipairs(parts) do
        p_ = p:lower()
        local m
        if p_ == 'ctrl' then
            m = 'Control'
        elseif p_ == 'alt' then
            m = 'Mod1'
        else
            m = p
        end
        t_insert(ret, m)
    end
    return ret, last
end

_key_map_cache = {}
function map_client_key(client, key_map)
    local t_insert = table.insert
    if _key_map_cache[key_map] then
        keys = awful.util.table.join(client:keys(), _key_map_cache[key_map])
    else
        local keys = {}
        for from, to in pairs(key_map) do
            local mod, key = parse_key(from)
            local key = awful.key(mod, key, function(c)
                awful.util.spawn(
                'xdotool key --window '
                .. c.window .. ' ' .. to)
            end)
            for _, k in ipairs(key) do
                t_insert(keys, k)
            end
        end
        _key_map_cache[key_map] = keys
        keys = awful.util.table.join(client:keys(), keys)
    end
    client:keys(keys)
end
--}}}


-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags_name = { " 终端 ", " Chrome ", " IDEA ", " 文件 ", " Sublime ", " 聊天 ", " GVIM ", " 音乐 ", " 火狐 ", " ^_^ " }
tags_layout = {
    awful.layout.suit.tile,
    awful.layout.suit.tile,
    awful.layout.suit.tile,
    awful.layout.suit.tile,
    awful.layout.suit.tile,
    --empathy,
    awful.layout.suit.tile,
    awful.layout.suit.tile,
    awful.layout.suit.tile,
    awful.layout.suit.tile,
    awful.layout.suit.tile,
    --awful.layout.suit.floating,
}
tags = {}
revtags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag(tags_name, s, tags_layout)
	revtags[s] = {}
    for i, t in ipairs(tags[s]) do
        revtags[s][t] = i
    end
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "编辑配置(&E)", editor_cmd .. " " .. awesome.conffile },
   { "重启配置(&R)", awesome.restart,'/usr/share/icons/gnome/16x16/actions/stock_refresh.png' },
   { "注销(&Q)", awesome.quit,'/usr/share/icons/gnome/16x16/actions/exit.png' }
}

local mymenu = {
  --{ " haroopad", "haroopad", '/usr/share/icons/hicolor/32x32/apps/haroopad.png'},
  { " Shutter", "shutter",   '/usr/share/icons/hicolor/32x32/apps/shutter.png'},
  { " Gimp ", "gimp",'/usr/share/icons/hicolor/32x32/apps/gimp.png'},
  { " Sublime", "subl",      '/usr/share/icons/hicolor/32x32/apps/sublime_text.png'},
  { " &Wireshark", "wireshark", '/usr/share/icons/hicolor/32x32/apps/wireshark.png'},
  --{ " Jitsi", "jitsi","/usr/share/pixmaps/jitsi.svg"},
  { " Pidgin", "pidgin", "/usr/share/icons/hicolor/32x32/apps/pidgin.png"},
  { " xchat ", "xchat", "/usr/share/pixmaps/xchat.png"},
  { " 音频控制器", "pavucontrol","/usr/share/icons/gnome/32x32/apps/multimedia-volume-control.png"},
  { "webstorm ", "jetbrains-webstorm", "/opt/webstorm/bin/webide.png"},
  { " 神 器 ", "intellij-idea-ultimate-edition" , "/usr/share/intellij-idea-ultimate-edition/bin/idea.png"},
  { " pycharm ", "pycharm", "/usr/share/pixmaps/pycharm.png"},
  { " 系统监视器", "gnome-system-monitor", "/usr/share/icons/gnome/48x48/apps/utilities-system-monitor.png"},
  --{ " wps ", "wps -style gtk+", "/usr/share/icons/hicolor/48x48/apps/wps-office-wpsmain.png"},
  --{ " Dia ", "dia ", "/usr/share/icons/hicolor/48x48/apps/dia.png"},
  --{ " Q_Q ", "qq2013", "/opt/longene/qq/qq.png" },
  { " Q_Q ", "wine /opt/TM2013/drive_c/Program\\ Files/Tencent/TM/Bin/TM.exe", "/opt/longene/qq/qq.png" },
  --{ " pgadmin3 ","pgadmin3","/usr/share/pgadmin3/pgAdmin3.png"},
  { " BT ","transmission-gtk","/usr/share/pixmaps/transmission.png"},
  { " 虚拟机", "virtualbox", "/usr/share/pixmaps/VBox.png"},
  { " VStudio ","/opt/VStudio/vstudio","/opt/VStudio/Resources/vstudio.png"},
  { " 百度云盘 ", "bcloud-gui", "/usr/share/bcloud/icons/hicolor/scalable/apps/bcloud.svg"},
  { " Wuala ","wuala","/usr/share/icons/hicolor/64x64/apps/wuala.png"},
 -- { " eclipse ", "/opt/eclipse/eclipse", "/opt/eclipse/icon.xpm"},
  --{ " 0ad ", "0ad -mod=east-asian-locales", "/usr/share/pixmaps/0ad.png"}

}

mymainmenu = awful.menu({ items = { { "  Awesome", myawesomemenu, beautiful.awesome_icon },
              { "  终 端 ", terminal,'/usr/share/icons/gnome/32x32/apps/utilities-terminal.png' },
				      { "  文 件(&T) ", "nautilus", '/usr/share/icons/gnome/32x32/apps/system-file-manager.png'},
				      { "  Chrome(&C)", "google-chrome-stable",'/usr/share/icons/hicolor/32x32/apps/google-chrome.png' },
				      { "  火 狐(&F)", "firefox", '/usr/share/icons/hicolor/32x32/apps/firefox.png'},
				      { "  G&VIM", "gvim", '/usr/share/pixmaps/gvim.png' },
              { "  常用工具", mymenu },
              { "  关机 (&H)", "systemctl poweroff", '/usr/share/icons/gnome/16x16/actions/gtk-quit.png' },
          }})

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox
-- Create a textclock widget
--mytextclock = awful.widget.textclock()
mytextclock = awful.widget.textclock(" %Y年%m月%d日 %H:%M:%S %A ", 1)


-- ooo --------------------------------------- 
-- {{{ memory usage indicator
function update_memwidget()
    local meminfo = get_memory_usage()
    local free
    if meminfo.MemAvailable then
        -- Linux 3.14+
        free = meminfo.MemAvailable
    else
        free = meminfo.MemFree + meminfo.Buffers + meminfo.Cached
    end
    local total = meminfo.MemTotal
    local percent = 100 - math.floor(free / total * 100 + 0.5)
    memwidget:set_markup('Mem <span color="#90ee90">'.. percent ..'%</span>')
end
memwidget = fixwidthtextbox('Mem ??')
memwidget.width = 55
update_memwidget()
mem_clock = timer({ timeout = 5 })
mem_clock:connect_signal("timeout", update_memwidget)
mem_clock:start()
-- }}}


-- {{{ CPU Temperature
function update_cputemp()
    local pipe = io.popen('sensors')
    if not pipe then
        cputempwidget:set_markup('CPU <span color="red">ERR</span>℃')
        return
    end
    local temp = 0
    for line in pipe:lines() do
        local newtemp = line:match('^Core [^:]+:%s+%+([0-9.]+)°C')
        if newtemp then
            newtemp = tonumber(newtemp)
            if temp < newtemp then
                temp = newtemp
            end
        end
    end
    pipe:close()
    cputempwidget:set_markup('CPU <span color="#008000">'..temp..'</span>℃')
end
cputempwidget = fixwidthtextbox('CPU ??℃')
cputempwidget.width = 60
update_cputemp()
cputemp_clock = timer({ timeout = 5 })
cputemp_clock:connect_signal("timeout", update_cputemp)
cputemp_clock:start()
-- }}}


-- Create the wibox
--mywibox[s] = awful.wibox({ position = "top", height = "18", screen = s })

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({
                                                      theme = { width = 250 }
                                                  })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right  ooo
    local right_layout = wibox.layout.fixed.horizontal()

    -- right_layout:add(memwidget)
    -- right_layout:add(cputempwidget)

    if s == 1 then right_layout:add(wibox.widget.systray()) end    
    right_layout:add(mytextclock)
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.movetotag(tag)
                          end
                     end
                  end),
        -- Toggle tag.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.toggletag(tag)
                          end
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}



-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

------------------------------------------------

function myfocus_filter(c)
  if awful.client.focus.filter(c) then
    -- This works with tooltips and some popup-menus
    if c.class == 'Wine' and c.above == true then
      return nil
    elseif c.class == 'Wine'
      and c.type == 'dialog'
      and c.skip_taskbar == true
      and c.size_hints.max_width and c.size_hints.max_width < 160
      then
      -- for popup item menus of Photoshop CS5
      return nil
    else
      return c
    end
  end
end

awful.rules.rules = {
  -- All clients will match this rule.
  {
    rule = { },
    properties = {
      -- 这里使用我们自己的函数
      focus = myfocus_filter,
      -- 以下是默认的部分
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      keys = clientkeys,
      buttons = clientbuttons,
    }
  }, {
    rule_any = { 
      instance = {'TM.exe', 'QQ.exe'},
    },
    properties = {
      -- This, together with myfocus_filter, make the popup menus flicker taskbars less
      -- Non-focusable menus may cause TM2013preview1 to not highlight menu
      -- items on hover and crash.
      focusable = true,
      floating = true,
      -- 去掉边框
      border_width = 0,
    }
  }, {
    -- 其它规则
  }
}

alt_switch_keys = awful.util.table.join(
    -- it's easier for a vimer to manage this than figuring out a nice way to loop and concat
    awful.key({'Mod1'}, 1, function(c) awful.util.spawn('xdotool key --window ' .. c.window .. ' ctrl+1') end),
    awful.key({'Mod1'}, 2, function(c) awful.util.spawn('xdotool key --window ' .. c.window .. ' ctrl+2') end),
    awful.key({'Mod1'}, 3, function(c) awful.util.spawn('xdotool key --window ' .. c.window .. ' ctrl+3') end),
    awful.key({'Mod1'}, 4, function(c) awful.util.spawn('xdotool key --window ' .. c.window .. ' ctrl+4') end),
    awful.key({'Mod1'}, 5, function(c) awful.util.spawn('xdotool key --window ' .. c.window .. ' ctrl+5') end),
    awful.key({'Mod1'}, 6, function(c) awful.util.spawn('xdotool key --window ' .. c.window .. ' ctrl+6') end),
    awful.key({'Mod1'}, 7, function(c) awful.util.spawn('xdotool key --window ' .. c.window .. ' ctrl+7') end),
    awful.key({'Mod1'}, 8, function(c) awful.util.spawn('xdotool key --window ' .. c.window .. ' ctrl+8') end),
    awful.key({'Mod1'}, 9, function(c) awful.util.spawn('xdotool key --window ' .. c.window .. ' ctrl+9') end)
)
function bind_alt_switch_tab_keys(client)
    client:keys(awful.util.table.join(client:keys(), alt_switch_keys))
end -- }}}

client.connect_signal("manage", function (c, startup)
  -- 其它配置

  if c.instance == 'TM.exe' then
    -- 添加 Alt+n 支持
    bind_alt_switch_tab_keys(c)
    -- 关闭各类新闻通知小窗口
    if c.name and c.name:match('^腾讯') and c.above then
      c:kill()
    end
  end

  -- 其它配置
end)
