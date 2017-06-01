function isChrome(nAgt) {
  return nAgt.indexOf('Chrome') != -1
}

function getMacVersion(nAgt) {
  var macreg = /Mac OS X/;
  if (macreg.test(nAgt)) {
    //it is a mac
    return /Mac OS X (10[\.\_\d]+)/.exec(nAgt)[1].replace(/_/g,".");
  }
  return false;  
}

function versionCompare(left, right) {
    if (typeof left + typeof right != 'stringstring')
        return false;    
    var a = left.split('.')
    ,   b = right.split('.')
    ,   i = 0, len = Math.max(a.length, b.length);
        
    for (; i < len; i++) {
        if ((a[i] && !b[i] && parseInt(a[i]) > 0) || (parseInt(a[i]) > parseInt(b[i]))) {
            return true;
        } else if ((b[i] && !a[i] && parseInt(b[i]) > 0) || (parseInt(a[i]) < parseInt(b[i]))) {
            return false;
        }
    }
    
    return 0;
}

$(document).ready(function(){
  var nAgt = navigator.userAgent;
  if (isChrome(nAgt)) {
    if(versionCompare("10.12",getMacVersion(nAgt)))
      alert('Warning: our streaming media sometimes has problems displaying on your operating system when using the Chrome browser. If you experience problems viewing content, try using another browser such as Safari or Firefox, or update your operating system to the latest version of OS X.');
  }
});

