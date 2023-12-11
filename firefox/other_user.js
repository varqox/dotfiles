// Mozilla User Preferences (see: https://hg.mozilla.org/mozilla-central/file/tip/browser/app/profile/firefox.js)


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

// Full screen mode warning: shorten duration
user_pref("full-screen-api.warning.delay", 0);
user_pref("full-screen-api.warning.timeout", 300);

// Video hardware acceleration under Wayland
user_pref("media.ffmpeg.vaapi.enabled", true);

// Disable showing menu on pressing Alt
user_pref("ui.key.menuAccessKeyFocuses", false);

// TODO: Dictionary for both english and Polish
user_pref("spellchecker.dictionary", "en-gb-large-pl-pl-us");

// Reduce animations in browser and supporting web pages
// user_pref("ui.prefersReducedMotion", 1);
// user_pref("devtools.inspector.simple-highlighters.message-dismissed", true);

// Make typing in urlbar select custom url first. It improves over time
user_pref("browser.urlbar.autoFill.adaptiveHistory.enabled", true);

// Make the "Show in Folder" for downloaded files be opened in Thunar (still does not select the file, but at least something happens)
// user_pref("widget.use-xdg-desktop-portal.open-uri", 1); // Does not work

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// How long FF will wait before rendering the page, in milliseconds
// Reduce the 5ms Firefox waits to render the page
// [1] https://bugzilla.mozilla.org/show_bug.cgi?id=1283302
// [2] https://docs.google.com/document/d/1BvCoZzk2_rNZx3u9ESPoFjSADRI0zIPeJRXFLwWXx_4/edit#heading=h.28ki6m8dg30z
user_pref("nglayout.initialpaint.delay", 0); // default=5; used to be 250
user_pref("nglayout.initialpaint.delay_in_oopif", 0); // default=5

// PREF: notification interval (in microseconds) [to avoid layout thrashing]
// When Firefox is loading a page, it periodically reformats
// or "reflows" the page as it loads. The page displays new elements
// every 0.12 seconds by default. These redraws increase the total page load time.
// The default value provides good incremental display of content
// without causing an increase in page load time.
// [NOTE] Lowering the interval will increase responsiveness
// but also increase the total load time.
// [WARNING] If this value is set below 1/10 of a second, it starts
// to impact page load performance.
// [EXAMPLE] 100000 = .10s = 100 reflows/second
// [1] https://searchfox.org/mozilla-central/rev/c1180ea13e73eb985a49b15c0d90e977a1aa919c/modules/libpref/init/StaticPrefList.yaml#1824-1834
// [2] https://dev.opera.com/articles/efficient-javascript/?page=3#reflow
// [3] https://dev.opera.com/articles/efficient-javascript/?page=3#smoothspeed
user_pref("content.notify.interval", 100000); // (.10s); alt=500000 (.50s)

// PREF: disable preSkeletonUI on startup
user_pref("browser.startup.preXulSkeletonUI", false);

// PREF: CSS Masonry Layout [NIGHTLY]
// [1] https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Grid_Layout/Masonry_Layout
user_pref("layout.css.grid-template-masonry-value.enabled", true);

// PREF: CSS Animation Composition [NIGHTLY]
// [1] https://bugzilla.mozilla.org/show_bug.cgi?id=1785329
// [2] https://bugzilla.mozilla.org/show_bug.cgi?id=1293490
// [3] https://developer.mozilla.org/en-US/docs/Web/CSS/animation-composition
user_pref("layout.css.animation-composition.enabled", true);

// PREF: Prioritized Task Scheduling API [NIGHTLY]
// [1] https://blog.mozilla.org/performance/2022/06/02/prioritized-task-scheduling-api-is-prototyped-in-nightly/
// [2] https://medium.com/airbnb-engineering/building-a-faster-web-experience-with-the-posttask-scheduler-276b83454e91
user_pref("dom.enable_web_task_scheduling", true);

// PREF: Webrender tweaks
// [1] https://searchfox.org/mozilla-central/rev/6e6332bbd3dd6926acce3ce6d32664eab4f837e5/modules/libpref/init/StaticPrefList.yaml#6202-6219
// [2] https://hacks.mozilla.org/2017/10/the-whole-web-at-maximum-fps-how-webrender-gets-rid-of-jank/
// [3] https://www.troddit.com/r/firefox/comments/tbphok/is_setting_gfxwebrenderprecacheshaders_to_true/i0bxs2r/
// [4] https://www.troddit.com/r/firefox/comments/z5auzi/comment/ixw65gb?context=3
user_pref("gfx.webrender.all", true); // enables WR (GPU) + additional features
user_pref("gfx.webrender.precache-shaders", true);
user_pref("gfx.webrender.compositor", true);
    //user_pref("gfx.webrender.compositor.force-enabled", true); // enforce
user_pref("layers.gpu-process.enabled", true);
    //user_pref("layers.gpu-process.force-enabled", true); // enforce
// Verify hardware video decoding: https://test-videos.co.uk/ + sudo intel_gpu_top
user_pref("media.hardware-video-decoding.enabled", true);
    //user_pref("media.hardware-video-decoding.force-enabled", true); // enforce

// PREF: GPU-accelerated Canvas2D
// [WARNING] May break PDF rendering on Surface Pro devices [2]
// [1] https://bugzilla.mozilla.org/show_bug.cgi?id=1739448
// [2] https://github.com/yokoffing/Betterfox/issues/153
user_pref("gfx.canvas.accelerated", true); // DEFAULT on macOS and Linux v.110
user_pref("gfx.canvas.accelerated.cache-items", 32768);
user_pref("gfx.canvas.accelerated.cache-size", 4096);
user_pref("gfx.content.skia-font-cache-size", 80);

// PREF: image tweaks
user_pref("image.cache.size", 10485760);
user_pref("image.mem.decode_bytes_at_a_time", 131072); // alt=65536; preferred=262144; chunk size for calls to the image decoders
user_pref("image.mem.shared.unmap.min_expiration_ms", 120000); // default=60000; minimum timeout to unmap shared surfaces since they have been last used

// PREF: increase media cache
user_pref("media.memory_cache_max_size", 1048576); // alt=512000; also in Securefox (inactive there)
user_pref("media.memory_caches_combined_limit_kb", 2560000); // preferred=3145728; // default=524288
    //user_pref("media.memory_caches_combined_limit_pc_sysmem", 20); // default=5

// PREF: decrease video buffering
// [NOTE] Does not affect videos over 720p since they use DASH playback [1]
// [1] https://lifehacker.com/preload-entire-youtube-videos-by-disabling-dash-playbac-1186454034
//user_pref("media.cache_size", 2048000); // default=512000
user_pref("media.cache_readahead_limit", 9000); // default=60; stop reading ahead when our buffered data is this many seconds ahead of the current playback
user_pref("media.cache_resume_threshold", 6000); // default=30; when a network connection is suspended, don't resume it until the amount of buffered data falls below this threshold (in seconds)

// PREF: increase memory cache size
// [1] https://www.makeuseof.com/tag/how-much-data-does-youtube-use/
//user_pref("browser.cache.memory.capacity", -1); // DEFAULT; 256000=256MB, 512000=512MB, 1024000=1GB, 2097152=2GB, 5242880=5GB, 8388608=8GB
user_pref("browser.cache.memory.max_entry_size", 153600); // alt=51200; preferred=327680 ; alt= -1 -> entries bigger than than 90% of the mem-cache are never cached


// PREF: use bigger packets
// [1] https://www.mail-archive.com/support-seamonkey@lists.mozilla.org/msg74561.html
// [2] https://www.mail-archive.com/support-seamonkey@lists.mozilla.org/msg74570.html
user_pref("network.buffer.cache.size", 262144); // preferred=327680; default=32768
user_pref("network.buffer.cache.count", 128); // preferred=240; default=24

// PREF: increase the absolute number of HTTP connections
// [1] https://kb.mozillazine.org/Network.http.max-connections
// [2] https://kb.mozillazine.org/Network.http.max-persistent-connections-per-server
// [3] https://old.reddit.com/r/firefox/comments/11m2yuh/how_do_i_make_firefox_use_more_of_my_900_megabit/jbfmru6/
user_pref("network.http.max-connections", 1800); // default=900
user_pref("network.http.max-persistent-connections-per-server", 10); // default=6; download connections; anything above 10 is excessive
//user_pref("network.http.max-persistent-connections-per-proxy", 48); // default=32
//user_pref("network.http.max-urgent-start-excessive-connections-per-host", 6); // default=3
//user_pref("network.http.pacing.requests.min-parallelism", 18); // default=6

// PREF: increase TLS token caching
user_pref("network.ssl_tokens_cache_capacity", 32768); // default=2048; more TLS token caching (fast reconnects)

// PREF: Disable Service Workers
// https://developer.mozilla.org/en-US/docs/Web/API/Worker
// https://developer.mozilla.org/en-US/docs/Web/API/ServiceWorker_API
// https://wiki.mozilla.org/Firefox/Push_Notifications#Service_Workers
// NOTICE: Disabling ServiceWorkers breaks functionality on some sites (Google Street View...)
// NOTICE: Disabling ServiceWorkers breaks Firefox Sync
// Unknown security implications
// CVE-2016-5259, CVE-2016-2812, CVE-2016-1949, CVE-2016-5287 (fixed)
user_pref("dom.serviceWorkers.enabled",				false);

// PREF: Disable web notifications
// https://support.mozilla.org/en-US/questions/1140439
user_pref("dom.webnotifications.enabled",			false);

// PREF: Disable DOM timing API
// https://wiki.mozilla.org/Security/Reviews/Firefox/NavigationTimingAPI
// https://www.w3.org/TR/navigation-timing/#privacy
user_pref("dom.enable_performance",				false);

// PREF: Disable resource timing API
// https://www.w3.org/TR/resource-timing/#privacy-security
// NOTICE: Disabling resource timing API breaks some DDoS protection pages (Cloudflare)
user_pref("dom.enable_resource_timing",				false);

// PREF: Make sure the User Timing API does not provide a new high resolution timestamp
// https://trac.torproject.org/projects/tor/ticket/16336
// https://www.w3.org/TR/2013/REC-user-timing-20131212/#privacy-security
user_pref("dom.enable_user_timing",				false);

// PREF: Disable Web Audio API
// https://bugzilla.mozilla.org/show_bug.cgi?id=1288359
// NOTICE: Web Audio API is required for Unity web player/games
user_pref("dom.webaudio.enabled",				false);

// PREF: Disable Location-Aware Browsing (geolocation)
// https://www.mozilla.org/en-US/firefox/geolocation/
user_pref("geo.enabled",					false);

// PREF: When geolocation is enabled, use Mozilla geolocation service instead of Google
// https://bugzilla.mozilla.org/show_bug.cgi?id=689252
user_pref("geo.wifi.uri", "https://location.services.mozilla.com/v1/geolocate?key=%MOZILLA_API_KEY%");

// PREF: When geolocation is enabled, don't log geolocation requests to the console
user_pref("geo.wifi.logging.enabled", false);

// PREF: Disable raw TCP socket support (mozTCPSocket)
// https://trac.torproject.org/projects/tor/ticket/18863
// https://www.mozilla.org/en-US/security/advisories/mfsa2015-97/
// https://developer.mozilla.org/docs/Mozilla/B2G_OS/API/TCPSocket
user_pref("dom.mozTCPSocket.enabled",				false);

// PREF: Disable DOM storage (disabled)
// http://kb.mozillazine.org/Dom.storage.enabled
// https://html.spec.whatwg.org/multipage/webstorage.html
// NOTICE-DISABLED: Disabling DOM storage is known to cause`TypeError: localStorage is null` errors
//user_pref("dom.storage.enabled",		false);

// PREF: Disable leaking network/browser connection information via Javascript
// Network Information API provides general information about the system's connection type (WiFi, cellular, etc.)
// https://developer.mozilla.org/en-US/docs/Web/API/Network_Information_API
// https://wicg.github.io/netinfo/#privacy-considerations
// https://bugzilla.mozilla.org/show_bug.cgi?id=960426
user_pref("dom.netinfo.enabled",				false);

// PREF: Don't reveal your internal IP when WebRTC is enabled (Firefox >= 42)
// https://wiki.mozilla.org/Media/WebRTC/Privacy
// https://github.com/beefproject/beef/wiki/Module%3A-Get-Internal-IP-WebRTC
user_pref("media.peerconnection.ice.default_address_only",	true); // Firefox 42-51
user_pref("media.peerconnection.ice.no_host",			true); // Firefox >= 52

// PREF: Disable telephony API
// https://wiki.mozilla.org/WebAPI/Security/WebTelephony
user_pref("dom.telephony.enabled",				false);

// PREF: Disable "beacon" asynchronous HTTP transfers (used for analytics)
// https://developer.mozilla.org/en-US/docs/Web/API/navigator.sendBeacon
user_pref("beacon.enabled",					false);
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// PREF: Disable clipboard event detection (onCut/onCopy/onPaste) via Javascript
// NOTICE: Disabling clipboard events breaks Ctrl+C/X/V copy/cut/paste functionaility in JS-based web applications (Google Docs...)
// https://developer.mozilla.org/en-US/docs/Mozilla/Preferences/Preference_reference/dom.event.clipboardevents.enabled
user_pref("dom.event.clipboardevents.enabled",			false);

// PREF: Disable "copy to clipboard" functionality via Javascript (Firefox >= 41)
// NOTICE: Disabling clipboard operations will break legitimate JS-based "copy to clipboard" functionality
// https://hg.mozilla.org/mozilla-central/rev/2f9f8ea4b9c3
// user_pref("dom.allow_cut_copy", false);

// PREF: Disable speech recognition
// https://dvcs.w3.org/hg/speech-api/raw-file/tip/speechapi.html
// https://developer.mozilla.org/en-US/docs/Web/API/SpeechRecognition
// https://wiki.mozilla.org/HTML5_Speech_API
user_pref("media.webspeech.recognition.enable",			false);

// PREF: Disable speech synthesis
// https://developer.mozilla.org/en-US/docs/Web/API/SpeechSynthesis
user_pref("media.webspeech.synth.enabled",			false);

// PREF: Disable sensor API
// https://wiki.mozilla.org/Sensor_API
user_pref("device.sensors.enabled",				false);

// PREF: Disable pinging URIs specified in HTML <a> ping= attributes
// http://kb.mozillazine.org/Browser.send_pings
user_pref("browser.send_pings",					false);

// PREF: When browser pings are enabled, only allow pinging the same host as the origin page
// http://kb.mozillazine.org/Browser.send_pings.require_same_host
user_pref("browser.send_pings.require_same_host",		true);

// PREF: Disable gamepad API to prevent USB device enumeration
// https://www.w3.org/TR/gamepad/
// https://trac.torproject.org/projects/tor/ticket/13023
user_pref("dom.gamepad.enabled",				false);

// PREF: Disable virtual reality devices APIs
// https://developer.mozilla.org/en-US/Firefox/Releases/36#Interfaces.2FAPIs.2FDOM
// https://developer.mozilla.org/en-US/docs/Web/API/WebVR_API
user_pref("dom.vr.enabled",					false);

// PREF: Disable vibrator API
user_pref("dom.vibrator.enabled",           false);

// PREF: Disable webGL
// https://en.wikipedia.org/wiki/WebGL
// https://www.contextis.com/resources/blog/webgl-new-dimension-browser-exploitation/
user_pref("webgl.disabled",					true);
// PREF: When webGL is enabled, use the minimum capability mode
user_pref("webgl.min_capability_mode",				true);
// PREF: When webGL is enabled, disable webGL extensions
// https://developer.mozilla.org/en-US/docs/Web/API/WebGL_API#WebGL_debugging_and_testing
user_pref("webgl.disable-extensions",				true);
// PREF: When webGL is enabled, force enabling it even when layer acceleration is not supported
// https://trac.torproject.org/projects/tor/ticket/18603
user_pref("webgl.disable-fail-if-major-performance-caveat",	true);
// PREF: When webGL is enabled, do not expose information about the graphics driver
// https://bugzilla.mozilla.org/show_bug.cgi?id=1171228
// https://developer.mozilla.org/en-US/docs/Web/API/WEBGL_debug_renderer_info
user_pref("webgl.enable-debug-renderer-info",			false);
// somewhat related...
//user_pref("pdfjs.enableWebGL",					false);

// PREF: Spoof dual-core CPU
// https://trac.torproject.org/projects/tor/ticket/21675
// https://bugzilla.mozilla.org/show_bug.cgi?id=1360039
user_pref("dom.maxHardwareConcurrency",				2);

// PREF: Disable WebAssembly
// https://webassembly.org/
// https://en.wikipedia.org/wiki/WebAssembly
// https://trac.torproject.org/projects/tor/ticket/21549
// NOTICE: WebAssembly is required for Unity web player/games
user_pref("javascript.options.wasm",				false);

/******************************************************************************
 * SECTION: Misc                                                              *
 ******************************************************************************/

// PREF: Disable face detection
user_pref("camera.control.face_detection.enabled",		false);

// PREF: Disable GeoIP lookup on your address to set default search engine region
// https://trac.torproject.org/projects/tor/ticket/16254
// https://support.mozilla.org/en-US/kb/how-stop-firefox-making-automatic-connections#w_geolocation-for-default-search-engine
user_pref("browser.search.countryCode",				"PL");
user_pref("browser.search.region",				"PL");
user_pref("browser.search.geoip.url",				"");

// PREF: Set Accept-Language HTTP header to en-US regardless of Firefox localization
// https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Accept-Language
user_pref("intl.accept_languages",				"en-US, en");

// PREF: Don't use OS values to determine locale, force using Firefox locale setting
// http://kb.mozillazine.org/Intl.locale.matchOS
user_pref("intl.locale.matchOS",				false);

// Use LANG environment variable to choose locale (disabled)
//pref("intl.locale.requested", "");

// PREF: Don't use Mozilla-provided location-specific search engines
user_pref("browser.search.geoSpecificDefaults",			false);

// PREF: Do not automatically send selection to clipboard on some Linux platforms
// http://kb.mozillazine.org/Clipboard.autocopy
// user_pref("clipboard.autocopy",					false);

// PREF: Prevent leaking application locale/date format using JavaScript
// https://bugzilla.mozilla.org/show_bug.cgi?id=867501
// https://hg.mozilla.org/mozilla-central/rev/52d635f2b33d
user_pref("javascript.use_us_english_locale",			true);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// PREF: Do not submit invalid URIs entered in the address bar to the default search engine
// http://kb.mozillazine.org/Keyword.enabled
user_pref("keyword.enabled",					false);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// PREF: Don't trim HTTP off of URLs in the address bar.
// https://bugzilla.mozilla.org/show_bug.cgi?id=665580
user_pref("browser.urlbar.trimURLs",				false);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// PREF: Don't try to guess domain names when entering an invalid domain name in URL bar
// http://www-archive.mozilla.org/docs/end-user/domain-guessing.html
user_pref("browser.fixup.alternate.enabled",			false);

// PREF: When browser.fixup.alternate.enabled is enabled, strip password from 'user:password@...' URLs
// https://github.com/pyllyukko/user.js/issues/290#issuecomment-303560851
user_pref("browser.fixup.hide_user_pass", true);

// PREF: Send DNS request through SOCKS when SOCKS proxying is in use
// https://trac.torproject.org/projects/tor/wiki/doc/TorifyHOWTO/WebBrowsers
user_pref("network.proxy.socks_remote_dns",			true);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// PREF: Don't monitor OS online/offline connection state
// https://trac.torproject.org/projects/tor/ticket/18945
user_pref("network.manage-offline-status",			false);

// PREF: Enforce Mixed Active Content Blocking
// https://support.mozilla.org/t5/Protect-your-privacy/Mixed-content-blocking-in-Firefox/ta-p/10990
// https://developer.mozilla.org/en-US/docs/Site_Compatibility_for_Firefox_23#Non-SSL_contents_on_SSL_pages_are_blocked_by_default
// https://blog.mozilla.org/tanvi/2013/04/10/mixed-content-blocking-enabled-in-firefox-23/
user_pref("security.mixed_content.block_active_content",	true);

// PREF: Enforce Mixed Passive Content blocking (a.k.a. Mixed Display Content)
// NOTICE: Enabling Mixed Display Content blocking can prevent images/styles... from loading properly when connection to the website is only partially secured
user_pref("security.mixed_content.block_display_content",	true);

// PREF: Disable JAR from opening Unsafe File Types
// http://kb.mozillazine.org/Network.jar.open-unsafe-types
// CIS Mozilla Firefox 24 ESR v1.0.0 - 3.7
user_pref("network.jar.open-unsafe-types",			false);

// CIS 2.7.4 Disable Scripting of Plugins by JavaScript
// http://forums.mozillazine.org/viewtopic.php?f=7&t=153889
user_pref("security.xpconnect.plugin.unrestricted",		false);

// PREF: Set File URI Origin Policy
// http://kb.mozillazine.org/Security.fileuri.strict_origin_policy
// CIS Mozilla Firefox 24 ESR v1.0.0 - 3.8
user_pref("security.fileuri.strict_origin_policy",		true);

// PREF: Disable Displaying Javascript in History URLs
// http://kb.mozillazine.org/Browser.urlbar.filter.javascript
// CIS 2.3.6
user_pref("browser.urlbar.filter.javascript",			true);

// PREF: Disable asm.js
// http://asmjs.org/
// https://www.mozilla.org/en-US/security/advisories/mfsa2015-29/
// https://www.mozilla.org/en-US/security/advisories/mfsa2015-50/
// https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2015-2712
user_pref("javascript.options.asmjs",				false);

// PREF: Disable SVG in OpenType fonts
// https://wiki.mozilla.org/SVGOpenTypeFonts
// https://github.com/iSECPartners/publications/tree/master/reports/Tor%20Browser%20Bundle
user_pref("gfx.font_rendering.opentype_svg.enabled",		false);

// PREF: Disable in-content SVG rendering (Firefox >= 53) (disabled)
// NOTICE-DISABLED: Disabling SVG support breaks many UI elements on many sites
// https://bugzilla.mozilla.org/show_bug.cgi?id=1216893
// https://github.com/iSECPartners/publications/raw/master/reports/Tor%20Browser%20Bundle/Tor%20Browser%20Bundle%20-%20iSEC%20Deliverable%201.3.pdf#16
//user_pref("svg.disabled", true);

// PREF: Disable video stats to reduce fingerprinting threat
// https://bugzilla.mozilla.org/show_bug.cgi?id=654550
// https://github.com/pyllyukko/user.js/issues/9#issuecomment-100468785
// https://github.com/pyllyukko/user.js/issues/9#issuecomment-148922065
user_pref("media.video_stats.enabled",				false);

// PREF: Don't reveal build ID
// Value taken from Tor Browser
// https://bugzilla.mozilla.org/show_bug.cgi?id=583181
user_pref("general.buildID.override",				"20100101");
user_pref("browser.startup.homepage_override.buildID",		"20100101");

// PREF: Don't use document specified fonts to prevent installed font enumeration (fingerprinting)
// https://github.com/pyllyukko/user.js/issues/395
// https://browserleaks.com/fonts
// https://github.com/pyllyukko/user.js/issues/120
// user_pref("browser.display.use_document_fonts",			0);

// PREF: Enable only whitelisted URL protocol handlers
// http://kb.mozillazine.org/Network.protocol-handler.external-default
// http://kb.mozillazine.org/Network.protocol-handler.warn-external-default
// http://kb.mozillazine.org/Network.protocol-handler.expose.%28protocol%29
// https://news.ycombinator.com/item?id=13047883
// https://bugzilla.mozilla.org/show_bug.cgi?id=167475
// https://github.com/pyllyukko/user.js/pull/285#issuecomment-298124005
// NOTICE: Disabling nonessential protocols breaks all interaction with custom protocols such as mailto:, irc:, magnet: ... and breaks opening third-party mail/messaging/torrent/... clients when clicking on links with these protocols
// TODO: Add externally-handled protocols from Windows 8.1 and Windows 10 (currently contains protocols only from Linux and Windows 7) that might pose a similar threat (see e.g. https://news.ycombinator.com/item?id=13044991)
// TODO: Add externally-handled protocols from Mac OS X that might pose a similar threat (see e.g. https://news.ycombinator.com/item?id=13044991)
// If you want to enable a protocol, set network.protocol-handler.expose.(protocol) to true and network.protocol-handler.external.(protocol) to:
//   * true, if the protocol should be handled by an external application
//   * false, if the protocol should be handled internally by Firefox
user_pref("network.protocol-handler.warn-external-default",	true);
user_pref("network.protocol-handler.external.http",		false);
user_pref("network.protocol-handler.external.https",		false);
user_pref("network.protocol-handler.external.javascript",	false);
user_pref("network.protocol-handler.external.moz-extension",	false);
user_pref("network.protocol-handler.external.ftp",		false);
user_pref("network.protocol-handler.external.file",		false);
user_pref("network.protocol-handler.external.about",		false);
user_pref("network.protocol-handler.external.chrome",		false);
user_pref("network.protocol-handler.external.blob",		false);
user_pref("network.protocol-handler.external.data",		false);
user_pref("network.protocol-handler.expose-all",		false);
user_pref("network.protocol-handler.expose.http",		true);
user_pref("network.protocol-handler.expose.https",		true);
user_pref("network.protocol-handler.expose.javascript",		true);
user_pref("network.protocol-handler.expose.moz-extension",	true);
user_pref("network.protocol-handler.expose.ftp",		true);
user_pref("network.protocol-handler.expose.file",		true);
user_pref("network.protocol-handler.expose.about",		true);
user_pref("network.protocol-handler.expose.chrome",		true);
user_pref("network.protocol-handler.expose.blob",		true);
user_pref("network.protocol-handler.expose.data",		true);

/******************************************************************************
 * SECTION: Extensions / plugins                                                       *
 ******************************************************************************/

// PREF: Ensure you have a security delay when installing add-ons (milliseconds)
// http://kb.mozillazine.org/Disable_extension_install_delay_-_Firefox
// http://www.squarefree.com/2004/07/01/race-conditions-in-security-dialogs/
user_pref("security.dialog_enable_delay",			1000);

// PREF: Require signatures
// https://wiki.mozilla.org/Addons/Extension_Signing
user_pref("xpinstall.signatures.required",		true);

// PREF: Opt-out of add-on metadata updates
// https://blog.mozilla.org/addons/how-to-opt-out-of-add-on-metadata-updates/
user_pref("extensions.getAddons.cache.enabled",			false);

// PREF: Opt-out of themes (Persona) updates
// https://support.mozilla.org/t5/Firefox/how-do-I-prevent-autoamtic-updates-in-a-50-user-environment/td-p/144287
user_pref("lightweightThemes.update.enabled",			false);

// PREF: Disable Flash Player NPAPI plugin
// http://kb.mozillazine.org/Flash_plugin
user_pref("plugin.state.flash",					0);

// PREF: Disable Java NPAPI plugin
user_pref("plugin.state.java",					0);

// PREF: Disable sending Flash Player crash reports
user_pref("dom.ipc.plugins.flash.subprocess.crashreporter.enabled",	false);

// PREF: When Flash crash reports are enabled, don't send the visited URL in the crash report
user_pref("dom.ipc.plugins.reportCrashURL",			false);

// PREF: When Flash is enabled, download and use Mozilla SWF URIs blocklist
// https://bugzilla.mozilla.org/show_bug.cgi?id=1237198
// https://github.com/mozilla-services/shavar-plugin-blocklist
user_pref("browser.safebrowsing.blockedURIs.enabled", true);

// PREF: Disable Gnome Shell Integration NPAPI plugin
user_pref("plugin.state.libgnome-shell-browser-plugin",		0);

// PREF: Disable the bundled OpenH264 video codec (disabled)
// http://forums.mozillazine.org/viewtopic.php?p=13845077&sid=28af2622e8bd8497b9113851676846b1#p13845077
//user_pref("media.gmp-provider.enabled",		false);

// PREF: Enable plugins click-to-play
// https://wiki.mozilla.org/Firefox/Click_To_Play
// https://blog.mozilla.org/security/2012/10/11/click-to-play-plugins-blocklist-style/
user_pref("plugins.click_to_play",				true);

// PREF: Updates addons automatically
// https://blog.mozilla.org/addons/how-to-turn-off-add-on-updates/
user_pref("extensions.update.enabled",				true);

// PREF: Enable add-on and certificate blocklists (OneCRL) from Mozilla
// https://wiki.mozilla.org/Blocklisting
// https://blocked.cdn.mozilla.net/
// http://kb.mozillazine.org/Extensions.blocklist.enabled
// http://kb.mozillazine.org/Extensions.blocklist.url
// https://blog.mozilla.org/security/2015/03/03/revoking-intermediate-certificates-introducing-onecrl/
// Updated at interval defined in extensions.blocklist.interval (default: 86400)
user_pref("extensions.blocklist.enabled",			true);
user_pref("services.blocklist.update_enabled",			true);

// PREF: Decrease system information leakage to Mozilla blocklist update servers
// https://trac.torproject.org/projects/tor/ticket/16931
user_pref("extensions.blocklist.url",				"https://blocklist.addons.mozilla.org/blocklist/3/%APP_ID%/%APP_VERSION%/");

// PREF: Disable system add-on updates (hidden & always-enabled add-ons from Mozilla)
// https://firefox-source-docs.mozilla.org/toolkit/mozapps/extensions/addon-manager/SystemAddons.html
// https://blog.mozilla.org/data/2018/08/20/effectively-measuring-search-in-firefox/
// https://github.com/pyllyukko/user.js/issues/419
// https://dxr.mozilla.org/mozilla-central/source/toolkit/mozapps/extensions/AddonManager.jsm#1248-1257
// NOTICE: Disabling system add-on updates prevents Mozilla from "hotfixing" your browser to patch critical problems (one possible use case from the documentation)
// user_pref("extensions.systemAddon.update.enabled",		false);

/******************************************************************************
 * SECTION: Firefox (anti-)features / components                              *                            *
 ******************************************************************************/

// PREF: Disable Extension recommendations (Firefox >= 65)
// https://support.mozilla.org/en-US/kb/extension-recommendations
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr",	false);

// PREF: Disable WebIDE
// https://trac.torproject.org/projects/tor/ticket/16222
// https://developer.mozilla.org/docs/Tools/WebIDE
user_pref("devtools.webide.enabled",				false);
user_pref("devtools.webide.autoinstallADBHelper",		false);
user_pref("devtools.webide.autoinstallFxdtAdapters",		false);

// PREF: Disable remote debugging
// https://developer.mozilla.org/en-US/docs/Tools/Remote_Debugging/Debugging_Firefox_Desktop
// https://developer.mozilla.org/en-US/docs/Tools/Tools_Toolbox#Advanced_settings
user_pref("devtools.debugger.remote-enabled",			false);
user_pref("devtools.chrome.enabled",				false);
user_pref("devtools.debugger.force-local",			true);

// PREF: Disable Mozilla telemetry/experiments
// https://wiki.mozilla.org/Platform/Features/Telemetry
// https://wiki.mozilla.org/Privacy/Reviews/Telemetry
// https://wiki.mozilla.org/Telemetry
// https://www.mozilla.org/en-US/legal/privacy/firefox.html#telemetry
// https://support.mozilla.org/t5/Firefox-crashes/Mozilla-Crash-Reporter/ta-p/1715
// https://wiki.mozilla.org/Security/Reviews/Firefox6/ReviewNotes/telemetry
// https://gecko.readthedocs.io/en/latest/browser/experiments/experiments/manifest.html
// https://wiki.mozilla.org/Telemetry/Experiments
// https://support.mozilla.org/en-US/questions/1197144
// https://firefox-source-docs.mozilla.org/toolkit/components/telemetry/telemetry/internals/preferences.html#id1
user_pref("toolkit.telemetry.enabled",				false);
user_pref("toolkit.telemetry.unified",				false);
user_pref("toolkit.telemetry.archive.enabled",			false);
user_pref("experiments.supported",				false);
user_pref("experiments.enabled",				false);
user_pref("experiments.manifest.uri",				"");

// PREF: Disallow Necko to do A/B testing
// https://trac.torproject.org/projects/tor/ticket/13170
user_pref("network.allow-experiments",				false);

// PREF: Disable sending Firefox crash reports to Mozilla servers
// https://wiki.mozilla.org/Breakpad
// http://kb.mozillazine.org/Breakpad
// https://dxr.mozilla.org/mozilla-central/source/toolkit/crashreporter
// https://bugzilla.mozilla.org/show_bug.cgi?id=411490
// A list of submitted crash reports can be found at about:crashes
user_pref("breakpad.reportURL",					"");

// PREF: Disable sending reports of tab crashes to Mozilla (about:tabcrashed), don't nag user about unsent crash reports
// https://hg.mozilla.org/mozilla-central/file/tip/browser/app/profile/firefox.js
user_pref("browser.tabs.crashReporting.sendReport",		false);
user_pref("browser.crashReports.unsubmittedCheck.enabled",	false);

// PREF: Disable FlyWeb (discovery of LAN/proximity IoT devices that expose a Web interface)
// https://wiki.mozilla.org/FlyWeb
// https://wiki.mozilla.org/FlyWeb/Security_scenarios
// https://docs.google.com/document/d/1eqLb6cGjDL9XooSYEEo7mE-zKQ-o-AuDTcEyNhfBMBM/edit
// http://www.ghacks.net/2016/07/26/firefox-flyweb
user_pref("dom.flyweb.enabled",					false);

// PREF: Disable the UITour backend
// https://trac.torproject.org/projects/tor/ticket/19047#comment:3
user_pref("browser.uitour.enabled",				false);


// PREF: Enable contextual identity Containers feature (Firefox >= 52)
// NOTICE: Containers are not available in Private Browsing mode
// https://wiki.mozilla.org/Security/Contextual_Identity_Project/Containers
user_pref("privacy.userContext.enabled",			true);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// PREF: Enable Firefox's anti-fingerprinting mode ("resist fingerprinting" or RFP) (Tor Uplift project)
// https://wiki.mozilla.org/Security/Tor_Uplift/Tracking
// https://bugzilla.mozilla.org/show_bug.cgi?id=1333933
// https://wiki.mozilla.org/Security/Fingerprinting
// NOTICE: RFP breaks some keyboard shortcuts used in certain websites (see #443)
// NOTICE: RFP changes your time zone
// NOTICE: RFP breaks some DDoS protection pages (Cloudflare)
user_pref("privacy.resistFingerprinting",			true);

// PREF: disable mozAddonManager Web API [FF57+]
// https://bugzilla.mozilla.org/buglist.cgi?bug_id=1384330
// https://bugzilla.mozilla.org/buglist.cgi?bug_id=1406795
// https://bugzilla.mozilla.org/buglist.cgi?bug_id=1415644
// https://bugzilla.mozilla.org/buglist.cgi?bug_id=1453988
// https://trac.torproject.org/projects/tor/ticket/26114
user_pref("privacy.resistFingerprinting.block_mozAddonManager", true);
user_pref("extensions.webextensions.restrictedDomains", "");

// PREF: enable RFP letterboxing / resizing of inner window [FF67+] (disabled)
// https://bugzilla.mozilla.org/1407366
//user_pref("privacy.resistFingerprinting.letterboxing", true);
//user_pref("privacy.resistFingerprinting.letterboxing.dimensions", "800x600, 1000x1000, 1600x900");

// PREF: disable showing about:blank/maximized window as soon as possible during startup [FF60+]
// https://bugzilla.mozilla.org/1448423
user_pref("browser.startup.blankWindow", false);

// PREF: Disable the built-in PDF viewer
// https://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2015-2743
// https://blog.mozilla.org/security/2015/08/06/firefox-exploit-found-in-the-wild/
// https://www.mozilla.org/en-US/security/advisories/mfsa2015-69/
user_pref("pdfjs.disabled",					true);

// PREF: Disable collection/sending of the health report (healthreport.sqlite*)
// https://support.mozilla.org/en-US/kb/firefox-health-report-understand-your-browser-perf
// https://gecko.readthedocs.org/en/latest/toolkit/components/telemetry/telemetry/preferences.html
user_pref("datareporting.healthreport.uploadEnabled",		false);
user_pref("datareporting.healthreport.service.enabled",		false);
user_pref("datareporting.policy.dataSubmissionEnabled",		false);
// "Allow Firefox to make personalized extension recommendations"
user_pref("browser.discovery.enabled",				false);

// PREF: Disable Shield/Heartbeat/Normandy (Mozilla user rating telemetry)
// https://wiki.mozilla.org/Advocacy/heartbeat
// https://trac.torproject.org/projects/tor/ticket/19047
// https://trac.torproject.org/projects/tor/ticket/18738
// https://wiki.mozilla.org/Firefox/Shield
// https://github.com/mozilla/normandy
// https://support.mozilla.org/en-US/kb/shield
// https://bugzilla.mozilla.org/show_bug.cgi?id=1370801
// https://wiki.mozilla.org/Firefox/Normandy/PreferenceRollout
user_pref("app.normandy.enabled", false);
user_pref("app.normandy.api_url", "");
user_pref("extensions.shield-recipe-client.enabled",		false);
user_pref("app.shield.optoutstudies.enabled",			false);

// PREF: Enforce checking for Firefox updates
// http://kb.mozillazine.org/App.update.enabled
// NOTICE: Update check page might incorrectly report Firefox ESR as out-of-date
user_pref("app.update.enabled",                 true);

// PREF: Enable blocking reported web forgeries
// https://wiki.mozilla.org/Security/Safe_Browsing
// http://kb.mozillazine.org/Safe_browsing
// https://support.mozilla.org/en-US/kb/how-does-phishing-and-malware-protection-work
// http://forums.mozillazine.org/viewtopic.php?f=39&t=2711237&p=12896849#p12896849
// CIS 2.3.4
user_pref("browser.safebrowsing.phishing.enabled",		true); // firefox >= 50

// PREF: Enable blocking reported attack sites
// http://kb.mozillazine.org/Browser.safebrowsing.malware.enabled
// CIS 2.3.5
user_pref("browser.safebrowsing.malware.enabled",		true);

// PREF: Disable querying Google Application Reputation database for downloaded binary files
// https://www.mozilla.org/en-US/firefox/39.0/releasenotes/
// https://wiki.mozilla.org/Security/Application_Reputation
user_pref("browser.safebrowsing.downloads.remote.enabled",	false);

// PREF: Disable Pocket
// https://support.mozilla.org/en-US/kb/save-web-pages-later-pocket-firefox
// https://github.com/pyllyukko/user.js/issues/143
user_pref("browser.pocket.enabled",				false);
user_pref("extensions.pocket.enabled",				false);

// PREF: Disable "Recommended by Pocket" in Firefox Quantum
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories",	false);

/******************************************************************************
 * SECTION: Automatic connections                                             *
 ******************************************************************************/

// PREF: Limit the connection keep-alive timeout to 15 seconds (disabled)
// https://github.com/pyllyukko/user.js/issues/387
// http://kb.mozillazine.org/Network.http.keep-alive.timeout
// https://httpd.apache.org/docs/current/mod/core.html#keepalivetimeout
//user_pref("network.http.keep-alive.timeout",			15);

// PREF: Disable prefetching of <link rel="next"> URLs
// http://kb.mozillazine.org/Network.prefetch-next
// https://developer.mozilla.org/en-US/docs/Web/HTTP/Link_prefetching_FAQ#Is_there_a_preference_to_disable_link_prefetching.3F
user_pref("network.prefetch-next",				false);

// PREF: Disable DNS prefetching
// http://kb.mozillazine.org/Network.dns.disablePrefetch
// https://developer.mozilla.org/en-US/docs/Web/HTTP/Controlling_DNS_prefetching
user_pref("network.dns.disablePrefetch",			true);
user_pref("network.dns.disablePrefetchFromHTTPS",		true);

// PREF: Disable the predictive service (Necko)
// https://wiki.mozilla.org/Privacy/Reviews/Necko
user_pref("network.predictor.enabled",				false);

// PREF: Reject .onion hostnames before passing the to DNS
// https://bugzilla.mozilla.org/show_bug.cgi?id=1228457
// RFC 7686
user_pref("network.dns.blockDotOnion",				true);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// PREF: Disable search suggestions in the search bar
// http://kb.mozillazine.org/Browser.search.suggest.enabled
user_pref("browser.search.suggest.enabled",			false);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// PREF: Disable "Show search suggestions in location bar results"
user_pref("browser.urlbar.suggest.searches",			false);
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// PREF: When using the location bar, don't suggest URLs from browsing history
user_pref("browser.urlbar.suggest.history",			false);
// PREF: Disable Firefox Suggest
// https://www.ghacks.net/2021/09/09/how-to-disable-firefox-suggest/
// https://support.mozilla.org/en-US/kb/navigate-web-faster-firefox-suggest
user_pref("browser.urlbar.groupLabels.enabled", false); // Firefox >= 93

// PREF: Disable SSDP (Simple Service Discovery Protocol)
// https://bugzilla.mozilla.org/show_bug.cgi?id=1111967
user_pref("browser.casting.enabled",				false);

// PREF: Disable automatic downloading of OpenH264 codec
// https://support.mozilla.org/en-US/kb/how-stop-firefox-making-automatic-connections#w_media-capabilities
// https://andreasgal.com/2014/10/14/openh264-now-in-firefox/
user_pref("media.gmp-gmpopenh264.enabled",			false);
user_pref("media.gmp-manager.url",				"");

// PREF: Disable speculative pre-connections
// https://support.mozilla.org/en-US/kb/how-stop-firefox-making-automatic-connections#w_speculative-pre-connections
// https://bugzilla.mozilla.org/show_bug.cgi?id=814169
user_pref("network.http.speculative-parallel-limit",		0);

// PREF: Disable downloading homepage snippets/messages from Mozilla
// https://support.mozilla.org/en-US/kb/how-stop-firefox-making-automatic-connections#w_mozilla-content
// https://wiki.mozilla.org/Firefox/Projects/Firefox_Start/Snippet_Service
user_pref("browser.aboutHomeSnippets.updateUrl",		"");

// PREF: Never check updates for search engines
// https://support.mozilla.org/en-US/kb/how-stop-firefox-making-automatic-connections#w_auto-update-checking
user_pref("browser.search.update",				false);

// PREF: Disable automatic captive portal detection (Firefox >= 52.0)
// https://support.mozilla.org/en-US/questions/1157121
user_pref("network.captive-portal-service.enabled",		false);

// PREF: Disable (parts of?) "TopSites"
user_pref("browser.topsites.contile.enabled",				false);
user_pref("browser.newtabpage.activity-stream.feeds.topsites",		false);
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites",	false);

/******************************************************************************
 * SECTION: HTTP                                                              *
 ******************************************************************************/

// PREF: Disallow NTLMv1
// https://bugzilla.mozilla.org/show_bug.cgi?id=828183
user_pref("network.negotiate-auth.allow-insecure-ntlm-v1",	false);
// it is still allowed through HTTPS. uncomment the following to disable it completely.
user_pref("network.negotiate-auth.allow-insecure-ntlm-v1-https",		false);

// PREF: Enable CSP 1.1 script-nonce directive support
// https://bugzilla.mozilla.org/show_bug.cgi?id=855326
user_pref("security.csp.experimentalEnabled",			true);

// PREF: Enable Content Security Policy (CSP)
// https://developer.mozilla.org/en-US/docs/Web/Security/CSP/Introducing_Content_Security_Policy
// https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP
user_pref("security.csp.enable",				true);

// PREF: Enable Subresource Integrity
// https://developer.mozilla.org/en-US/docs/Web/Security/Subresource_Integrity
// https://wiki.mozilla.org/Security/Subresource_Integrity
user_pref("security.sri.enable",				true);

// PREF: DNT HTTP header (disabled)
// https://www.mozilla.org/en-US/firefox/dnt/
// https://en.wikipedia.org/wiki/Do_not_track_header
// https://dnt-dashboard.mozilla.org
// https://github.com/pyllyukko/user.js/issues/11
// NOTICE: Do No Track must be enabled manually
//user_pref("privacy.donottrackheader.enabled",		true);

// PREF: Send a referer header with the target URI as the source (disabled)
// https://bugzilla.mozilla.org/show_bug.cgi?id=822869
// https://github.com/pyllyukko/user.js/issues/227
// NOTICE-DISABLED: Spoofing referers breaks functionality on websites relying on authentic referer headers
// NOTICE-DISABLED: Spoofing referers breaks visualisation of 3rd-party sites on the Lightbeam addon
// NOTICE-DISABLED: Spoofing referers disables CSRF protection on some login pages not implementing origin-header/cookie+token based CSRF protection
// TODO: https://github.com/pyllyukko/user.js/issues/94, commented-out XOriginPolicy/XOriginTrimmingPolicy = 2 prefs
//user_pref("network.http.referer.spoofSource",			true);

// PREF: Don't send referer headers when following links across different domains
// https://github.com/pyllyukko/user.js/issues/227
// https://github.com/pyllyukko/user.js/issues/328
// https://feeding.cloud.geek.nz/posts/tweaking-referrer-for-privacy-in-firefox/
user_pref("network.http.referer.XOriginPolicy",		2);

// PREF: Accept Only 1st Party Cookies
// http://kb.mozillazine.org/Network.cookie.cookieBehavior#1
// NOTICE: Blocking 3rd-party cookies breaks a number of payment gateways
// CIS 2.5.1
user_pref("network.cookie.cookieBehavior",			1);

// PREF: Enable first-party isolation
// https://bugzilla.mozilla.org/show_bug.cgi?id=1299996
// https://bugzilla.mozilla.org/show_bug.cgi?id=1260931
// https://wiki.mozilla.org/Security/FirstPartyIsolation
// NOTICE: First-party isolation breaks Microsoft Teams
// NOTICE: First-party isolation causes HTTP basic auth to ask for credentials for every new tab (see #425)
user_pref("privacy.firstparty.isolate",				true);

// PREF: Make sure that third-party cookies (if enabled) never persist beyond the session.
// https://feeding.cloud.geek.nz/posts/tweaking-cookies-for-privacy-in-firefox/
// http://kb.mozillazine.org/Network.cookie.thirdparty.sessionOnly
// https://developer.mozilla.org/en-US/docs/Cookies_Preferences_in_Mozilla#network.cookie.thirdparty.sessionOnly
user_pref("network.cookie.thirdparty.sessionOnly",		true);

// PREF: Spoof User-agent (disabled)
//user_pref("general.useragent.override",				"Mozilla/5.0 (Windows NT 6.1; rv:45.0) Gecko/20100101 Firefox/45.0");
//user_pref("general.appname.override",				"Netscape");
//user_pref("general.appversion.override",			"5.0 (Windows)");
//user_pref("general.platform.override",				"Win32");
//user_pref("general.oscpu.override",				"Windows NT 6.1");

/*******************************************************************************
 * SECTION: Caching                                                            *
 ******************************************************************************/

// PREF: Permanently enable private browsing mode
// https://support.mozilla.org/en-US/kb/Private-Browsing
// https://wiki.mozilla.org/PrivateBrowsing
// NOTICE: You can not view or inspect cookies when in private browsing: https://bugzilla.mozilla.org/show_bug.cgi?id=823941
// NOTICE: When Javascript is enabled, Websites can detect use of Private Browsing mode
// NOTICE: Private browsing breaks Kerberos authentication
// NOTICE: Disables "Containers" functionality (see below)
// NOTICE: "Always use private browsing mode" (browser.privatebrowsing.autostart) disables the possibility to use password manager: https://support.mozilla.org/en-US/kb/usernames-and-passwords-are-not-saved#w_private-browsing
// user_pref("browser.privatebrowsing.autostart",			true);

// PREF: Do not download URLs for the offline cache
// http://kb.mozillazine.org/Browser.cache.offline.enable
// user_pref("browser.cache.offline.enable",			false);

// PREF: Clear history when Firefox closes
// https://support.mozilla.org/en-US/kb/Clear%20Recent%20History#w_how-do-i-make-firefox-clear-my-history-automatically
// NOTICE: Installing user.js will remove your browsing history, caches and local storage.
// NOTICE: Installing user.js **will remove your saved passwords** (https://github.com/pyllyukko/user.js/issues/27)
// NOTICE: Clearing open windows on Firefox exit causes 2 windows to open when Firefox starts https://bugzilla.mozilla.org/show_bug.cgi?id=1334945
// user_pref("privacy.sanitize.sanitizeOnShutdown",		true);
// user_pref("privacy.clearOnShutdown.cache",			true);
// user_pref("privacy.clearOnShutdown.cookies",			true);
// user_pref("privacy.clearOnShutdown.downloads",			true);
// user_pref("privacy.clearOnShutdown.formdata",			true);
// user_pref("privacy.clearOnShutdown.history",			true);
// user_pref("privacy.clearOnShutdown.offlineApps",		true);
// user_pref("privacy.clearOnShutdown.sessions",			true);
// user_pref("privacy.clearOnShutdown.openWindows",		true);

// PREF: Set time range to "Everything" as default in "Clear Recent History"
// user_pref("privacy.sanitize.timeSpan",				0);

// PREF: Clear everything but "Site Preferences" in "Clear Recent History"
user_pref("privacy.cpd.offlineApps",				true);
user_pref("privacy.cpd.cache",					true);
user_pref("privacy.cpd.cookies",				true);
user_pref("privacy.cpd.downloads",				true);
user_pref("privacy.cpd.formdata",				true);
user_pref("privacy.cpd.history",				true);
user_pref("privacy.cpd.sessions",				true);

// PREF: Don't remember browsing history
// user_pref("places.history.enabled",				false);

// PREF: Disable disk cache
// http://kb.mozillazine.org/Browser.cache.disk.enable
// user_pref("browser.cache.disk.enable",				false);

// PREF: Disable memory cache (disabled)
// http://kb.mozillazine.org/Browser.cache.memory.enable
//user_pref("browser.cache.memory.enable",		false);

// PREF: Disable Caching of SSL Pages
// CIS Version 1.2.0 October 21st, 2011 2.5.8
// http://kb.mozillazine.org/Browser.cache.disk_cache_ssl
// user_pref("browser.cache.disk_cache_ssl",			false);

// PREF: Disable download history
// CIS Version 1.2.0 October 21st, 2011 2.5.5
// user_pref("browser.download.manager.retention",			0);

// PREF: Disable password manager (use an external password manager!)
// CIS Version 1.2.0 October 21st, 2011 2.5.2
user_pref("signon.rememberSignons",				false);

// PREF: Disable form autofill, don't save information entered in web page forms and the Search Bar
// user_pref("browser.formfill.enable",				false);

// PREF: Cookies expires at the end of the session (when the browser closes)
// http://kb.mozillazine.org/Network.cookie.lifetimePolicy#2
// user_pref("network.cookie.lifetimePolicy",			1);
user_pref("network.cookie.lifetimePolicy",			1); // User is prompted to specify the cookie lifetime

// PREF: Require manual intervention to autofill known username/passwords sign-in forms
// http://kb.mozillazine.org/Signon.autofillForms
// https://www.torproject.org/projects/torbrowser/design/#identifier-linkability
user_pref("signon.autofillForms",				false);

// PREF: Disable formless login capture
// https://bugzilla.mozilla.org/show_bug.cgi?id=1166947
user_pref("signon.formlessCapture.enabled",			false);

// PREF: When username/password autofill is enabled, still disable it on non-HTTPS sites
// https://hg.mozilla.org/integration/mozilla-inbound/rev/f0d146fe7317
user_pref("signon.autofillForms.http",				false);

// PREF: Show in-content login form warning UI for insecure login fields
// https://hg.mozilla.org/integration/mozilla-inbound/rev/f0d146fe7317
user_pref("security.insecure_field_warning.contextual.enabled", true);

// PREF: Disable the password manager for pages with autocomplete=off (disabled)
// https://bugzilla.mozilla.org/show_bug.cgi?id=956906
// OWASP ASVS V9.1
// Does not prevent any kind of auto-completion (see browser.formfill.enable, signon.autofillForms)
//user_pref("signon.storeWhenAutocompleteOff",			false);

// PREF: Delete Search and Form History
// CIS Version 1.2.0 October 21st, 2011 2.5.6
// user_pref("browser.formfill.expire_days",			0);

// PREF: Clear SSL Form Session Data
// http://kb.mozillazine.org/Browser.sessionstore.privacy_level#2
// Store extra session data for unencrypted (non-HTTPS) sites only.
// CIS Version 1.2.0 October 21st, 2011 2.5.7
// NOTE: CIS says 1, we use 2
// user_pref("browser.sessionstore.privacy_level",			2);

// PREF: Delete temporary files on exit
// https://bugzilla.mozilla.org/show_bug.cgi?id=238789
user_pref("browser.helperApps.deleteTempFileOnExit",		true);

// PREF: Do not create screenshots of visited pages (relates to the "new tab page" feature)
// https://support.mozilla.org/en-US/questions/973320
// https://developer.mozilla.org/en-US/docs/Mozilla/Preferences/Preference_reference/browser.pagethumbnails.capturing_disabled
user_pref("browser.pagethumbnails.capturing_disabled",		true);

// PREF: Don't fetch and permanently store favicons for Windows .URL shortcuts created by drag and drop
// NOTICE: .URL shortcut files will be created with a generic icon
// Favicons are stored as .ico files in $profile_dir\shortcutCache
user_pref("browser.shell.shortcutFavicons",					false);

// PREF: Disable bookmarks backups (default: 15)
// http://kb.mozillazine.org/Browser.bookmarks.max_backups
user_pref("browser.bookmarks.max_backups", 0);

// PREF: Export bookmarks to HTML automatically when closing Firefox (disabled)
// https://support.mozilla.org/en-US/questions/1176242
//user_pref("browser.bookmarks.autoExportHTML", 				true);
//user_pref("browser.bookmarks.file",	'/path/to/bookmarks-export.html');

// PREF: Disable downloading of favicons in response to favicon fingerprinting techniques
// https://github.com/jonasstrehle/supercookie
// http://kb.mozillazine.org/Browser.chrome.site_icons
// https://blog.mozilla.org/security/2021/01/26/supercookie-protections/
// user_pref("browser.chrome.site_icons",				false);

/*******************************************************************************
 * SECTION: UI related                                                         *
 *******************************************************************************/

// PREF: Enable insecure password warnings (login forms in non-HTTPS pages)
// https://blog.mozilla.org/tanvi/2016/01/28/no-more-passwords-over-http-please/
// https://bugzilla.mozilla.org/show_bug.cgi?id=1319119
// https://bugzilla.mozilla.org/show_bug.cgi?id=1217156
user_pref("security.insecure_password.ui.enabled",		true);

// PREF: Disable right-click menu manipulation via JavaScript (disabled)
//user_pref("dom.event.contextmenu.enabled",		false);

// PREF: Disable "Are you sure you want to leave this page?" popups on page close
// https://support.mozilla.org/en-US/questions/1043508
// NOTICE: disabling "beforeunload" events may lead to losing data entered in web forms
// Does not prevent JS leaks of the page close event.
// https://developer.mozilla.org/en-US/docs/Web/Events/beforeunload
//user_pref("dom.disable_beforeunload",    true);

// PREF: Disable Downloading on Desktop
// CIS 2.3.2
// user_pref("browser.download.folderList",			2);

// PREF: Always ask the user where to download
// https://developer.mozilla.org/en/Download_Manager_preferences (obsolete)
// user_pref("browser.download.useDownloadDir",			false);

// PREF: Disable the "new tab page" feature and show a blank tab instead
// https://wiki.mozilla.org/Privacy/Reviews/New_Tab
// https://support.mozilla.org/en-US/kb/new-tab-page-show-hide-and-customize-top-sites#w_how-do-i-turn-the-new-tab-page-off
user_pref("browser.newtabpage.enabled",				false);
user_pref("browser.newtab.url",					"about:blank");

// PREF: Disable Snippets
// https://wiki.mozilla.org/Firefox/Projects/Firefox_Start/Snippet_Service
// https://support.mozilla.org/en-US/kb/snippets-firefox-faq
user_pref("browser.newtabpage.activity-stream.feeds.snippets",	false);

// PREF: Disable Activity Stream
// https://wiki.mozilla.org/Firefox/Activity_Stream
user_pref("browser.newtabpage.activity-stream.enabled",		false);

// PREF: Disable new tab tile ads & preload
// http://www.thewindowsclub.com/disable-remove-ad-tiles-from-firefox
// http://forums.mozillazine.org/viewtopic.php?p=13876331#p13876331
// https://wiki.mozilla.org/Tiles/Technical_Documentation#Ping
// https://gecko.readthedocs.org/en/latest/browser/browser/DirectoryLinksProvider.html#browser-newtabpage-directory-source
// https://gecko.readthedocs.org/en/latest/browser/browser/DirectoryLinksProvider.html#browser-newtabpage-directory-ping
// TODO: deprecated? not in DXR, some dead links
user_pref("browser.newtabpage.enhanced",			false);
user_pref("browser.newtab.preload",				false);
user_pref("browser.newtabpage.directory.ping",			"");
user_pref("browser.newtabpage.directory.source",		"data:text/plain,{}");

// PREF: Force Punycode for Internationalized Domain Names
// http://kb.mozillazine.org/Network.IDN_show_punycode
// https://www.xudongz.com/blog/2017/idn-phishing/
// https://wiki.mozilla.org/IDN_Display_Algorithm
// https://en.wikipedia.org/wiki/IDN_homograph_attack
// https://www.mozilla.org/en-US/security/advisories/mfsa2017-02/
// CIS Mozilla Firefox 24 ESR v1.0.0 - 3.6
user_pref("network.IDN_show_punycode",				true);

// PREF: Disable inline autocomplete in URL bar
// http://kb.mozillazine.org/Inline_autocomplete
// user_pref("browser.urlbar.autoFill",				false);
// user_pref("browser.urlbar.autoFill.typed",			false);

// PREF: Disable CSS :visited selectors
// https://blog.mozilla.org/security/2010/03/31/plugging-the-css-history-leak/
// https://dbaron.org/mozilla/visited-privacy
user_pref("layout.css.visited_links_enabled",			false);

// PREF: Disable URL bar autocomplete and history/bookmarks suggestions dropdown
// http://kb.mozillazine.org/Disabling_autocomplete_-_Firefox#Firefox_3.5
// user_pref("browser.urlbar.autocomplete.enabled",		false);

// PREF: Do not check if Firefox is the default browser
user_pref("browser.shell.checkDefaultBrowser",			false);

// PREF: When password manager is enabled, lock the password storage periodically
// CIS Version 1.2.0 October 21st, 2011 2.5.3 Disable Prompting for Credential Storage
user_pref("security.ask_for_password",				2);

// PREF: Lock the password storage every 1 minutes (default: 30)
user_pref("security.password_lifetime",				1);

// PREF: Display a notification bar when websites offer data for offline use
// http://kb.mozillazine.org/Browser.offline-apps.notify
user_pref("browser.offline-apps.notify",			true);

/******************************************************************************
 * SECTION: Cryptography                                                      *
 ******************************************************************************/

// PREF: Enable HTTPS-Only Mode
// https://blog.mozilla.org/security/2020/11/17/firefox-83-introduces-https-only-mode/
// https://www.feistyduck.com/bulletproof-tls-newsletter/issue_71_firefox_introduces_https_only_mode
// user_pref("dom.security.https_only_mode",			true);

// PREF: Enable HSTS preload list (pre-set HSTS sites list provided by Mozilla)
// https://blog.mozilla.org/security/2012/11/01/preloading-hsts/
// https://wiki.mozilla.org/Privacy/Features/HSTS_Preload_List
// https://en.wikipedia.org/wiki/HTTP_Strict_Transport_Security
user_pref("network.stricttransportsecurity.preloadlist",	true);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// PREF: Enable Online Certificate Status Protocol
// https://en.wikipedia.org/wiki/Online_Certificate_Status_Protocol
// https://www.imperialviolet.org/2014/04/19/revchecking.html
// https://www.maikel.pro/blog/current-state-certificate-revocation-crls-ocsp/
// https://wiki.mozilla.org/CA:RevocationPlan
// https://wiki.mozilla.org/CA:ImprovingRevocation
// https://wiki.mozilla.org/CA:OCSP-HardFail
// https://news.netcraft.com/archives/2014/04/24/certificate-revocation-why-browsers-remain-affected-by-heartbleed.html
// https://news.netcraft.com/archives/2013/04/16/certificate-revocation-and-the-performance-of-ocsp.html
// NOTICE: OCSP leaks your IP and domains you visit to the CA when OCSP Stapling is not available on visited host
// NOTICE: OCSP is vulnerable to replay attacks when nonce is not configured on the OCSP responder
// NOTICE: OCSP adds latency (performance)
// NOTICE: Short-lived certificates are not checked for revocation (security.pki.cert_short_lifetime_in_days, default:10)
// CIS Version 1.2.0 October 21st, 2011 2.2.4
user_pref("security.OCSP.enabled",				1);

// PREF: Enable OCSP Stapling support
// https://en.wikipedia.org/wiki/OCSP_stapling
// https://blog.mozilla.org/security/2013/07/29/ocsp-stapling-in-firefox/
// https://www.digitalocean.com/community/tutorials/how-to-configure-ocsp-stapling-on-apache-and-nginx
user_pref("security.ssl.enable_ocsp_stapling",			true);

// PREF: Enable OCSP Must-Staple support (Firefox >= 45)
// https://blog.mozilla.org/security/2015/11/23/improving-revocation-ocsp-must-staple-and-short-lived-certificates/
// https://www.entrust.com/ocsp-must-staple/
// https://github.com/schomery/privacy-settings/issues/40
// NOTICE: Firefox falls back on plain OCSP when must-staple is not configured on the host certificate
user_pref("security.ssl.enable_ocsp_must_staple",		true);

// PREF: Require a valid OCSP response for OCSP enabled certificates
// https://groups.google.com/forum/#!topic/mozilla.dev.security/n1G-N2-HTVA
// Disabling this will make OCSP bypassable by MitM attacks suppressing OCSP responses
// NOTICE: `security.OCSP.require` will make the connection fail when the OCSP responder is unavailable
// NOTICE: `security.OCSP.require` is known to break browsing on some [captive portals](https://en.wikipedia.org/wiki/Captive_portal)
user_pref("security.OCSP.require",				true);

// PREF: Disable TLS Session Tickets
// https://www.blackhat.com/us-13/briefings.html#NextGen
// https://media.blackhat.com/us-13/US-13-Daigniere-TLS-Secrets-Slides.pdf
// https://media.blackhat.com/us-13/US-13-Daigniere-TLS-Secrets-WP.pdf
// https://bugzilla.mozilla.org/show_bug.cgi?id=917049
// https://bugzilla.mozilla.org/show_bug.cgi?id=967977
user_pref("security.ssl.disable_session_identifiers",		true);

// PREF: Only allow TLS 1.[2-3]
// http://kb.mozillazine.org/Security.tls.version.*
// 1 = TLS 1.0 is the minimum required / maximum supported encryption protocol. (This is the current default for the maximum supported version.)
// 2 = TLS 1.1 is the minimum required / maximum supported encryption protocol.
// 3 = TLS 1.2 is the minimum required / maximum supported encryption protocol.
// 4 = TLS 1.3 is the minimum required / maximum supported encryption protocol.
// user_pref("security.tls.version.min",				3);
// user_pref("security.tls.version.max",				4);

// PREF: Disable insecure TLS version fallback
// https://bugzilla.mozilla.org/show_bug.cgi?id=1084025
// https://github.com/pyllyukko/user.js/pull/206#issuecomment-280229645
user_pref("security.tls.version.fallback-limit",		4);

// PREF: Enforce Public Key Pinning
// https://en.wikipedia.org/wiki/HTTP_Public_Key_Pinning
// https://wiki.mozilla.org/SecurityEngineering/Public_Key_Pinning
// "2. Strict. Pinning is always enforced."
user_pref("security.cert_pinning.enforcement_level",		2);

// PREF: Disallow SHA-1
// https://bugzilla.mozilla.org/show_bug.cgi?id=1302140
// https://shattered.io/
user_pref("security.pki.sha1_enforcement_level",		1);

// PREF: Warn the user when server doesn't support RFC 5746 ("safe" renegotiation)
// https://wiki.mozilla.org/Security:Renegotiation#security.ssl.treat_unsafe_negotiation_as_broken
// https://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-3555
user_pref("security.ssl.treat_unsafe_negotiation_as_broken",	true);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// PREF: Disallow connection to servers not supporting safe renegotiation (disabled)
// https://wiki.mozilla.org/Security:Renegotiation#security.ssl.require_safe_negotiation
// https://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2009-3555
// TODO: `security.ssl.require_safe_negotiation` is more secure but makes browsing next to impossible (2012-2014-... - `ssl_error_unsafe_negotiation` errors), so is left disabled
user_pref("security.ssl.require_safe_negotiation",		true);

// PREF: Disable automatic reporting of TLS connection errors
// https://support.mozilla.org/en-US/kb/certificate-pinning-reports
// we could also disable security.ssl.errorReporting.enabled, but I think it's
// good to leave the option to report potentially malicious sites if the user
// chooses to do so.
// you can test this at https://pinningtest.appspot.com/
user_pref("security.ssl.errorReporting.automatic",		false);

// PREF: Pre-populate the current URL but do not pre-fetch the certificate in the "Add Security Exception" dialog
// http://kb.mozillazine.org/Browser.ssl_override_behavior
// https://github.com/pyllyukko/user.js/issues/210
user_pref("browser.ssl_override_behavior",			1);

// PREF: Encrypted SNI (when TRR is enabled)
// https://www.cloudflare.com/ssl/encrypted-sni/
// https://wiki.mozilla.org/Trusted_Recursive_Resolver#ESNI
// https://en.wikipedia.org/wiki/Server_Name_Indication#Security_implications_(ESNI)
user_pref("network.security.esni.enabled",			true);

/******************************************************************************
 * SECTION: Cipher suites                                                     *
 ******************************************************************************/

// PREF: Disable null ciphers
user_pref("security.ssl3.rsa_null_sha",				false);
user_pref("security.ssl3.rsa_null_md5",				false);
user_pref("security.ssl3.ecdhe_rsa_null_sha",			false);
user_pref("security.ssl3.ecdhe_ecdsa_null_sha",			false);
user_pref("security.ssl3.ecdh_rsa_null_sha",			false);
user_pref("security.ssl3.ecdh_ecdsa_null_sha",			false);

// PREF: Disable SEED cipher
// https://en.wikipedia.org/wiki/SEED
user_pref("security.ssl3.rsa_seed_sha",				false);

// PREF: Disable 40/56/128-bit ciphers
// 40-bit ciphers
user_pref("security.ssl3.rsa_rc4_40_md5",			false);
user_pref("security.ssl3.rsa_rc2_40_md5",			false);
// 56-bit ciphers
user_pref("security.ssl3.rsa_1024_rc4_56_sha",			false);
// 128-bit ciphers
user_pref("security.ssl3.rsa_camellia_128_sha",			false);
user_pref("security.ssl3.ecdhe_rsa_aes_128_sha",		false);
user_pref("security.ssl3.ecdhe_ecdsa_aes_128_sha",		false);
user_pref("security.ssl3.ecdh_rsa_aes_128_sha",			false);
user_pref("security.ssl3.ecdh_ecdsa_aes_128_sha",		false);
user_pref("security.ssl3.dhe_rsa_camellia_128_sha",		false);
user_pref("security.ssl3.dhe_rsa_aes_128_sha",			false);

// PREF: Disable RC4
// https://developer.mozilla.org/en-US/Firefox/Releases/38#Security
// https://bugzilla.mozilla.org/show_bug.cgi?id=1138882
// https://rc4.io/
// https://web.nvd.nist.gov/view/vuln/detail?vulnId=CVE-2013-2566
user_pref("security.ssl3.ecdh_ecdsa_rc4_128_sha",		false);
user_pref("security.ssl3.ecdh_rsa_rc4_128_sha",			false);
user_pref("security.ssl3.ecdhe_ecdsa_rc4_128_sha",		false);
user_pref("security.ssl3.ecdhe_rsa_rc4_128_sha",		false);
user_pref("security.ssl3.rsa_rc4_128_md5",			false);
user_pref("security.ssl3.rsa_rc4_128_sha",			false);
user_pref("security.tls.unrestricted_rc4_fallback",		false);

// PREF: Disable 3DES (effective key size is < 128)
// https://en.wikipedia.org/wiki/3des#Security
// http://en.citizendium.org/wiki/Meet-in-the-middle_attack
// http://www-archive.mozilla.org/projects/security/pki/nss/ssl/fips-ssl-ciphersuites.html
user_pref("security.ssl3.dhe_dss_des_ede3_sha",			false);
user_pref("security.ssl3.dhe_rsa_des_ede3_sha",			false);
user_pref("security.ssl3.ecdh_ecdsa_des_ede3_sha",		false);
user_pref("security.ssl3.ecdh_rsa_des_ede3_sha",		false);
user_pref("security.ssl3.ecdhe_ecdsa_des_ede3_sha",		false);
user_pref("security.ssl3.ecdhe_rsa_des_ede3_sha",		false);
user_pref("security.ssl3.rsa_des_ede3_sha",			false);
user_pref("security.ssl3.rsa_fips_des_ede3_sha",		false);

// PREF: Disable ciphers with ECDH (non-ephemeral)
user_pref("security.ssl3.ecdh_rsa_aes_256_sha",			false);
user_pref("security.ssl3.ecdh_ecdsa_aes_256_sha",		false);

// PREF: Disable 256 bits ciphers without PFS
user_pref("security.ssl3.rsa_camellia_256_sha",			false);

// PREF: Disable ciphers susceptible to the logjam attack
// https://weakdh.org/
user_pref("security.ssl3.dhe_rsa_camellia_256_sha",		false);
user_pref("security.ssl3.dhe_rsa_aes_256_sha",			false);

// PREF: Disable ciphers with DSA (max 1024 bits)
user_pref("security.ssl3.dhe_dss_aes_128_sha",			false);
user_pref("security.ssl3.dhe_dss_aes_256_sha",			false);
user_pref("security.ssl3.dhe_dss_camellia_128_sha",		false);
user_pref("security.ssl3.dhe_dss_camellia_256_sha",		false);

// PREF: Ciphers with CBC & SHA-1 (disabled)
user_pref("security.ssl3.rsa_aes_256_sha",			false); // 0x35
user_pref("security.ssl3.rsa_aes_128_sha",			false); // 0x2f
user_pref("security.ssl3.ecdhe_rsa_aes_256_sha",		false); // 0xc014
user_pref("security.ssl3.ecdhe_ecdsa_aes_256_sha",		false); // 0xc00a



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////







