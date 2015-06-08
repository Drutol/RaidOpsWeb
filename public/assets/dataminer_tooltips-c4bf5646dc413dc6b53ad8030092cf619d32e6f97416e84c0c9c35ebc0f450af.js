// Main tooltip function
function wildstar_datminer_replace_links()
{
	


    "undefined" != typeof Prototype && jQuery.noConflict();
    var i = 0;
    
    var wildstar_datminer_config = window.wildstar_datminer_config;
    if(typeof wildstar_datminer_config == 'undefined')
    {
        var wildstar_datminer_config = {};
    }
    i
    if(typeof wildstar_datminer_config.done != 'undefined') {return}
    if(typeof wildstar_datminer_config.selector == 'undefined') { wildstar_datminer_config.selector = "a";}
    if(typeof wildstar_datminer_config.language == 'undefined') { wildstar_datminer_config.language = 1;}
    if(typeof wildstar_datminer_config.name_replace == 'undefined') { wildstar_datminer_config.name_replace = true;}
    if(typeof wildstar_datminer_config.color_show == 'undefined') { wildstar_datminer_config.color_show = true;}
    if(typeof wildstar_datminer_config.icon_replace == 'undefined') { wildstar_datminer_config.icon_replace = true;}
    
	wildstar_datminer_config.done = true

    jQuery(wildstar_datminer_config.selector).each(function (index, value) 
    {
        // Set vars
        var url  = jQuery(this).attr("href");
        var host = null;
        if (void 0 != url && url.indexOf('/') > -1)
        {  
            url = url.split('/');
            var host = url[2];
        }
       //console.log(url);

        // If host not undefined and valid address is in hrefs
        if (void 0 != host && host.indexOf('wildstar.datminer.com') != -1) 
        {
            var type, id, name;
            if(url.length > 6)
            {   
                //language prefix present
                if (url[4]) { type = url[4]; }
                if (url[5]) { id= url[5]; }
            }else
            {
                if (url[3]) { type = url[3]; }
                if (url[4]) { id= url[4]; }
            }

            var element = jQuery(this);
            void 0 == id || !jQuery.isNumeric(id) || (jQuery.ajax({
                url: "http://tooltipz.com/modules/tooltip/wildtips.php",
                data: 
                {
                    language: wildstar_datminer_config.language,
                    type: type,
                    id: id,
                },
                
                cache: true,
                type: 'GET',
                success: function (data) 
                {
                    i++;
                    //console.log(data);
                    try{
                        data = JSON.parse(data);
                    }catch(error)
                    {
                        return;
                    }
                    //console.log(data);

                    if (void 0 != data)
                    {
                        element.attr("title", "");
                        element.attr("data-tooltip", data.html);
                        element.addClass("wildstar-datminer-link"+i);
                        jQuery('.wildstar-datminer-link'+i).attach_tooltip();
                        
                        if (wildstar_datminer_config.name_replace) 
                        { 
                            element.html(data.name);
                        }
                        if (wildstar_datminer_config.color_show)  
                        { 
                            element.css({ color: "#"+data.color });
                        }
                        if (wildstar_datminer_config.icon_replace)   
                        { 
                            element.html('<img src="'+ data.icon + '" style="margin:0 5px -5px 0;width:20px;height:20px;vertical-align: initial;" />' + element.html());
                        }
                    }
                     //JQuery('.wildstar-datminer-link').attach_tooltip();
                },
            }));
        }
    });
   
}


function wildstar_datminer_add_script(e, t) {
  var n = document.createElement("script");
  n.src = e;
  var r = document.getElementsByTagName("head")[0], i = !1;
  void 0 == r && (r = document.getElementsByTagName("body")[0]);
  n.onload = n.onreadystatechange = function() {
    i || this.readyState && "loaded" != this.readyState && "complete" != this.readyState || (i = !0, t(), n.onload = n.onreadystatechange = null, r.removeChild(n));
  };
  r.appendChild(n);
}
function wildstar_datminer_load() {
  "undefined" != typeof Prototype && jQuery.noConflict();
    function enable_tooltip(element)
    {
        var tt_witdth;
        var tt_height;
        var tt_id = "wildstar-datminer-tooltip";

        jQuery(element).unbind("mouseenter mouseleave mousemove");
        jQuery(element).hover(function(event) 
        {
    
            // Hide any current tooltips
            if(jQuery("#"+tt_id).length>0)
            {
                jQuery("#"+tt_id).html('').css({ 'visibility': 'false' });
            }
            else
                jQuery("body").append("<div id='"+tt_id+"' style='position: absolute; z-index: 100; visibility: false;'></div>");

            // Get mouse position
            var x = (event.pageX + 15);
            var y = (event.pageY + 15);

            // Fill tooltip
            jQuery("#"+tt_id).html(jQuery(this).data("tooltip"));

            // tooltip width and height
            tt_witdth 	= jQuery("#"+tt_id).width();
            tt_height 	= jQuery("#"+tt_id).height();

            // Show Tooltip
            jQuery("#"+tt_id).css({ 'left': x + 'px','top': y + 'px', 'visibility': 'visible' }).show();

            // Mouse move tracking
            jQuery(this).mousemove(function(event) 
            {
                // Get x/y position and page positions
                var x = event.pageX + 12;
                var y = event.pageY + 12;
                var s = jQuery("#"+tt_id).outerWidth(true);
                var o = jQuery("#"+tt_id).outerHeight(true);

                // Positions based on window boundaries
                if (x + s > jQuery(window).scrollLeft() + jQuery(window).width()) x = event.pageX - s;
                if (jQuery(window).height() + jQuery(window).scrollTop() < y + o) y = event.pageY - o;
                if(y < jQuery(window).scrollTop()) y = jQuery(window).scrollTop();

                // Move!
                jQuery("#"+tt_id).css({ 'left': x + 'px','top': y + 'px' });			
            });
        }, 
        function(event) 
        {
            // Hide
            jQuery("#"+tt_id).html('').css({ 'visibility': 'false' }).removeClass();

        });
    }
    (function(e){e.fn.attach_tooltip=function(t){var t=e(this).selector;enable_tooltip(t)}})(jQuery);
    wildstar_datminer_replace_links();
}

function wildstar_datminer_jquery_init() {
  "undefined" == typeof jQuery ? wildstar_datminer_add_script("//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js", wildstar_datminer_load) : wildstar_datminer_load();
}
wildstar_datminer_init = function() {
  var e = document.createElement("link");
  e.setAttribute("rel", "stylesheet");
  e.setAttribute("href", "http://tooltipz.com/modules/tooltip/tooltip.css");
  e.setAttribute("type", "text/css");
  document.getElementsByTagName("head")[0].appendChild(e);
  var e = setInterval(function() {
    "complete" === document.readyState && (clearInterval(e), wildstar_datminer_jquery_init());
  }, 10);
};
document.addEventListener("DOMContentLoaded", function() {
  wildstar_datminer_init();
});

