function paf_validateForm1(f) {
    var msg = '';
    if (!paf_checkForAtleastOneRowSelection(f, 'rowcb')) {
        msg += '*** None selected to Approve ***\n\n';
    }
    if (msg != '') {
        alert(msg);
        return false;
    }
    return true;
}

function paf_validateForm2(f) {
    var msg = '';
    if (!paf_checkForAtleastOneRowSelection(f, 'rowcb')) {
        msg += '*** None selected to Reject ***\n\n';
    }
    if (!paf_validateRequiredField(f, 'userComments')) {
        msg += '*** Reject Comments are required ***\n\n';
    }
    if (msg != '') {
        alert(msg);
        return false;
    }
    return true;
}

function paf_validateForm3(f) {
    var msg = '';
    if (!paf_validateRequiredField(f, 'userComments')) {
        msg += '*** Reject Comments are required ***\n\n';
    }
    if (msg != '') {
        alert(msg);
        return false;
    }
    return true;
}

function paf_validateForm4(f) {
    var msg = '';
    if (!paf_checkForAtleastOneRowSelection(f, 'rowcb')) {
        msg += '*** None selected to Edit ***\n\n';
    }
    if (msg != '') {
        alert(msg);
        return false;
    }
    return true;
}

function paf_checkForAtleastOneRowSelection(f, rcbId) {
    var checked = false;
    for (i = 0; i < f.elements.length; i++) {
        if (f.elements[i].id.indexOf(rcbId)!=-1 && 
            f.elements[i].checked) {
            checked = true;
            break;
        }
    }
    return checked;
}

function paf_validateRequiredField(f, eid) {
    var e = paf_getElementById(f, eid);
    if (!e) {
        return false;
    }
    var c = e.value.replace(/(^\s*)|(\s*$)|(^\n*)|(\n*$)/g, '');
    if (c.length == 0) {
        return false;
    }
    return true;
}

function paf_getElementById(f, eid) {
    var e;
    for (i = 0; i < f.elements.length; i++) {
        e = f.elements[i];
        if (e.id.indexOf(eid) != -1) {
            break;
        }
    }
    return e;
}

function paf_checkAll(frm, acb) {
    for (var i = 0; i < frm.elements.length; i++) {
        var e = frm.elements[i];
        if (e.id.indexOf('rowcb') != -1 && 
            e.disabled == false) {
            e.checked = acb.checked;
        }
    }
}

function paf_toggleAllCheckbox(f, cb) {
    var acb = paf_getElementById(f, 'allcb');
    if (acb) {
        acb.checked = paf_isAllChecked(f,cb);
    }
}

function paf_isAllChecked(f, cb) {
    if (!cb.checked) {
        return false;
    }
    for (i = 0; i < f.elements.length; i++) {
        var e = f.elements[i];
        if (e.id.indexOf('rowcb') != -1 &&
            !e.checked) {
            return false;
        }
    }
    return true;
}
