<<<<<<< HEAD
$(document).foundation();


$(document).ready(function() {
    
    $('#drop-button').click(function () {
        var menu = $('#drop-menu');
        if($('#drop-menu').is(':visible')) {
            menu.hide();
        } else {
            menu.show();    
        }
        return false;
    })
});


$(window).resize(function() {
    if($(this).width() > 599) {
        $('#drop-menu').hide();
    }
});
=======
$(document).foundation();
>>>>>>> FETCH_HEAD
