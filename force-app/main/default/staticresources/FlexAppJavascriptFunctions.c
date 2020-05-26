    function resizeFlexAppDiv(minHeight) {

        var salesforceHeaderSize = 130;
        var browserWindowHeight;

        if( typeof( window.innerWidth ) == 'number' ) {
            //Non-IE
            browserWindowHeight = window.innerHeight;
        } else if( document.documentElement &&
                 ( document.documentElement.clientWidth ||
                   document.documentElement.clientHeight ) ) {
            //IE 6+ in 'standards compliant mode'
            browserWindowHeight = document.documentElement.clientHeight;
        } else if( document.body &&
                 ( document.body.clientWidth ||
                   document.body.clientHeight ) ) {
            //IE 4 compatible
            browserWindowHeight = document.body.clientHeight;
        }

        var windowHeight=(browserWindowHeight - salesforceHeaderSize);
        //alert("windowHeight = " + windowHeight);
        if (windowHeight < minHeight) {windowHeight = minHeight};
        document.getElementById("flexAppDiv").style.height = windowHeight + "px";
    }

    // a JavaScript function in the container HTML page
    function redirectToURL(url) {
        window.location = url;
    }

    function openURLinNewWindow(url) {
        window.open(url,url,"width=500,height=400,toolbar=yes,location=yes,directories=yes,status=yes,menubar=yes,scrollbars=yes,copyhistory=yes,resizable=yes");
    }

    function hookEvent(element, eventName, callback) {
        if (typeof(element) == "string")
            element = document.getElementById(element);
        if (element == null)
            return;
        if (element.addEventListener) {
            if (eventName == 'mousewheel')
                element.addEventListener('DOMMouseScroll', callback, false);
            element.addEventListener(eventName, callback, false);
        } else if (element.attachEvent())
            element.attachEvent("on" + eventName, callback);
    }

    function unhookEvent(element, eventName, callback) {
        if (typeof(element) == "string")
            element = document.getElementById(element);
        if (element == null)
            return;
        if (element.removeEventListener) {
            if (eventName == 'mousewheel')
                element.removeEventListener('DOMMouseScroll', callback, false);
            element.removeEventListener(eventName, callback, false);
        } else if (element.detachEvent)
            element.detachEvent("on" + eventName, callback);
    }

    function cancelEvent(e) {
        e = e ? e : window.event;
        if (e.stopPropagation)
            e.stopPropagation();
        if (e.preventDefault)
            e.preventDefault();
        e.cancelBubble = true;
        e.cancel = true;
        e.returnValue = false;
        return false;
    }

    hookEvent('flexAppDiv', 'mousewheel', cancelEvent);

