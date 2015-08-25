function JHassignTooltips() {
    var e = {
        items: [],
        spells: [],
        schematics: []
    };
    JHJQ("a").each(function(t, n) {
        if (n.hostname.toLowerCase() == JH_HOST) {
            if (n.pathname && n.pathname.indexOf("/items/") == 0 && n.pathname != "/items/") {
                JHJQ(n).attr("data-jh-tt", "1");
                JHJQ(n).addClass("jh-tt-item");
                e.items[e.items.length] = n.pathname.substr(n.pathname.lastIndexOf("/") + 1)
            }
            if (n.pathname && n.pathname.indexOf("/spells/") == 0 && n.pathname != "/spells/") {
                JHJQ(n).attr("data-jh-tt", "1");
                JHJQ(n).addClass("jh-tt-spell");
                e.spells[e.spells.length] = n.pathname.substr(n.pathname.lastIndexOf("/") + 1)
            }
            if (n.pathname && n.pathname.indexOf("/schematics/") == 0 && n.pathname != "/schematics/") {
                JHJQ(n).attr("data-jh-tt", "1");
                JHJQ(n).addClass("jh-tt-sch");
                e.schematics[e.schematics.length] = n.pathname.substr(n.pathname.lastIndexOf("/") + 1)
            }
        }
    });
    if (JH_options && JH_options.preload) {
        if (e.items.length) {
            JHJQ.ajax("http://" + JH_HOST + "/items/preload", {
                type: "POST",
                data: {
                    items: e.items
                },
                complete: function(e, t) {},
                error: function(e, t, n) {},
                success: function(e, t, n) {
                    var r = JHJQ.parseJSON(e);
                    JHJQ("a[data-jh-tt]").each(function(e, t) {
                        if (JHJQ(t).hasClass("jh-tt-item")) {
                            var n = t.pathname.substr(t.pathname.lastIndexOf("/") + 1);
                            if (r[n]) {
                                if (JH_options.colors) {
                                    if (JH_options.whitebg && parseInt(r[n]["q"]) == 2) {
                                        JHJQ(t).addClass("jhitemquality" + r[n]["q"] + "b")
                                    } else {
                                        JHJQ(t).addClass("jhitemquality" + r[n]["q"])
                                    }
                                }
                                if (JH_options.names) {
                                    if (r[n]["n"] && r[n]["n"] != "") {
                                        if(JHJQ(t).html().indexOf("img") == -1)
                                        {
                                        JHJQ(t).text(r[n]["n"])
                                        }
                                    }
                                }
                            }
                        }
                    })
                }
            })
        }
        if (e.spells.length) {
            JHJQ.ajax("http://" + JH_HOST + "/spells/preload", {
                type: "POST",
                data: {
                    spells: e.spells
                },
                complete: function(e, t) {},
                error: function(e, t, n) {},
                success: function(e, t, n) {
                    var r = JHJQ.parseJSON(e);
                    JHJQ("a[data-jh-tt]").each(function(e, t) {
                        if (JHJQ(t).hasClass("jh-tt-spell")) {
                            var n = t.pathname.substr(t.pathname.lastIndexOf("/") + 1);
                            if (r[n]) {
                                if (JH_options.names) {
                                    if (r[n]["n"] && r[n]["n"] != "") {
                                        JHJQ(t).text(r[n]["n"])
                                    }
                                }
                            }
                        }
                    })
                }
            })
        }
        if (e.schematics.length) {
            JHJQ.ajax("http://" + JH_HOST + "/schematics/preload", {
                type: "POST",
                data: {
                    schematics: e.schematics
                },
                complete: function(e, t) {},
                error: function(e, t, n) {},
                success: function(e, t, n) {
                    var r = JHJQ.parseJSON(e);
                    JHJQ("a[data-jh-tt]").each(function(e, t) {
                        if (JHJQ(t).hasClass("jh-tt-sch")) {
                            var n = t.pathname.substr(t.pathname.lastIndexOf("/") + 1);
                            if (r[n]) {
                                if (JH_options.names) {
                                    if (r[n]["n"] && r[n]["n"] != "") {
                                        JHJQ(t).text(r[n]["n"])
                                    }
                                }
                            }
                        }
                    })
                }
            })
        }
    }
    JHJQ("a[data-jh-tt]").mouseout(function(e) {
        window._jhttl = null
    });
    JHJQ(document).tooltip({
        position: {
            my: "left bottom",
            at: "left top-10",
            collision: "flipfit"
        },
        items: "a[data-jh-tt]",
        close: function(e, t) {
            JHJQ(".ui-tooltip").hide();
            window._jhttl = null
        },
        open: function(e, t) {
            if (JH_options) {
                if (JH_options.zIndex) {
                    t.tooltip.css("z-index", JH_options.zIndex)
                } else if (JH_options.zindex) {
                    t.tooltip.css("z-index", JH_options.zindex)
                }
            }
        },
        content: function(e) {
            window._jhttl = this;
            var t = this;
            var n = this.pathname;
            if (JH_tooltip_cache[n]) {
                if (JH_options) {
                    var r = JHJQ(JH_tooltip_cache[n]);
                    if (JH_options.colors) {
                        var i = r.attr("data-q");
                        if (JH_options.whitebg && parseInt(i) == 2) {
                            JHJQ(t).addClass("jhitemquality" + i + "b")
                        } else {
                            JHJQ(t).addClass("jhitemquality" + i)
                        }
                    }
                }
                return JH_tooltip_cache[n]
            } else {
                JHJQ.ajax("http://" + JH_HOST + n + "?i", {
                    type: "GET",
                    complete: function(e, t) {},
                    error: function(t, n, r) {
                        e('<div class="jhttsp fleft" data-q="none"><div class="jhttt" style="color:#fff">Unable to load tooltip at this moment</div></div>')
                    },
                    success: function(r, i, s) {
                        JH_tooltip_cache[n] = r;
                        if (t == window._jhttl) {
                            if (JH_options) {
                                var o = JHJQ(r);
                                if (JH_options.colors) {
                                    var u = o.attr("data-q");
                                    if (JH_options.whitebg && parseInt(u) == 2) {
                                        JHJQ(t).addClass("jhitemquality" + u + "b")
                                    } else {
                                        JHJQ(t).addClass("jhitemquality" + u)
                                    }
                                }
                            }
                            e(r)
                        }
                    }
                })
            }
        }
    })
}

function JHinitialize() {
    JHJQ(document).ready(function() {
        JHJQ("head").append(JHJQ('<link rel="stylesheet" type="text/css" />').attr("href", "http://" + JH_HOST + "/api/tooltips.css"));
        JHassignTooltips();
        JHJQ(".ui-tooltip").mouseover(function() {
            JHJQ(".ui-tooltip").hide()
        }).remove()
    })
}
var JH_tooltip_cache = [];
var JH_HOST = "www.jabbithole.com";
var JHOldJQuery = window.jQuery;
var JHOldCashSign = window.$;
var imported = document.createElement("script");
imported.src = "//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js";
imported.onload = function() {
    var e = document.createElement("script");
    e.src = "http://" + JH_HOST + "/api/jquery-ui-min.js";
    e.onload = function() {
        window.JHJQ = window.jQuery;
        JHinitialize();

        window.jQuery = JHOldJQuery;
        window.$ = JHOldCashSign
    };
    document.head.appendChild(e)
};
document.head.appendChild(imported)
