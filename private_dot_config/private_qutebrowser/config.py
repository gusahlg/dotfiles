config.load_autoconfig()

c.tabs.position = "left"
c.tabs.width = "14%"
c.tabs.show = "switching"
c.tabs.title.format = "{index}: {current_title}"
c.tabs.title.format_pinned = "[{index}] {host}"

c.editor.command = ["rio", "-e", "nvim", "{file}"]

c.url.searchengines = {
    "DEFAULT": "https://search.brave.com/search?q={}",
}
c.url.start_pages = ["https://search.brave.com"]
c.url.default_page = "https://search.brave.com"

c.statusbar.position = "top"
c.statusbar.show = "always"
c.statusbar.widgets = [
    "keypress",
    "search_match",
    "url",
    "scroll",
    "tabs",
]

c.colors.webpage.preferred_color_scheme = "dark"
c.colors.webpage.darkmode.enabled = True

c.colors.statusbar.normal.bg = "#111111"
c.colors.statusbar.normal.fg = "#e5e5e5"
c.colors.statusbar.insert.bg = "#1f4d2e"
c.colors.statusbar.command.bg = "#1a1a1a"

c.colors.tabs.bar.bg = "#0f0f0f"
c.colors.tabs.selected.even.bg = "#1d1d1d"
c.colors.tabs.selected.odd.bg = "#1d1d1d"
c.colors.tabs.even.bg = "#141414"
c.colors.tabs.odd.bg = "#141414"

c.hints.chars = "arstgmneio"
c.hints.auto_follow = "full-match"
c.keyhint.delay = 0

c.url.yank_ignored_parameters += ["fbclid", "si"]
c.window.hide_decoration = True

config.bind('go', 'cmd-set-text -s :quickmark-load')
config.bind('gn', 'cmd-set-text -s :quickmark-load --tab')
config.bind('gO', 'cmd-set-text :open {url:pretty}')
config.bind('gN', 'cmd-set-text :open -t {url:pretty}')
