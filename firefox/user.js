// Mozilla User Preferences, see:
// - https://kb.mozillazine.org/User.js_file
// - https://hg.mozilla.org/mozilla-central/file/tip/browser/app/profile/firefox.js
// Most of the settings are taken from: https://github.com/yokoffing/Betterfox/tree/68c1d0cefcda61812b023772198013c57363fd94

// Settings -> General -> General -> Startup: Open previous windows and tabs = true
user_pref("browser.startup.page", 3);

// Settings -> General -> General -> Tabs: Confirm before quitting with Ctrl+Q
user_pref("browser.warnOnQuitShortcut", false);

// Settings -> General -> Language and Appearance -> Fonts
// - Fonts for: `Latin`
// - Proportional: `Sans Serif` Size: `16`
// - Serif: `Liberation Serif`
// - Sans-serif: `Liberation Sans`
// - Monospace: `Hack` Size: `16`
// - Minimum font size: `None`
user_pref("font.default.x-western", "sans-serif");
user_pref("font.name.monospace.x-western", "Hack");
user_pref("font.name.sans-serif.x-western", "Liberation Sans");
user_pref("font.name.serif.x-western", "Liberation Serif");
user_pref("font.size.monospace.x-western", 16);

// Settings -> General -> Language and Appearance -> Language: English US, English, Polish
user_pref("intl.accept_languages", "en-us,en,pl");
user_pref("pref.browser.language.disable_button.down", false);
user_pref("javascript.use_us_english_locale", true);

// Settings -> General -> Files and Applications -> Applications -> What should Firefox do with other files = Ask whether to open or save files
user_pref("browser.download.always_ask_before_handling_new_types", true);

// Settings -> General -> Files and Applications -> Digital Rights Management (DRM) Content: play DRM-controlled content = true
user_pref("media.eme.enabled", true);

// Settings -> General -> Browsing: Enable picture-in-picture video controls = false
user_pref("media.videocontrols.picture-in-picture.video-toggle.enabled", false);

// Settings -> Home -> Home -> New Windows and Tabs: Homepage and new windows = Blank Page
user_pref("browser.startup.homepage", "chrome://browser/content/blanktab.html");

// Settings -> Home -> Home -> New Windows and Tabs: New tabs = Blank Page
user_pref("browser.newtabpage.enabled", false);

// Settings -> Home -> Home -> Firefox Home Content: Shortcuts = false
user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);

// Settings -> Home -> Home -> Firefox Home Content -> Shortcuts -> Sponsored shortcuts = false
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);

// Settings -> Home -> Home -> Firefox Home Content -> Recent activity = false
user_pref("browser.newtabpage.activity-stream.feeds.section.highlights", false);

// Settings -> Search -> Search -> Search Suggestions -> Provide search suggestions = false
// PREF: disable live search engine suggestions (Google, Bing, etc.)
// [WARNING] Search engines keylog every character you type from the URL bar
user_pref("browser.search.suggest.enabled", false);

// Settings -> Search -> Search -> Search Shortcuts: hide Amazon.com and Bing
user_pref("browser.search.hiddenOneOffs", "Amazon.com,Bing");

// Settings -> Search -> Search -> Search Shortcuts: hide Tabs
user_pref("browser.urlbar.shortcuts.tabs", false);

// Settings -> Privacy & Security -> Browser Privacy -> Enhanced Tracking Protection = Strict
user_pref("browser.contentblocking.category", "strict");
user_pref("network.http.referer.disallowCrossSiteRelaxingDefault.top_navigation", true);
user_pref("privacy.annotate_channels.strict_list.enabled", true);
user_pref("privacy.partition.network_state.ocsp_cache", true);
user_pref("privacy.query_stripping.enabled", true);
user_pref("privacy.query_stripping.enabled.pbmode", true);
user_pref("privacy.trackingprotection.emailtracking.enabled", true);
user_pref("privacy.trackingprotection.enabled", true);
user_pref("privacy.trackingprotection.socialtracking.enabled", true);

// Settings -> Privacy & Security -> Browser Privacy -> Logins and Passwords: Ask to save logins and passwords for websites = false
// Disable password manager (use an external password manager!)
user_pref("signon.rememberSignons", false);

// Settings -> Privacy & Security -> Browser Privacy -> Address Bar: Open tabs = false
user_pref("browser.urlbar.suggest.openpage", false);

// Settings -> Privacy & Security -> Browser Privacy -> Address Bar: Shortcuts = false
user_pref("browser.urlbar.suggest.topsites", false);

// Settings -> Privacy & Security -> Browser Privacy -> Address Bar: Search engines = false
user_pref("browser.urlbar.suggest.engines", false);

// Settings -> Privacy & Security -> Browser Privacy -> Address Bar: History
user_pref("browser.urlbar.suggest.history", true);

// Settings -> Privacy & Security -> Permissions -> Notifications -> Settings: Block new requests asking to allow notifications = true
user_pref("permissions.default.desktop-notification", 2);

// Settings -> Privacy & Security -> Permissions -> Autoplay -> Settings: Default for all websites: Block Audio and Video
user_pref("media.autoplay.default", 5);

// Settings -> Privacy & Security -> Firefox Developer Edition Data Collection and Use -> Allow Firefox Developer Edition to send technical and interaction data to Mozilla = false
user_pref("datareporting.healthreport.uploadEnabled", false);

// Settings -> Privacy & Security -> Security -> HTTPS-Only Mode: Enable HTTPS-Only Mode in all windows
user_pref("dom.security.https_only_mode", true);
user_pref("dom.security.https_only_mode_ever_enabled", true);
// Additional security measure + fixes ocassional "HTTPS-Only Mode Alert: Secure Connection Not Available"
// https://bugzilla.mozilla.org/show_bug.cgi?id=1683015)
user_pref("dom.security.https_only_mode_send_http_background_request", false);
// Show additional suggestions
user_pref("dom.security.https_only_mode_error_page_user_suggestions", true);

// Settings -> Privacy & Security -> DNS over HTTPS -> Enable secure DNS using: Max protection
// https://wiki.mozilla.org/Trusted_Recursive_Resolver
user_pref("doh-rollout.disable-heuristics", true);
user_pref("network.trr.mode", 3);

// about:config: Disable "Proceed with Caution" warning
user_pref("browser.aboutConfig.showWarning", false);

// Scroll
user_pref("general.smoothScroll.mouseWheel.durationMaxMS", 100);
user_pref("mousewheel.system_scroll_override.enabled", false);

// DuckDuckGo search engine in private windows
user_pref("browser.search.separatePrivateDefault.ui.enabled", true);
user_pref("browser.urlbar.placeholderName.private", "DuckDuckGo");
// enable prompt for searching in a Private Window when using normal browsing window URL bar
// [1] https://old.reddit.com/r/firefox/comments/yg8jyh/different_private_search_option_gone_firefox_106/
user_pref("browser.search.separatePrivateDefault.urlbarResult.enabled", true); // HIDDEN

// Full screen mode warning: shorten duration
user_pref("full-screen-api.warning.delay", 0);
user_pref("full-screen-api.warning.timeout", 300);

// Video hardware acceleration under Wayland
user_pref("media.ffmpeg.vaapi.enabled", true);
user_pref("media.av1.enabled", false); // disable AV1 to force video hardware decoding (my GPU does not hardware-decode av1)

// Disable showing menu on pressing Alt
user_pref("ui.key.menuAccessKeyFocuses", false);

// Dictionaries for both English (US and UK) and Polish
user_pref("spellchecker.dictionary", "en-US,en-GB,pl-PL");

// Reduce animations in browser and supporting web pages
// user_pref("ui.prefersReducedMotion", 1);
// user_pref("devtools.inspector.simple-highlighters.message-dismissed", true);

// Make typing in urlbar select custom url first. It improves over time
user_pref("browser.urlbar.autoFill.adaptiveHistory.enabled", true);

// Customize the navigation bar
user_pref("browser.uiCustomization.state", "{\"placements\":{\"widget-overflow-fixed-list\":[],\"unified-extensions-area\":[\"jid1-mnnxcxisbpnsxq_jetpack-browser-action\",\"_contain-facebook-browser-action\",\"fbpelectrowebext_fbpurity_com-browser-action\",\"gdpr_cavi_au_dk-browser-action\",\"jid1-bofifl9vbdl2zq_jetpack-browser-action\",\"jid1-kkzogwgsw3ao4q_jetpack-browser-action\"],\"nav-bar\":[\"back-button\",\"forward-button\",\"stop-reload-button\",\"_testpilot-containers-browser-action\",\"urlbar-container\",\"downloads-button\",\"ublock0_raymondhill_net-browser-action\",\"unified-extensions-button\"],\"toolbar-menubar\":[\"menubar-items\"],\"TabsToolbar\":[\"firefox-view-button\",\"tabbrowser-tabs\",\"new-tab-button\",\"alltabs-button\"],\"PersonalToolbar\":[\"import-button\",\"personal-bookmarks\"]},\"seen\":[\"save-to-pocket-button\",\"developer-button\",\"_contain-facebook-browser-action\",\"_testpilot-containers-browser-action\",\"fbpelectrowebext_fbpurity_com-browser-action\",\"gdpr_cavi_au_dk-browser-action\",\"jid1-bofifl9vbdl2zq_jetpack-browser-action\",\"jid1-kkzogwgsw3ao4q_jetpack-browser-action\",\"jid1-mnnxcxisbpnsxq_jetpack-browser-action\",\"ublock0_raymondhill_net-browser-action\"],\"dirtyAreaCache\":[\"nav-bar\",\"PersonalToolbar\",\"toolbar-menubar\",\"TabsToolbar\",\"unified-extensions-area\"],\"currentVersion\":19,\"newElementCount\":4}");

// Make the "Show in Folder" for downloaded files be opened in Thunar (still does not select the file, but at least something happens)
user_pref("widget.use-xdg-desktop-portal.open-uri", 1);

// PREF: disable annoying update restart prompts
// Delay update available prompts for ~1 week
// Will still show green arrow in menu bar
user_pref("app.update.suppressPrompts", true);

// PREF: add compact mode back to options
user_pref("browser.compactmode.show", true);
// PREF: select compact mode for UI density
user_pref("browser.uidensity", 1);

// PREF: Mozilla VPN
// [1] https://github.com/yokoffing/Betterfox/issues/169
user_pref("browser.privatebrowsing.vpnpromourl", "");

// PREF: disable about:addons' Recommendations pane (uses Google Analytics)
user_pref("extensions.getAddons.showPane", false); // HIDDEN
user_pref("extensions.htmlaboutaddons.recommendations.enabled", false);

// PREF: disable Firefox from asking to set as the default browser
// [1] https://github.com/yokoffing/Betterfox/issues/166
user_pref("browser.shell.checkDefaultBrowser", false);

// PREF: disable Extension Recommendations (CFR: "Contextual Feature Recommender")
// [1] https://support.mozilla.org/en-US/kb/extension-recommendations
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons", false);
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features", false);

// PREF: hide "More from Mozilla" in Settings
user_pref("browser.preferences.moreFromMozilla", false);

// PREF: only show List All Tabs icon when needed
// true=always show tab overflow dropdown (FF106+ default)
// false=only display tab dropdown when there are too many tabs
// [1] https://www.ghacks.net/2022/10/19/how-to-hide-firefoxs-list-all-tabs-icon/
user_pref("browser.tabs.tabmanager.enabled", false);

// PREF: disable welcome notices
//user_pref("browser.startup.homepage_override.mstone", "ignore"); // What's New page after updates; master switch
user_pref("browser.aboutwelcome.enabled", false); // disable Intro screens
    //user_pref("startup.homepage_welcome_url", "");
    //user_pref("startup.homepage_welcome_url.additional", "");
    //user_pref("startup.homepage_override_url", ""); // What's New page after updates

// PREF: show all matches in Findbar
user_pref("findbar.highlightAll", true);

// PREF: Cookie Banner handling
// [NOTE] Feature still enforces Total Cookie Protection to limit 3rd-party cookie tracking [1]
// [1] https://github.com/mozilla/cookie-banner-rules-list/issues/33#issuecomment-1318460084
// [2] https://phabricator.services.mozilla.com/D153642
// [3] https://winaero.com/make-firefox-automatically-click-on-reject-all-in-cookie-banner-consent/
// [4] https://docs.google.com/spreadsheets/d/1Nb4gVlGadyxix4i4FBDnOeT_eJp2Zcv69o-KfHtK-aA/edit#gid=0
// 2: reject banners if it is a one-click option; otherwise, fall back to the accept button to remove banner
// 1: reject banners if it is a one-click option; otherwise, keep banners on screen
// 0: disable all cookie banner handling
user_pref("cookiebanners.service.mode", 2);
user_pref("cookiebanners.service.mode.privateBrowsing", 2);

// PREF: enable global CookieBannerRules
// This is used for click rules that can handle common Consent Management Providers (CMP)
// [WARNING] Enabling this (when the cookie handling feature is enabled) may
// negatively impact site performance since it requires us to run rule-defined
// query selectors for every page
user_pref("cookiebanners.service.enableGlobalRules", true);

// PREF: smoother font
// [1] https://old.reddit.com/r/firefox/comments/wvs04y/windows_11_firefox_v104_font_rendering_different/?context=3
user_pref("gfx.webrender.quality.force-subpixel-aa-where-possible", true);

// PREF: URL bar suggestions (bookmarks, history, open tabs) / dropdown options in the URL bar
// user_pref("browser.urlbar.suggest.bookmarks", true);
// enable helpful features:
user_pref("browser.urlbar.suggest.calculator", true);
user_pref("browser.urlbar.unitConversion.enabled", true);

// PREF: Disable built-in Pocket extension
user_pref("extensions.pocket.enabled", false);

// PREF: unload tabs on low memory
// Firefox will detect if your computer’s memory is running low (less than 400MB)
// and suspend tabs that you have not used in awhile
// [1] https://support.mozilla.org/en-US/questions/1262073
// [2] https://blog.nightly.mozilla.org/2021/05/14/these-weeks-in-firefox-issue-93/u
user_pref("browser.tabs.unloadOnLowMemory", true); // DEFAULT

// PREF: Prevent scripts from moving and resizing open windows
user_pref("dom.disable_window_move_resize", true);

// PREF: limit events that can cause a pop-up
// Firefox provides an option to provide exceptions for sites, remembered in your Site Settings.
// (default) "change click dblclick auxclick mouseup pointerup notificationclick reset submit touchend contextmenu"
// (alternate) user_pref("dom.popup_allowed_events", "click dblclick mousedown pointerdown");
user_pref("dom.popup_allowed_events", "click dblclick mousedown pointerdown");

// PREF: restore "View image info"
user_pref("browser.menu.showViewImageInfo", true);

// PREF: Disable Reader mode
// Firefox will not have to parse webpage for Reader when navigating.
// Minimal performance impact.
user_pref("reader.parse-on-load.enabled", false);

// PREF: Spell-check
// 0=none, 1-multi-line, 2=multi-line & single-line
user_pref("layout.spellcheckDefault", 2);

// PREF: Hide image placeholders
user_pref("browser.display.show_image_placeholders", false);

// PREF: Wrap long lines of text when using source / debugger
user_pref("view_source.wrap_long_lines", true);
user_pref("devtools.debugger.ui.editor-wrapping", true);

// PREF: enable ASRouter Devtools at about:newtab#devtools (useful if you're making your own CSS theme)
// [1] https://firefox-source-docs.mozilla.org/browser/components/newtab/content-src/asrouter/docs/debugging-docs.html
user_pref("browser.newtabpage.activity-stream.asrouter.devtoolsEnabled", true);
// show user agent styles in the inspector
user_pref("devtools.inspector.showUserAgentStyles", true);
// show native anonymous content (like scrollbars or tooltips) and user agent shadow roots (like the components of an <input> element) in the inspector
user_pref("devtools.inspector.showAllAnonymousContent", true);

// PREF: enable :has() CSS relational pseudo-class
// Needed for some extensions, filters, and customizations
// [1] https://developer.mozilla.org/en-US/docs/Web/CSS/:has
// [2] https://caniuse.com/css-has
user_pref("layout.css.has-selector.enabled", true);

// PREF: disable websites overriding Firefox's keyboard shortcuts [FF58+]
// 0 (default) or 1=allow, 2=block
// [SETTING] to add site exceptions: Ctrl+I>Permissions>Override Keyboard Shortcuts ***/
user_pref("permissions.default.shortcuts", 2);

// PREF: PDF sidebar on load
// 2=table of contents (if not available, will default to 1)
// 1=view pages
// 0=hide
// -1=disabled (default)
user_pref("pdfjs.sidebarViewOnLoad", 0);

// PREF: default zoom for PDFs
user_pref("pdfjs.defaultZoomValue", "page-width");

// Removes annoying "Inspect Accessibility Properties" on right-click
user_pref("devtools.accessibility.enabled", false);

// Select Network tab in devtools by default
user_pref("devtools.toolbox.selectedTool", "netmonitor");
// Persist Logs in Network tab in devtools
user_pref("devtools.netmonitor.persistlog", true);

// CSS scroll-linked animations
user_pref("layout.css.scroll-driven-animations.enabled", true);

// PREF: disable Firefox Suggest
// [1] https://github.com/arkenfox/user.js/issues/1257
//user_pref("browser.urlbar.quicksuggest.enabled", false); // controls whether the UI is shown
user_pref("browser.urlbar.suggest.quicksuggest.sponsored", false);
user_pref("browser.urlbar.suggest.quicksuggest.nonsponsored", false);
// Hide Firefox Suggest label in URL dropdown box
user_pref("browser.urlbar.groupLabels.enabled", false);

// Unselect "Show search suggestions ahead of browsing history in address bar results" for clean UI
user_pref("browser.urlbar.showSearchSuggestionsFirst", false);

// Extra hardening
user_pref("signon.management.page.breach-alerts.enabled", false);

// Unselect "Suggest and generate strong passwords" for clean UI
user_pref("signon.generation.enabled", false);

// Site Data
user_pref("privacy.clearOnShutdown.offlineApps", true);

// Fastfox
user_pref("nglayout.initialpaint.delay", 0);
user_pref("nglayout.initialpaint.delay_in_oopif", 0);
user_pref("content.notify.interval", 100000);
user_pref("browser.startup.preXulSkeletonUI", false);
// Experimental
user_pref("layout.css.grid-template-masonry-value.enabled", true);
user_pref("dom.enable_web_task_scheduling", true);
user_pref("layout.css.animation-composition.enabled", true);

// Restore pinned tabs only in foreground
user_pref("browser.sessionstore.restore_pinned_tabs_on_demand", true);

// GFX
user_pref("gfx.canvas.accelerated.cache-items", 32768);
user_pref("gfx.canvas.accelerated.cache-size", 4096);
user_pref("gfx.webrender.precache-shaders", true);
user_pref("gfx.content.skia-font-cache-size", 80);
user_pref("image.cache.size", 10485760);
user_pref("image.mem.decode_bytes_at_a_time", 131072);
user_pref("image.mem.shared.unmap.min_expiration_ms", 120000);

// Browser cache
user_pref("browser.cache.memory.max_entry_size", 153600);

// Network
user_pref("network.buffer.cache.size", 262144);
user_pref("network.buffer.cache.count", 128);
user_pref("network.http.max-connections", 3000);
user_pref("network.http.max-persistent-connections-per-server", 10);
user_pref("network.ssl_tokens_cache_capacity", 32768);
// user_pref("network.early-hints.enabled", true);
// user_pref("network.early-hints.preconnect.enabled", true);
// user_pref("network.early-hints.preconnect.max_connections", 20);
user_pref("network.http.pacing.requests.min-parallelism", 18);

// DNS Cache
user_pref("network.dnsCacheEntries", 20000); // maximum # of DNS entries
user_pref("network.dnsCacheExpiration", 86400); // keep DNS entries for 24 hours
user_pref("network.dnsCacheExpirationGracePeriod", 240); // 4 minutes

/*
 * extensions are allowed to work on restricted domains, while their scope
 * is set to profile+applications.
 * See: https://mike.kaply.com/2012/02/21/understanding-add-on-scopes/
 */
user_pref("extensions.enabledScopes", 5); // [HIDDEN PREF]
user_pref("extensions.webextensions.restrictedDomains", "");

/** TELEMETRY ***/
user_pref("datareporting.healthreport.service.enabled", false);
user_pref("datareporting.sessions.current.clean", true); // Do not collect information about the pages viewed. Option required to disable "browser.newtabpage.enhanced"
user_pref("devtools.onboarding.telemetry.logged", false);
user_pref("toolkit.telemetry.hybridContent.enabled", false);
user_pref("toolkit.telemetry.prompted", 2);
user_pref("toolkit.telemetry.rejected", true);
user_pref("toolkit.telemetry.reportingpolicy.firstRun", false);
user_pref("toolkit.telemetry.unifiedIsOptIn", false);

// PREF: query stripping
// Currently uses a small list [1]
// We set the same query stripping list that Brave and LibreWolf uses [2]
// If using uBlock Origin or AdGuard, use filter lists as well [3]
// [1] https://www.eyerys.com/articles/news/how-mozilla-firefox-improves-privacy-using-query-parameter-stripping-feature
// [2] https://github.com/brave/brave-core/blob/f337a47cf84211807035581a9f609853752a32fb/browser/net/brave_site_hacks_network_delegate_helper.cc
// [3] https://github.com/yokoffing/filterlists#url-tracking-parameters
//user_pref("privacy.query_stripping.enabled", true); // enabled with "Strict"
//user_pref("privacy.query_stripping.enabled.pbmode", true); // enabled with "Strict"
user_pref("privacy.query_stripping.strip_list", "__hsfp __hssc __hstc __s _hsenc _openstat dclid fbclid gbraid gclid hsCtaTracking igshid mc_eid ml_subscriber ml_subscriber_hash msclkid oft_c oft_ck oft_d oft_id oft_ids oft_k oft_lk oft_sk oly_anon_id oly_enc_id rb_clickid s_cid twclid vero_conv vero_id wbraid wickedid yclid");

// PREF: lower the priority of network loads for resources on the tracking protection list [NIGHTLY]
// [NOTE] Applicable because we allow for some social embeds
// [1] https://github.com/arkenfox/user.js/issues/102#issuecomment-298413904
user_pref("privacy.trackingprotection.lower_network_priority", true);

// PREF: SameSite Cookies
// [1] https://hacks.mozilla.org/2020/08/changes-to-samesite-cookie-behavior/
// [2] https://web.dev/samesite-cookies-explained/
user_pref("network.cookie.sameSite.laxByDefault", true);
user_pref("network.cookie.sameSite.noneRequiresSecure", true);
user_pref("network.cookie.sameSite.schemeful", true);

// PREF: disable Beacon API
// Disabling this API sometimes causes breakage
// [TEST] https://vercel.com/
// [1] https://developer.mozilla.org/docs/Web/API/Navigator/sendBeacon
// [2] https://github.com/arkenfox/user.js/issues/1586
user_pref("beacon.enabled", false);

// PREF: battery status tracking
// [NOTE] Pref remains, but API is depreciated
// [1] https://developer.mozilla.org/en-US/docs/Web/API/Battery_Status_API#browser_compatibility
user_pref("dom.battery.enabled", false);

// PREF: disable UITour backend so there is no chance that a remote page can use it
user_pref("browser.uitour.enabled", false);
    user_pref("browser.uitour.url", "");

// PREF: enable Global Privacy Control (GPC) [NIGHTLY]
// Honored by many highly ranked sites [2]
// [TEST] https://global-privacy-control.glitch.me/
// [1] https://globalprivacycontrol.org/press-release/20201007.html
// [2] https://github.com/arkenfox/user.js/issues/1542#issuecomment-1279823954
// [3] https://blog.mozilla.org/netpolicy/2021/10/28/implementing-global-privacy-control/
// [4] https://help.duckduckgo.com/duckduckgo-help-pages/privacy/gpc/
// [5] https://brave.com/web-standards-at-brave/4-global-privacy-control/
// [6] https://www.eff.org/gpc-privacy-badger
// [7] https://www.eff.org/issues/do-not-track
user_pref("privacy.globalprivacycontrol.enabled", true);
    user_pref("privacy.globalprivacycontrol.functionality.enabled", true);

// Online Certificate Status Protocol (OCSP)
// OCSP leaks your IP and domains you visit to the CA when OCSP Stapling is not available on visited host
// OCSP is vulnerable to replay attacks when nonce is not configured on the OCSP responder
// OCSP adds latency
// Short-lived certificates are not checked for revocation (security.pki.cert_short_lifetime_in_days, default:10)
// Firefox falls back on plain OCSP when must-staple is not configured on the host certificate
// [1] https://scotthelme.co.uk/revocation-is-broken/
// [2] https://blog.mozilla.org/security/2013/07/29/ocsp-stapling-in-firefox/
// [3] https://github.com/arkenfox/user.js/issues/1576#issuecomment-1304590235

// PREF: disable OCSP fetching to confirm current validity of certificates
// OCSP (non-stapled) leaks information about the sites you visit to the CA (cert authority)
// It's a trade-off between security (checking) and privacy (leaking info to the CA)
// Unlike Chrome, Firefox’s default settings also query OCSP responders to confirm the validity
// of SSL/TLS certificates. However, because OCSP query failures are so common, Firefox
// (like other browsers) implements a “soft-fail” policy
// [NOTE] This pref only controls OCSP fetching and does not affect OCSP stapling
// [SETTING] Privacy & Security>Security>Certificates>Query OCSP responder servers...
// [1] https://en.wikipedia.org/wiki/Ocsp
// [2] https://www.ssl.com/blogs/how-do-browsers-handle-revoked-ssl-tls-certificates/#ftoc-heading-3
// 0=disabled, 1=enabled (default), 2=enabled for EV certificates only
user_pref("security.OCSP.enabled", 0); // [DEFAULT: 1]

// PREF: set OCSP fetch failures to hard-fail
// When a CA cannot be reached to validate a cert, Firefox just continues the connection (=soft-fail)
// Setting this pref to true tells Firefox to instead terminate the connection (=hard-fail)
// It is pointless to soft-fail when an OCSP fetch fails: you cannot confirm a cert is still valid (it
// could have been revoked) and/or you could be under attack (e.g. malicious blocking of OCSP servers)
// [WARNING] Expect breakage:
// security.OCSP.require will make the connection fail when the OCSP responder is unavailable
// security.OCSP.require is known to break browsing on some captive portals
// [1] https://blog.mozilla.org/security/2013/07/29/ocsp-stapling-in-firefox/
// [2] https://www.imperialviolet.org/2014/04/19/revchecking.html
// [3] https://www.ssl.com/blogs/how-do-browsers-handle-revoked-ssl-tls-certificates/#ftoc-heading-3
user_pref("security.OCSP.require", true);

// PREF: enable CRLite
// CRLite covers valid certs, and it doesn't fall back to OCSP in mode 2 [FF84+]
// 0 = disabled
// 1 = consult CRLite but only collect telemetry
// 2 = consult CRLite and enforce both "Revoked" and "Not Revoked" results
// 3 = consult CRLite and enforce "Not Revoked" results, but defer to OCSP for "Revoked" [FF99+, default FF100+]
// [1] https://bugzilla.mozilla.org/buglist.cgi?bug_id=1429800,1670985,1753071
// [2] https://blog.mozilla.org/security/tag/crlite/
user_pref("security.remote_settings.crlite_filters.enabled", true);
user_pref("security.pki.crlite_mode", 2);

// PREF: enable strict pinning
// MOZILLA_PKIX_ERROR_KEY_PINNING_FAILURE
// If you rely on an AV (antivirus) to protect your web browsing
// by inspecting ALL your web traffic, then leave at current default=1
// PKP (Public Key Pinning) 0=disabled, 1=allow user MiTM (such as your antivirus), 2=strict
// [1] https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/16206
user_pref("security.cert_pinning.enforcement_level", 2);

// PREF: disable Enterprise Root Certificates of the operating system
//user_pref("security.enterprise_roots.enabled", false); // DEFAULT
user_pref("security.certerrors.mitm.auto_enable_enterprise_roots", false);

// PREF: display warning on the padlock for "broken security"
// Bug: warning padlock not indicated for subresources on a secure page! [2]
// [TEST] (January 2022) https://www.unibs.it/it
// [1] https://wiki.mozilla.org/Security:Renegotiation
// [2] https://bugzilla.mozilla.org/1353705
user_pref("security.ssl.treat_unsafe_negotiation_as_broken", true);

// PREF: require safe negotiation
// Blocks connections (SSL_ERROR_UNSAFE_NEGOTIATION) to servers that don't support RFC 5746 [2]
// as they're potentially vulnerable to a MiTM attack [3]. A server without RFC 5746 can be
// safe from the attack if it disables renegotiations but the problem is that the browser can't
// know that. Setting this pref to true is the only way for the browser to ensure there will be
// no unsafe renegotiations on the channel between the browser and the server.
// [STATS] SSL Labs (Sept 2022) reports that over 99.3% of top sites have secure renegotiation [4]
// [1] https://wiki.mozilla.org/Security:Renegotiation
// [2] https://datatracker.ietf.org/doc/html/rfc5746
// [3] https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2009-3555
// [4] https://www.ssllabs.com/ssl-pulse/
user_pref("security.ssl.require_safe_negotiation", true);

// PREF: display advanced information on Insecure Connection warning pages
// only works when it's possible to add an exception
// i.e. it doesn't work for HSTS discrepancies (https://subdomain.preloaded-hsts.badssl.com/)
// [TEST] https://expired.badssl.com/
user_pref("browser.xul.error_pages.expert_bad_cert", true);

// PREF: control "Add Security Exception" dialog on SSL warnings
// [NOTE] the code behind this was removed in FF68 [2]
// 0=do neither, 1=pre-populate url, 2=pre-populate url + pre-fetch cert (default)
// [1] https://github.com/pyllyukko/user.js/issues/210
// [2] https://bugzilla.mozilla.org/show_bug.cgi?id=1530348
user_pref("browser.ssl_override_behavior", 1);

// PREF: disable TLS 1.3 0-RTT (round-trip time) [FF51+]
// This data is not forward secret, as it is encrypted solely under keys derived using
// the offered PSK. There are no guarantees of non-replay between connections
// [1] https://github.com/tlswg/tls13-spec/issues/1001
// [2] https://www.rfc-editor.org/rfc/rfc9001.html#name-replay-attacks-with-0-rtt
// [3] https://blog.cloudflare.com/tls-1-3-overview-and-q-and-a/
user_pref("security.tls.enable_0rtt_data", false); // disable 0 RTT to improve tls 1.3 security


// PREF: disable rendering of SVG OpenType fonts
// [1] https://github.com/arkenfox/user.js/issues/1529
user_pref("gfx.font_rendering.opentype_svg.enabled", false);

// PREF: limit font visibility (Windows, Mac, some Linux) [FF94+]
// Uses hardcoded lists with two parts: kBaseFonts + kLangPackFonts [1], bundled fonts are auto-allowed
// In Normal windows: uses the first applicable: RFP (4506) over TP over Standard
// In Private Browsing windows: uses the most restrictive between normal and private
// 1=only base system fonts, 2=also fonts from optional language packs, 3=also user-installed fonts
// [1] https://searchfox.org/mozilla-central/search?path=StandardFonts*.inc
user_pref("layout.css.font-visibility.resistFingerprinting", 1); // DEFAULT
    user_pref("layout.css.font-visibility.trackingprotection", 1); // Normal Browsing windows with tracking protection enabled
    user_pref("layout.css.font-visibility.private", 1); // Private Browsing windows
        user_pref("layout.css.font-visibility.standard", 1); // Normal Browsing windows with tracking protection disabled(?)

// PREF: enable FingerPrint Protection (FPP) [WiP]
// Mozilla is slowly rolling out FPP in PB windows
// [1] https://github.com/arkenfox/user.js/issues/1661
// [2] https://bugzilla.mozilla.org/show_bug.cgi?id=1816064
user_pref("privacy.resistFingerprinting.randomization.enabled", true); // to be removed soon
user_pref("privacy.resistFingerprinting.randomization.daily_reset.enabled", true);
user_pref("privacy.resistFingerprinting.randomization.daily_reset.private.enabled", true);

// PREF: enable advanced fingerprinting protection
// [WARNING] Leave disabled unless you're okay with all the drawbacks
// [1] https://librewolf.net/docs/faq/#what-are-the-most-common-downsides-of-rfp-resist-fingerprinting
// [2] https://old.reddit.com/r/firefox/comments/wuqpgi/comment/ile3whx/?context=3
// user_pref("privacy.resistFingerprinting", true);

// PREF: set new window size rounding max values [FF55+]
// [SETUP-CHROME] sizes round down in hundreds: width to 200s and height to 100s, to fit your screen
// [1] https://bugzilla.mozilla.org/1330882
user_pref("privacy.window.maxInnerWidth", 1600);
user_pref("privacy.window.maxInnerHeight", 900);

// PREF: disable showing about:blank as soon as possible during startup [FF60+]
// When default true this no longer masks the RFP chrome resizing activity
// [1] https://bugzilla.mozilla.org/1448423
user_pref("browser.startup.blankWindow", false);

// PREF: disable ICC color management
// Use a color calibrator for best results [WINDOWS]
// Also may help improve font rendering on WINDOWS
// [SETTING] General>Language and Appearance>Fonts and Colors>Colors>Use system colors
// default=false NON-WINDOWS
// [1] https://developer.mozilla.org/en-US/docs/Mozilla/Firefox/Releases/3.5/ICC_color_correction_in_Firefox
user_pref("browser.display.use_system_colors", false);

// PREF: enforce non-native widget theme
// Security: removes/reduces system API calls, e.g. win32k API [1]
// Fingerprinting: provides a uniform look and feel across platforms [2]
// [1] https://bugzilla.mozilla.org/1381938
// [2] https://bugzilla.mozilla.org/1411425
user_pref("widget.non-native-theme.enabled", true); // DEFAULT


// PREF: disable disk cache
// [NOTE] If you think disk cache helps performance, then feel free to override this.
// user_pref("browser.cache.disk.enable", false);

// PREF: disable media cache from writing to disk in Private Browsing
// [NOTE] MSE (Media Source Extensions) are already stored in-memory in PB
user_pref("browser.privatebrowsing.forceMediaMemoryCache", true);

// PREF: disable storing extra session data
// Dictates whether sites may save extra session data such as form content, cookies and POST data
// 0=everywhere, 1=unencrypted sites, 2=nowhere
user_pref("browser.sessionstore.privacy_level", 2);

// PREF: disable fetching and permanently storing favicons for Windows .URL shortcuts created by drag and drop
// [NOTE] .URL shortcut files will be created with a generic icon
// Favicons are stored as .ico files in $profile_dir\shortcutCache
//user_pref("browser.shell.shortcutFavicons", false);

// PREF: disable page thumbnails capturing
// Page thumbnails are only used in chrome/privileged contexts
user_pref("browser.pagethumbnails.capturing_disabled", true); // [HIDDEN PREF]

// PREF: disable automatic Firefox start and session restore after reboot [WINDOWS]
// [1] https://bugzilla.mozilla.org/603903
user_pref("toolkit.winRegisterApplicationRestart", false);

// PREF: increase media cache limits
// For higher-end PCs; helps with video playback/buffering
// [1] https://github.com/arkenfox/user.js/pull/941
user_pref("browser.cache.memory.capacity", 256000); // -1; 256000=256MB, 512000=512MB, 1024000=1GB
user_pref("media.memory_cache_max_size", 512000); // 65536
user_pref("media.memory_caches_combined_limit_kb", 2560000); // 524288
user_pref("media.memory_caches_combined_limit_pc_sysmem", 10); // default=5
user_pref("media.cache_size", 2048000); // 512000
user_pref("media.cache_readahead_limit", 9000); // 60
user_pref("media.cache_resume_threshold", 9000); // 30

// PREF: reset default 'Time range to clear' for 'Clear Recent History'.
// Firefox remembers your last choice. This will reset the value when you start Firefox.
// 0=everything, 1=last hour, 2=last two hours, 3=last four hours,
// 4=today, 5=last five minutes, 6=last twenty-four hours
// The values 5 + 6 are not listed in the dropdown, which will display a
// blank value if they are used, but they do work as advertised.
user_pref("privacy.sanitize.timeSpan", 0);

// PREF: reset default items to clear with Ctrl-Shift-Del
// This dialog can also be accessed from the menu History>Clear Recent History
// Firefox remembers your last choices. This will reset them when you start Firefox.
// Regardless of what you set privacy.cpd.downloads to, as soon as the dialog
// for "Clear Recent History" is opened, it is synced to the same as 'history'.
user_pref("privacy.cpd.history", true); // Browsing & Download History [DEFAULT]
user_pref("privacy.cpd.formdata", true); // Form & Search History [DEFAULT]
user_pref("privacy.cpd.cache", true); // Cache [DEFAULT]
user_pref("privacy.cpd.cookies", true); // Cookies [DEFAULT]
user_pref("privacy.cpd.sessions", false); // Active Logins [DEFAULT]
user_pref("privacy.cpd.offlineApps", false); // Offline Website Data [DEFAULT]
user_pref("privacy.cpd.siteSettings", false); // Site Preferences [DEFAULT]


// PREF: set History section to show all options
// Settings>Privacy>History>Use custom settings for history
// [INFOGRAPHIC] https://bugzilla.mozilla.org/show_bug.cgi?id=1765533#c1
user_pref("privacy.history.custom", true);

// PREF: clear browsing data on shutdown, while respecting site exceptions
// Set cookies, site data, cache, etc. to clear on shutdown
// [SETTING] Privacy & Security>History>Custom Settings>Clear history when Firefox closes>Settings
// [NOTE] "sessions": Active Logins: refers to HTTP Basic Authentication [1], not logins via cookies
// [NOTE] "offlineApps": Offline Website Data: localStorage, service worker cache, QuotaManager (IndexedDB, asm-cache)
// Clearing "offlineApps" may affect login items after browser restart [2]
// [1] https://en.wikipedia.org/wiki/Basic_access_authentication
// [2] https://github.com/arkenfox/user.js/issues/1291
//user_pref("privacy.sanitize.sanitizeOnShutdown", true);

// Uncomment individual prefs to disable clearing on shutdown:
// [NOTE] If "history" is true, downloads will also be cleared
//user_pref("privacy.clearOnShutdown.history", true); // [DEFAULT]
//user_pref("privacy.clearOnShutdown.formdata", true); // [DEFAULT]
//user_pref("privacy.clearOnShutdown.sessions", true); // [DEFAULT]
//user_pref("privacy.clearOnShutdown.offlineApps", true);
//user_pref("privacy.clearOnShutdown.siteSettings", false); // [DEFAULT]

// PREF: configure site exceptions
// [NOTE] Currently, there is no way to add sites via about:config
// [SETTING] to manage site exceptions: Options>Privacy & Security>Cookies & Site Data>Manage Exceptions
// or when on the website in question: Ctrl+I>Permissions>Cookies>Allow
// For cross-domain logins, add exceptions for both sites:
// e.g. https://www.youtube.com (site) + https://accounts.google.com (single sign on)
// [WARNING] Be selective with what cookies you keep, as they also disable partitioning [1]
// [1] https://bugzilla.mozilla.org/show_bug.cgi?id=1767271

// PREF: Speculative Connections
// Firefox will open predictive connections to sites when the user hovers their mouse over thumbnails
// on the New Tab Page or the user starts to search in the Search Bar, or in the search field on the
// New Tab Page [1]. This pref may control speculative connects for normal links, too [2].
// The maximum number of current global half open sockets allowable when starting a new speculative connection [3].
// In case the user follows through with the action, the page can begin loading faster
// since some of the work was already started in advance.
// [NOTE] TCP and SSL handshakes are set up in advance but page contents are not downloaded until a click on the link is registered
// [1] https://support.mozilla.org/en-US/kb/how-stop-firefox-making-automatic-connections?redirectslug=how-stop-firefox-automatically-making-connections&redirectlocale=en-US#:~:text=Speculative%20pre%2Dconnections
// [2] https://news.slashdot.org/story/15/08/14/2321202/how-to-quash-firefoxs-silent-requests
// [3] https://searchfox.org/mozilla-central/rev/028c68d5f32df54bca4cf96376f79e48dfafdf08/modules/libpref/init/all.js#1280-1282
// [4] https://www.keycdn.com/blog/resource-hints#prefetch
// [5] https://3perf.com/blog/link-rels/#prefetch
user_pref("network.http.speculative-parallel-limit", 0);

// PREF: Preconnect to the autocomplete URL in the address bar
// Firefox preloads URLs that autocomplete when a user types into the address bar.
// Connects to destination server ahead of time, to avoid TCP handshake latency.
// [NOTE] Firefox will perform DNS lookup (if enabled) and TCP and TLS handshake,
// but will not start sending or receiving HTTP data.
// [1] https://www.ghacks.net/2017/07/24/disable-preloading-firefox-autocomplete-urls/
user_pref("browser.urlbar.speculativeConnect.enabled", false);

// PREF: disable mousedown speculative connections on bookmarks and history
user_pref("browser.places.speculativeConnect.enabled", false);

// PREF: DNS pre-resolve <link rel="dns-prefetch">
// Resolve hostnames ahead of time, to avoid DNS latency.
// In order to reduce latency, Firefox will proactively perform domain name resolution on links that
// the user may choose to follow as well as URLs for items referenced by elements in a web page.
// [1] https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/X-DNS-Prefetch-Control
// [2] https://css-tricks.com/prefetching-preloading-prebrowsing/#dns-prefetching
// [3] https://www.keycdn.com/blog/resource-hints#2-dns-prefetching
// [4] http://www.mecs-press.org/ijieeb/ijieeb-v7-n5/IJIEEB-V7-N5-2.pdf
user_pref("network.dns.disablePrefetch", true);
// user_pref("network.dns.disablePrefetchFromHTTPS", true); // DEFAULT

// PREF: Preload <link rel=preload>
// This tells the browser that the resource should be loaded as part of the current navigation
// and it should start fetching it ASAP. This attribute can be applied to CSS, fonts, images, JavaScript files and more.
// This tells the browser to download and cache a resource (like a script or a stylesheet) as soon as possible.
// The browser doesn’t do anything with the resource after downloading it. Scripts aren’t executed, stylesheets
// aren’t applied. It’s just cached – so that when something else needs it, it’s available immediately.
// Focuses on fetching a resource for the CURRENT navigation.
// [NOTE] Unlike other pre-connection tags (except modulepreload), this tag is mandatory for the browser.
// [1] https://developer.mozilla.org/en-US/docs/Web/HTML/Link_types/preload
// [2] https://w3c.github.io/preload/
// [3] https://3perf.com/blog/link-rels/#preload
// [4] https://medium.com/reloading/preload-prefetch-and-priorities-in-chrome-776165961bbf
// [5] https://www.smashingmagazine.com/2016/02/preload-what-is-it-good-for/#how-can-preload-do-better
// [6] https://www.keycdn.com/blog/resource-hints#preload
// [7] https://github.com/arkenfox/user.js/issues/1098#issue-791949341
// [8] https://yashints.dev/blog/2018/10/06/web-perf-2#preload
// [9] https://web.dev/preload-critical-assets/
//user_pref("network.preload", true); // DEFAULT

// PREF: early hints
// [1] https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/103
user_pref("network.early-hints.enabled", false); // DEFAULT
    user_pref("network.early-hints.preconnect.enabled", false); // DEFAULT
    user_pref("network.early-hints.preconnect.max_connections", 0); // DEFAULT

// PREF: Link prefetching <link rel="prefetch">
// Firefox will prefetch certain links if any of the websites you are viewing uses the special prefetch-link tag.
// A directive that tells a browser to fetch a resource that will likely be needed for the next navigation.
// The resource will be fetched with extremely low priority (since everything the browser knows
// is needed in the current page is more important than a resource that we guess might be needed in the next one).
// Speeds up the NEXT navigation rather than the current one.
// When the user clicks on a link, or initiates any kind of page load, link prefetching will stop and any prefetch hints will be discarded.
// [1] https://developer.mozilla.org/en-US/docs/Web/HTTP/Link_prefetching_FAQ#Privacy_implications
// [2] http://www.mecs-press.org/ijieeb/ijieeb-v7-n5/IJIEEB-V7-N5-2.pdf
// [3] https://timkadlec.com/remembers/2020-06-17-prefetching-at-this-age/
// [4] https://3perf.com/blog/link-rels/#prefetch
user_pref("network.prefetch-next", false);

// PREF: Network Predictor (NP)
// Keeps track of components that were loaded during page visits so that the browser knows next time
// which resources to request from the server: It uses a local file to remember which resources were
// needed when the user visits a webpage (such as image.jpg and script.js), so that the next time the
// user prepares to go to that webpage (upon navigation? URL bar? mouseover?), this history can be used
// to predict what resources will be needed rather than wait for the document to link those resources.
// NP only performs pre-connect, not prefetch, by default, including DNS pre-resolve and TCP preconnect
// (which includes SSL handshake). No data is actually sent to the site until a user actively clicks
// a link. However, NP is still opening TCP connections and doing SSL handshakes, so there is still
// information leakage about your browsing patterns. This isn't desirable from a privacy perspective.
// [NOTE] Disabling DNS prefetching disables the DNS prefetching behavior of NP.
// [1] https://wiki.mozilla.org/Privacy/Reviews/Necko
// [2] https://www.ghacks.net/2014/05/11/seer-disable-firefox/
// [3] https://github.com/dillbyrne/random-agent-spoofer/issues/238#issuecomment-110214518
// [4] https://www.igvita.com/posa/high-performance-networking-in-google-chrome/#predictor
user_pref("network.predictor.enabled", false);

// PREF: NP fetches resources on the page ahead of time, to accelerate rendering of the page
// Performs both pre-connect and prefetch
user_pref("network.predictor.enable-prefetch", false);

// PREF: NP activates upon hovered links:
// The next time the user mouseovers a link to that webpage, history is used to predict what
// resources will be needed rather than wait for the document to link those resources.
// When you hover over links, connections are established to linked domains and servers
// automatically to speed up the loading process should you click on the link. To improve the
// loading speed, Firefox will open predictive connections to sites when the user hovers their
// mouse over. In case the user follows through with the action, the page can begin loading
// faster since some of the work was already started in advance. Focuses on fetching a resource
// for the NEXT navigation.
user_pref("network.predictor.enable-hover-on-ssl", false); // DEFAULT

// PREF: do not trim certain parts of the URL
// [1] https://developer.mozilla.org/en-US/docs/Mozilla/Preferences/Preference_reference/browser.urlbar.trimURLs#values
user_pref("browser.urlbar.trimURLs", false);

// PREF: disable search terms [FF110+]
// [SETTING] Search>Search Bar>Use the address bar for search and navigation>Show search terms instead of URL...
user_pref("browser.urlbar.showSearchTerms.enabled", false);

// PREF: enable option to add custom search
// [SETTINGS] Settings -> Search -> Search Shortcuts -> Add
// [EXAMPLE] https://lite.duckduckgo.com/lite/?q=%s
// [1] https://reddit.com/r/firefox/comments/xkzswb/adding_firefox_search_engine_manually/
user_pref("browser.urlbar.update2.engineAliasRefresh", true); // HIDDEN

// PREF: disable location bar leaking single words to a DNS provider after searching
// 0=never resolve single words, 1=heuristic (default), 2=always resolve
// [1] https://bugzilla.mozilla.org/1642623
user_pref("browser.urlbar.dnsResolveSingleWordsAfterSearch", 0); // DEFAULT FF104+

// PREF: URL bar domain guessing
// Domain guessing intercepts DNS "hostname not found errors" and resends a
// request (e.g. by adding www or .com). This is inconsistent use (e.g. FQDNs), does not work
// via Proxy Servers (different error), is a flawed use of DNS (TLDs: why treat .com
// as the 411 for DNS errors?), privacy issues (why connect to sites you didn't
// intend to), can leak sensitive data (e.g. query strings: e.g. Princeton attack),
// and is a security risk (e.g. common typos & malicious sites set up to exploit this).
user_pref("browser.fixup.alternate.enabled", false); // [DEFAULT FF104+]

// PREF: display "Not Secure" text on HTTP sites
// Needed with HTTPS-First Policy; not needed with HTTPS-Only Mode
user_pref("security.insecure_connection_text.enabled", true);
user_pref("security.insecure_connection_text.pbmode.enabled", true);

// PREF: Disable location bar autofill
// https://support.mozilla.org/en-US/kb/address-bar-autocomplete-firefox#w_url-autocomplete
// user_pref("browser.urlbar.autoFill", false);

// PREF: Enforce Punycode for Internationalized Domain Names to eliminate possible spoofing
// Firefox has some protections, but it is better to be safe than sorry.
// [!] Might be undesirable for non-latin alphabet users since legitimate IDN's are also punycoded.
// [TEST] https://www.xn--80ak6aa92e.com/ (www.apple.com)
// [1] https://wiki.mozilla.org/IDN_Display_Algorithm
// [2] https://en.wikipedia.org/wiki/IDN_homograph_attack
// [3] CVE-2017-5383: https://www.mozilla.org/security/advisories/mfsa2017-02/
// [4] https://www.xudongz.com/blog/2017/idn-phishing/
user_pref("network.IDN_show_punycode", true);

// PREF: HTTPS-First Policy
// Firefox attempts to make all connections to websites secure, and falls back to insecure
// connections only when a website does not support it. Unlike HTTPS-Only Mode, Firefox
// will NOT ask for your permission before connecting to a website that doesn’t support secure connections.
// [NOTE] HTTPS-Only Mode needs to be disabled for HTTPS First to work.
// [TEST] http://example.com [upgrade]
// [TEST] http://httpforever.com/ [no upgrade]
// [1] https://blog.mozilla.org/security/2021/08/10/firefox-91-introduces-https-by-default-in-private-browsing/
// [2] https://brave.com/privacy-updates/22-https-by-default/
// [3] https://github.com/brave/adblock-lists/blob/master/brave-lists/https-upgrade-exceptions-list.txt
// [4] https://web.dev/why-https-matters/
// [5] https://www.cloudflare.com/learning/ssl/why-use-https/
user_pref("dom.security.https_first", true);
user_pref("dom.security.https_first_pbm", true); // DEFAULT

// PREF: EDNS Client Subnet DNS extension (DNSSEC validation)
// [NOTE] Not needed when using DoH/TRR [1]
// When set to false, TRR asks the resolver to enable EDNS Client Subnet (ECS)
// [WARNING] Some websites won't resolve when enabled
// This is usually due to misconfiguration on the part of the domain owner
// [1] https://docs.controld.com/docs/disable-dnssec-option
user_pref("network.trr.disable-ECS", false);

// PREF: DNS Rebind Protection
// Set to true to allow RFC 1918 private addresses in TRR responses
// [1] https://docs.controld.com/docs/dns-rebind-option
user_pref("network.trr.allow-rfc1918", false); // DEFAULT

// PREF: Assorted Options
user_pref("network.trr.confirmationNS", "skip"); // skip undesired DOH test connection
user_pref("network.dns.skipTRR-when-parental-control-enabled", false); // bypass parental controls when using DoH
user_pref("network.trr.skip-AAAA-when-not-supported", true); // DEFAULT; If Firefox detects that your system does not have IPv6 connectivity, it will not request IPv6 addresses from the DoH server
user_pref("network.trr.clear-cache-on-pref-change", true); // DEFAULT; DNS+TRR cache will be cleared when a relevant TRR pref changes
user_pref("network.trr.wait-for-portal", false); // DEFAULT; set this to true to tell Firefox to wait for the captive portal detection before TRR is used

// PREF: DOH exlcusions
user_pref("network.trr.excluded-domains", ""); // DEFAULT; comma-separated list of domain names to be resolved using the native resolver instead of TRR. This pref can be used to make /etc/hosts works with DNS over HTTPS in Firefox.
user_pref("network.trr.builtin-excluded-domains", "localhost,local"); // DEFAULT; comma-separated list of domain names to be resolved using the native resolver instead of TRR

// PREF: enable Oblivious DoH setup (Cloudfare)
// [1] https://blog.cloudflare.com/oblivious-dns/
// [2] https://www.reddit.com/r/firefox/comments/xc9y4g/how_to_enable_oblivious_doh_odoh_for_enhanced_dns/
//user_pref("network.trr.mode", 3);
user_pref("network.trr.odoh.enabled", true);
user_pref("network.trr.odoh.configs_uri", "https://odoh.cloudflare-dns.com/.well-known/odohconfigs");
user_pref("network.trr.odoh.target_host", "https://odoh.cloudflare-dns.com/");
user_pref("network.trr.odoh.target_path", "dns-query");
// user_pref("network.trr.odoh.proxy_uri", "https://odoh1.surfdomeinen.nl/proxy");

// PREF: enable Encrypted Client Hello (ECH)
// [NOTE] HTTP already isolated with network partitioning
// [1] https://blog.cloudflare.com/encrypted-client-hello/
// [2] https://www.youtube.com/watch?v=tfyrVYqXQRE
// [3] https://groups.google.com/a/chromium.org/g/blink-dev/c/KrPqrd-pO2M/m/Yoe0AG7JAgAJ
user_pref("network.dns.echconfig.enabled", true);
user_pref("network.dns.http3_echconfig.enabled", true);
    user_pref("network.dns.use_https_rr_as_altsvc", true); // DEFAULT

// PREF: disable IPv6
// IPv6 can be abused, especially with MAC addresses, and can leak with VPNs: assuming
// your ISP and/or router and/or website is IPv6 capable. Most sites will fall back to IPv4
// [STATS] Firefox telemetry (Sept 2022) shows ~8% of all successful connections are IPv6
// [NOTE] This is an application level fallback. Disabling IPv6 is best done at an
// OS/network level, and/or configured properly in VPN setups. If you are not masking your IP,
// then this won't make much difference. If you are masking your IP, then it can only help.
// [NOTE] However, many VPN options now provide IPv6 coverage.
// [NOTE] PHP defaults to IPv6 with "localhost". Use "php -S 127.0.0.1:PORT"
// [TEST] https://ipleak.org/
// [1] https://www.internetsociety.org/tag/ipv6-security/ (Myths 2,4,5,6)
//user_pref("network.dns.disableIPv6", true);
// PREF: set the proxy server to do any DNS lookups when using SOCKS
// e.g. in Tor, this stops your local DNS server from knowing your Tor destination
// as a remote Tor node will handle the DNS request
// [1] https://trac.torproject.org/projects/tor/wiki/doc/TorifyHOWTO/WebBrowsers
// [SETTING] Settings>Network Settings>Proxy DNS when using SOCKS v5
user_pref("network.proxy.socks_remote_dns", true);

// PREF: disable using UNC (Uniform Naming Convention) paths [FF61+]
// [SETUP-CHROME] Can break extensions for profiles on network shares
// [1] https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/26424
user_pref("network.file.disable_unc_paths", true); // [HIDDEN PREF]

// PREF: disable GIO as a potential proxy bypass vector
// Gvfs/GIO has a set of supported protocols like obex, network, archive, computer,
// dav, cdda, gphoto2, trash, etc. By default only sftp is accepted (FF87+)
// [1] https://bugzilla.mozilla.org/1433507
// [2] https://en.wikipedia.org/wiki/GVfs
// [3] https://en.wikipedia.org/wiki/GIO_(software)
user_pref("network.gio.supported-protocols", ""); // [HIDDEN PREF]

// PREF: disable formless login capture
// [1] https://bugzilla.mozilla.org/show_bug.cgi?id=1166947
user_pref("signon.formlessCapture.enabled", false);

// PREF: disable capturing credentials in private browsing
user_pref("signon.privateBrowsingCapture.enabled", false);

// PREF: disable auto-filling username & password form fields
// Can leak in cross-site forms and be spoofed
// NOTE: Username and password is still available when you enter the field
user_pref("signon.autofillForms", false);
user_pref("signon.autofillForms.autocompleteOff", true);
user_pref("signon.showAutoCompleteOrigins", false);

// PREF: disable autofilling saved passwords on HTTP pages and show warning
// [1] https://bugzilla.mozilla.org/buglist.cgi?bug_id=1217152,1319119
user_pref("signon.autofillForms.http", false);
user_pref("security.insecure_field_warning.contextual.enabled", true);

// PREF: disable password manager
// [NOTE] This does not clear any passwords already saved
user_pref("signon.rememberSignons", false);
//user_pref("signon.rememberSignons.visibilityToggle", false);
//user_pref("signon.schemeUpgrades", false);
//user_pref("signon.showAutoCompleteFooter", false);
//user_pref("signon.autologin.proxy", false);
    //user_pref("signon.debug", false);

// PREF: disable Firefox built-in password generator
// Create passwords with random characters and numbers.
// [NOTE] Doesn't work with Lockwise disabled!
// [1] https://wiki.mozilla.org/Toolkit:Password_Manager/Password_Generation
user_pref("signon.generation.available", false);
user_pref("signon.generation.enabled", false);

// PREF: disable Firefox Lockwise (about:logins)
// [NOTE] No usernames or passwords are sent to third-party sites
// [1] https://lockwise.firefox.com/
// [2] https://support.mozilla.org/en-US/kb/firefox-lockwise-managing-account-data
user_pref("signon.management.page.breach-alerts.enabled", false);
    user_pref("signon.management.page.breachAlertUrl", "");
user_pref("browser.contentblocking.report.lockwise.enabled", false);
    user_pref("browser.contentblocking.report.lockwise.how_it_works.url", "");

// PREF: disable Firefox import password from signons.sqlite file
// [1] https://support.mozilla.org/en-US/questions/1020818
user_pref("signon.management.page.fileImport.enabled", false);
user_pref("signon.importedFromSqlite", false);
    user_pref("signon.recipes.path", "");

// PREF: disable websites autocomplete
// Don't let sites dictate use of saved logins and passwords
user_pref("signon.storeWhenAutocompleteOff", false);

// PREF: disable Firefox Monitor
user_pref("extensions.fxmonitor.enabled", false);

// PREF: prevent password truncation when submitting form data
// [1] https://www.ghacks.net/2020/05/18/firefox-77-wont-truncate-text-exceeding-max-length-to-address-password-pasting-issues/
user_pref("editor.truncate_user_pastes", false);

// PREF: Reveal Password
user_pref("layout.forms.reveal-password-button.enabled", true); // show icon
user_pref("layout.forms.reveal-password-context-menu.enabled", true); // right-click menu option; DEFAULT FF112

/** ADDRESS + CREDIT CARD MANAGER ***/
// PREF: Disable Form Autofill
// NOTE: stored data is not secure (uses a JSON file)
// [1] https://wiki.mozilla.org/Firefox/Features/Form_Autofill
// [2] https://www.ghacks.net/2017/05/24/firefoxs-new-form-autofill-is-awesome
user_pref("extensions.formautofill.addresses.enabled", false);
user_pref("extensions.formautofill.creditCards.enabled", false);
user_pref("extensions.formautofill.heuristics.enabled", false);
user_pref("browser.formfill.enable", false);

// PREF: limit (or disable) HTTP authentication credentials dialogs triggered by sub-resources
// Hardens against potential credentials phishing
// 0=don't allow sub-resources to open HTTP authentication credentials dialogs
// 1=don't allow cross-origin sub-resources to open HTTP authentication credentials dialogs
// 2=allow sub-resources to open HTTP authentication credentials dialogs (default)
// [1] https://www.fxsitecompat.com/en-CA/docs/2015/http-auth-dialog-can-no-longer-be-triggered-by-cross-origin-resources/
user_pref("network.auth.subresource-http-auth-allow", 1);

// PREF: disable automatic authentication on Microsoft sites [WINDOWS]
// [1] https://bugzilla.mozilla.org/buglist.cgi?bug_id=1695693,1719301
user_pref("network.http.windows-sso.enabled", false);

// PREF: block insecure active content (scripts) on HTTPS pages.
// [1] https://trac.torproject.org/projects/tor/ticket/21323
user_pref("security.mixed_content.block_active_content", true); // DEFAULT

// PREF: block insecure passive content (images) on HTTPS pages
user_pref("security.mixed_content.block_display_content", true);

// PREF: upgrade passive content to use HTTPS on secure pages
user_pref("security.mixed_content.upgrade_display_content", true); // DEFAULT [FF 110]

// PREF: block insecure downloads from secure sites
// [1] https://bugzilla.mozilla.org/show_bug.cgi?id=1660952
user_pref("dom.block_download_insecure", true); // DEFAULT

// PREF: allow PDFs to load javascript
// https://www.reddit.com/r/uBlockOrigin/comments/mulc86/firefox_88_now_supports_javascript_in_pdf_files/
user_pref("pdfjs.enableScripting", false);

// PREF: disable bypassing 3rd party extension install prompts
// [1] https://bugzilla.mozilla.org/buglist.cgi?bug_id=1659530,1681331
user_pref("extensions.postDownloadThirdPartyPrompt", false);

// PREF: disable permissions delegation
// Currently applies to cross-origin geolocation, camera, mic and screen-sharing
// permissions, and fullscreen requests. Disabling delegation means any prompts
// for these will show/use their correct 3rd party origin
// [1] https://groups.google.com/forum/#!topic/mozilla.dev.platform/BdFOMAuCGW8/discussion
user_pref("permissions.delegation.enabled", false);

// PREF: enforce TLS 1.0 and 1.1 downgrades as session only
user_pref("security.tls.version.enable-deprecated", false); // DEFAULT

// PREF: enable (limited but sufficient) window.opener protection
// Makes rel=noopener implicit for target=_blank in anchor and area elements when no rel attribute is set.
// https://jakearchibald.com/2016/performance-benefits-of-rel-noopener/
user_pref("dom.targetBlankNoOpener.enabled", true); // DEFAULT

// PREF: enable "window.name" protection
// If a new page from another domain is loaded into a tab, then window.name is set to an empty string. The original
// string is restored if the tab reverts back to the original page. This change prevents some cross-site attacks.
user_pref("privacy.window.name.update.enabled", true); // DEFAULT

// PREF: Set the default Referrer Policy; to be used unless overriden by the site.
// 0=no-referrer, 1=same-origin, 2=strict-origin-when-cross-origin (default),
// 3=no-referrer-when-downgrade.
// [TEST https://www.sportskeeda.com/mma/news-joe-rogan-accuses-cnn-altering-video-color-make-look-sick
// [1] https://blog.mozilla.org/security/2021/03/22/firefox-87-trims-http-referrers-by-default-to-protect-user-privacy/
// [2] https://web.dev/referrer-best-practices/
// [3] https://plausible.io/blog/referrer-policy
user_pref("network.http.referer.defaultPolicy", 2); // DEFAULT
user_pref("network.http.referer.defaultPolicy.pbmode", 2); // DEFAULT

// PREF: Set the default Referrer Policy applied to third-party trackers when the
// default cookie policy is set to reject third-party trackers; to be used
// unless overriden by the site
// [NOTE] Trim referrers from trackers to origins by default
// 0=no-referrer, 1=same-origin, 2=strict-origin-when-cross-origin (default),
// 3=no-referrer-when-downgrade.
user_pref("network.http.referer.defaultPolicy.trackers", 1);
user_pref("network.http.referer.defaultPolicy.trackers.pbmode", 1);

// PREF: control when to send a cross-origin referer
// 0=always (default), 1=only if base domains match, 2=only if hosts match
// [NOTE] Known to cause issues with some sites (e.g., Vimeo, iCloud, Instagram) ***/
user_pref("network.http.referer.XOriginPolicy", 2);

// PREF: control the amount of cross-origin information to send
// 0=send full URI (default), 1=scheme+host+port+path, 2=scheme+host+port
user_pref("network.http.referer.XOriginTrimmingPolicy", 2);

// PREF: enable Container Tabs and its UI setting [FF50+]
// [NOTE] No longer a privacy benefit due to Firefox upgrades (see State Partitioning and Network Partitioning)
// Useful if you want to login to the same site under different accounts
// You also may want to download Multi-Account Containers for extra options (2)
// [SETTING] General>Tabs>Enable Container Tabs
// [1] https://wiki.mozilla.org/Security/Contextual_Identity_Project/Containers
// [2] https://addons.mozilla.org/en-US/firefox/addon/multi-account-containers/
user_pref("privacy.userContext.ui.enabled", true);
user_pref("privacy.userContext.enabled", true);

// PREF: set behavior on "+ Tab" button to display container menu on left click [FF74+]
// [NOTE] The menu is always shown on long press and right click
// [SETTING] General>Tabs>Enable Container Tabs>Settings>Select a container for each new tab ***/
// user_pref("privacy.userContext.newTabContainerOnLeftClick.enabled", true);

// PREF: disable WebRTC (Web Real-Time Communication)
// Firefox desktop uses mDNS hostname obfuscation and the private IP is never exposed until
// required in TRUSTED scenarios; i.e. after you grant device (microphone or camera) access
// [TEST] https://browserleaks.com/webrtc
// [NOTE] Breaks google hangouts
// [1] https://groups.google.com/g/discuss-webrtc/c/6stQXi72BEU/m/2FwZd24UAQAJ
// [2] https://datatracker.ietf.org/doc/html/draft-ietf-mmusic-mdns-ice-candidates#section-3.1.1
// user_pref("media.peerconnection.enabled", false);

// PREF: enable WebRTC Global Mute Toggles
user_pref("privacy.webrtc.globalMuteToggles", true);

// PREF: force WebRTC inside the proxy [FF70+]
user_pref("media.peerconnection.ice.proxy_only_if_behind_proxy", true);

// PREF: force a single network interface for ICE candidates generation [FF42+]
// When using a system-wide proxy, it uses the proxy interface
// [1] https://developer.mozilla.org/en-US/docs/Web/API/RTCIceCandidate
// [2] https://wiki.mozilla.org/Media/WebRTC/Privacy
user_pref("media.peerconnection.ice.default_address_only", true);

// PREF: force exclusion of private IPs from ICE candidates [FF51+]
// [SETUP-HARDEN] This will protect your private IP even in TRUSTED scenarios after you
// grant device access, but often results in breakage on video-conferencing platforms
user_pref("media.peerconnection.ice.no_host", true);

// PREF: disable GMP (Gecko Media Plugins)
// [1] https://wiki.mozilla.org/GeckoMediaPlugins
user_pref("media.gmp-provider.enabled", false);

// PREF: disable widevine CDM (Content Decryption Module)
// [NOTE] This is covered by the EME master switch
user_pref("media.gmp-widevinecdm.enabled", false);

// PREF: disable all DRM content (EME: Encryption Media Extension)
// EME is a JavaScript API for playing DRMed (not free) video content in HTML.
// A DRM component called a Content Decryption Module (CDM) decrypts, decodes, and displays the video.
// e.g. Netflix, Amazon Prime, Hulu, HBO, Disney+, Showtime, Starz, DirectTV
// [SETTING] General>DRM Content>Play DRM-controlled content
// [TEST] https://bitmovin.com/demos/drm
// [1] https://www.eff.org/deeplinks/2017/10/drms-dead-canary-how-we-just-lost-web-what-we-learned-it-and-what-we-need-do-next
// [2] https://old.reddit.com/r/firefox/comments/10gvplf/comment/j55htc7
user_pref("media.eme.enabled", false);
// Optionally, hide the setting which also disables the DRM prompt:
user_pref("browser.eme.ui.enabled", false);

// PREF: enable FTP protocol
// Firefox redirects any attempt to load a FTP resource to the default search engine if the FTP protocol is disabled.
// [1] https://www.ghacks.net/2018/02/20/firefox-60-with-new-preference-to-disable-ftp/
user_pref("network.ftp.enabled", false);

// PREF: decode URLs in other languages
// [NOTE] I leave this off because it has unintended consequecnes when copy+paste links with underscores.
// [1] https://bugzilla.mozilla.org/show_bug.cgi?id=1320061
// user_pref("browser.urlbar.decodeURLsOnCopy", true);

// PREF: number of usages of the web console
// If this is less than 5, then pasting code into the web console is disabled
user_pref("devtools.selfxss.count", 5);

// A full url is never sent to Google, only a part-hash of the prefix,
// hidden with noise of other real part-hashes. Firefox takes measures such as
// stripping out identifying parameters, and since SBv4 (FF57+), doesn't even use cookies.
// (Turn on browser.safebrowsing.debug to monitor this activity)
// [1] https://feeding.cloud.geek.nz/posts/how-safe-browsing-works-in-firefox/
// [2] https://wiki.mozilla.org/Security/Safe_Browsing
// [3] https://support.mozilla.org/kb/how-does-phishing-and-malware-protection-work
// [4] https://educatedguesswork.org/posts/safe-browsing-privacy/

// PREF: disable Safe Browsing
// [WARNING] Be sure to have alternate security measures if you disable SB! Adblockers do not count!
// [SETTING] Privacy & Security>Security>... Block dangerous and deceptive content
// [ALTERNATIVE] Enable local checks only: https://github.com/yokoffing/Betterfox/issues/87
// [1] https://support.mozilla.org/en-US/kb/how-does-phishing-and-malware-protection-work#w_what-information-is-sent-to-mozilla-or-its-partners-when-phishing-and-malware-protection-is-enabled
// [2] https://wiki.mozilla.org/Security/Safe_Browsing
// [3] https://developers.google.com/safe-browsing/v4
// [4] https://github.com/privacyguides/privacyguides.org/discussions/423#discussioncomment-1752006
// [5] https://github.com/privacyguides/privacyguides.org/discussions/423#discussioncomment-1767546
// [6] https://wiki.mozilla.org/Security/Safe_Browsing
// [7] https://ashkansoltani.org/2012/02/25/cookies-from-nowhere (outdated)
// [8] https://blog.cryptographyengineering.com/2019/10/13/dear-apple-safe-browsing-might-not-be-that-safe/ (outdated)
// [9] https://the8-bit.com/apple-proxies-google-safe-browsing-privacy/
// [10] https://github.com/brave/brave-browser/wiki/Deviations-from-Chromium-(features-we-disable-or-remove)#services-we-proxy-through-brave-servers
// user_pref("browser.safebrowsing.malware.enabled", false); // all checks happen locally
// user_pref("browser.safebrowsing.phishing.enabled", false); // all checks happen locally
    // user_pref("browser.safebrowsing.blockedURIs.enabled", false);
    // user_pref("browser.safebrowsing.provider.google4.gethashURL", "");
    // user_pref("browser.safebrowsing.provider.google4.updateURL", "");
    // user_pref("browser.safebrowsing.provider.google.gethashURL", "");
    // user_pref("browser.safebrowsing.provider.google.updateURL", "");

// PREF: disable SB checks for downloads
// This is the master switch for the safebrowsing.downloads prefs (both local lookups + remote)
// [NOTE] Still enable this for checks to happen locally
// [SETTING] Privacy & Security>Security>... "Block dangerous downloads"
// user_pref("browser.safebrowsing.downloads.enabled", false); // all checks happen locally

// PREF: disable SB checks for downloads (remote)
// To verify the safety of certain executable files, Firefox may submit some information about the
// file, including the name, origin, size and a cryptographic hash of the contents, to the Google
// Safe Browsing service which helps Firefox determine whether or not the file should be blocked.
// [NOTE] If you do not understand the consequences, override this.
// user_pref("browser.safebrowsing.downloads.remote.enabled", false);
      // user_pref("browser.safebrowsing.downloads.remote.url", "");
// disable SB checks for unwanted software
// [SETTING] Privacy & Security>Security>... "Warn you about unwanted and uncommon software"
        // user_pref("browser.safebrowsing.downloads.remote.block_potentially_unwanted", false);
        // user_pref("browser.safebrowsing.downloads.remote.block_uncommon", false);

// PREF: allow user to "ignore this warning" on SB warnings
// If clicked, it bypasses the block for that session. This is a means for admins to enforce SB.
// Report false positives to [2]
// [TEST] see https://github.com/arkenfox/user.js/wiki/Appendix-A-Test-Sites#-mozilla
// [1] https://bugzilla.mozilla.org/1226490
// [2] https://safebrowsing.google.com/safebrowsing/report_general/
// user_pref("browser.safebrowsing.allowOverride", true); // DEFAULT

// PREF: prevent accessibility services from accessing your browser [RESTART]
// Accessibility Service may negatively impact Firefox browsing performance
// Disable it if you’re not using any type of physical impairment assistive software
// [1] https://support.mozilla.org/kb/accessibility-services
// [2] https://www.ghacks.net/2021/08/25/firefox-tip-turn-off-accessibility-services-to-improve-performance/
// [3] https://www.troddit.com/r/firefox/comments/p8g5zd/why_does_disabling_accessibility_services_improve
// [4] https://winaero.com/firefox-has-accessibility-service-memory-leak-you-should-disable-it/
// [5] https://www.ghacks.net/2022/12/26/firefoxs-accessibility-performance-is-getting-a-huge-boost/
user_pref("accessibility.force_disabled", 1);

// PREF: disable the Accessibility panel
// user_pref("devtools.accessibility.enabled", false);

// PREF: disable Firefox accounts
// [ALTERNATIVE] Use xBrowserSync [1]
// [1] https://addons.mozilla.org/en-US/firefox/addon/xbs
// [2] https://github.com/arkenfox/user.js/issues/1175
// user_pref("identity.fxaccounts.enabled", false);

// PREF: disable Firefox View [FF106+]
// [1] https://support.mozilla.org/en-US/kb/how-set-tab-pickup-firefox-view#w_what-is-firefox-view
user_pref("browser.tabs.firefox-view", false);

// PREF: disable Push Notifications API [FF44+]
// Push is an API that allows websites to send you (subscribed) messages even when the site
// isn't loaded, by pushing messages to your userAgentID through Mozilla's Push Server.
// You shouldn't need to disable this.
// [WHY] Push requires subscription
// [NOTE] To remove all subscriptions, reset "dom.push.userAgentID"
// [1] https://support.mozilla.org/en-US/kb/push-notifications-firefox
// [2] https://developer.mozilla.org/en-US/docs/Web/API/Push_API
// [3] https://www.reddit.com/r/firefox/comments/fbyzd4/the_most_private_browser_isnot_firefox/
//user_pref("dom.push.enabled", false);
    //user_pref("dom.push.userAgentID", "");

// PREF: disable annoying location requests from websites
user_pref("permissions.default.geo", 2);
// PREF: Use Mozilla geolocation service instead of Google when geolocation is enabled
user_pref("geo.provider.network.url", "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%");
// PREF: Enable logging geolocation to the console
//user_pref("geo.provider.network.logging.enabled", true);

// PREF: disable using the OS's geolocation service
user_pref("geo.provider.ms-windows-location", false); // [WINDOWS]
user_pref("geo.provider.use_corelocation", false); // [MAC]
user_pref("geo.provider.use_gpsd", false); // [LINUX]
user_pref("geo.provider.use_geoclue", false); // [FF102+] [LINUX]

// PREF: disable region updates
// [1] https://firefox-source-docs.mozilla.org/toolkit/modules/toolkit_modules/Region.html
user_pref("browser.region.update.enabled", false);
    user_pref("browser.region.network.url", "");

// PREF: Enforce Firefox blocklist for extensions + No hiding tabs
// This includes updates for "revoked certificates".
// [1] https://blog.mozilla.org/security/2015/03/03/revoking-intermediate-certificates-introducing-onecrl/
// [2] https://trac.torproject.org/projects/tor/ticket/16931
user_pref("extensions.blocklist.enabled", true); // DEFAULT

// PREF: disable auto-INSTALLING Firefox updates [NON-WINDOWS]
// [NOTE] In FF65+ on Windows this SETTING (below) is now stored in a file and the pref was removed
// [SETTING] General>Firefox Updates>Check for updates but let you choose to install them
user_pref("app.update.auto", false);

// PREF: disable automatic extension updates
//user_pref("extensions.update.enabled", false);

// PREF: disable search engine updates (e.g. OpenSearch)
// [NOTE] This does not affect Mozilla's built-in or Web Extension search engines
user_pref("browser.search.update", false);

// PREF: remove special permissions for certain mozilla domains
// default = resource://app/defaults/permissions
user_pref("permissions.manager.defaultsUrl", "");

// PREF: remove webchannel whitelist
user_pref("webchannel.allowObject.urlWhitelist", "");

// PREF: disable mozAddonManager Web API [FF57+]
// [NOTE] To allow extensions to work on AMO, you also need 2662
// [1] https://bugzilla.mozilla.org/buglist.cgi?bug_id=1384330,1406795,1415644,1453988
user_pref("privacy.resistFingerprinting.block_mozAddonManager", true); // [HIDDEN]

// PREF: remove "addons.mozilla.org" from set of domains that extensions cannot access
// [NOTE] May only work with privacy.resistfingerprinting enabled? and/or DEV/NIGHTLY-only?
// [1] https://www.reddit.com/r/firefox/comments/n1lpaf/make_addons_work_on_mozilla_sites/gwdy235/?context=3
user_pref("extensions.webextensions.restrictedDomains", "accounts-static.cdn.mozilla.net,accounts.firefox.com,addons.cdn.mozilla.net,api.accounts.firefox.com,content.cdn.mozilla.net,discovery.addons.mozilla.org,install.mozilla.org,oauth.accounts.firefox.com,profile.accounts.firefox.com,support.mozilla.org,sync.services.mozilla.com");

// PREF: do not require signing for extensions [ESR/DEV/NIGHTLY ONLY]
// [1] https://support.mozilla.org/en-US/kb/add-on-signing-in-firefox#w_what-are-my-options-if-i-want-to-use-an-unsigned-add-on-advanced-users
// user_pref("xpinstall.signatures.required", false);

// PREF: Telemetry
user_pref("toolkit.telemetry.unified", false); // disable telemetry
user_pref("toolkit.telemetry.enabled", false); // disable telemetry
user_pref("toolkit.telemetry.server", "data:,"); // provide null telemetry server
user_pref("toolkit.telemetry.archive.enabled", false); // disallow pings to be archived locally
user_pref("toolkit.telemetry.newProfilePing.enabled", false); // disable "new-profile" ping on new profiles
user_pref("toolkit.telemetry.shutdownPingSender.enabled", false); // disallow the "shutdown" ping to be sent when the browser shuts down
user_pref("toolkit.telemetry.updatePing.enabled", false); // disable the "update" ping on browser updates
user_pref("toolkit.telemetry.bhrPing.enabled", false);
user_pref("toolkit.telemetry.firstShutdownPing.enabled", false); // disallow a duplicate of the main shutdown ping from the first browsing session to be sent as a separate first-shutdown ping.
user_pref("toolkit.telemetry.dap_enabled", false); // DEFAULT [FF108]

// PREF: Corroborator
user_pref("corroborator.enabled", false);

// PREF: Telemetry Coverage
user_pref("toolkit.telemetry.coverage.opt-out", true); // disable extension that probes 1% users and sends telemetry of them
user_pref("toolkit.coverage.opt-out", true); // disable coverage ping
      user_pref("toolkit.coverage.endpoint.base", "");

// PREF: new data submission, master kill switch
// If disabled, no policy is shown or upload takes place, ever
// [1] https://bugzilla.mozilla.org/1195552
user_pref("datareporting.policy.dataSubmissionEnabled", false);

// PREF: Studies
// [SETTING] Privacy & Security>Firefox Data Collection & Use>Allow Firefox to install and run studies
user_pref("app.shield.optoutstudies.enabled", false);

// Personalized Extension Recommendations in about:addons and AMO
// [NOTE] This pref has no effect when Health Reports are disabled.
// [SETTING] Privacy & Security>Firefox Data Collection & Use>Allow Firefox to make personalized extension recommendations
user_pref("browser.discovery.enabled", false);

// PREF: disable crash reports
user_pref("breakpad.reportURL", "");
user_pref("browser.tabs.crashReporting.sendReport", false);
    user_pref("browser.crashReports.unsubmittedCheck.enabled", false); // DEFAULT
// PREF: enforce no submission of backlogged crash reports
user_pref("browser.crashReports.unsubmittedCheck.autoSubmit2", false);

// PREF: Captive Portal detection
// [WARNING] Do NOT use for mobile devices. May NOT be able to use Firefox on public wifi (hotels, coffee shops, etc).
// [1] https://www.eff.org/deeplinks/2017/08/how-captive-portals-interfere-wireless-security-and-privacy
// [2] https://wiki.mozilla.org/Necko/CaptivePortal
user_pref("captivedetect.canonicalURL", "");
user_pref("network.captive-portal-service.enabled", false);

// PREF: Network Connectivity checks
// [WARNING] Do NOT use for mobile devices. May NOT be able to use Firefox on public wifi (hotels, coffee shops, etc).
// [1] https://bugzilla.mozilla.org/1460537
user_pref("network.connectivity-service.enabled", false);

// PREF: software that continually reports what default browser you are using
// [WARNING] Breaks "Make Default..." button in Preferences to set Firefox as the default browser [1].
// [1] https://github.com/yokoffing/Betterfox/issues/166
user_pref("default-browser-agent.enabled", false);

// PREF: "report extensions for abuse"
// user_pref("extensions.abuseReport.enabled", false);

// PREF: Normandy/Shield [extensions tracking]
// Shield is an telemetry system (including Heartbeat) that can also push and test "recipes"
user_pref("app.normandy.enabled", false); // disable remote control of the firefox browser
user_pref("app.normandy.api_url", ""); // disable remote control command and controll server of the firefox browser

// PREF: PingCentre telemetry (used in several System Add-ons)
// Currently blocked by 'datareporting.healthreport.uploadEnabled'
user_pref("browser.ping-centre.telemetry", false);

// PREF: disable Firefox Home (Activity Stream) telemetry
user_pref("browser.newtabpage.activity-stream.telemetry", false);
user_pref("browser.newtabpage.activity-stream.feeds.telemetry", false);

// PREF: disable check for proxies
user_pref("network.notify.checkForProxies", false);
