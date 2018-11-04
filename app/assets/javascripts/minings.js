// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require bootstrap-4.0.0/js/bootstrap.min
//= require_tree './minings'

function show_flash_msg(msg, key){
    var html = '<div class="alert alert-' + key + '" role="alert">\n' +
        '<a href="#" class="close" data-dismiss="alert">&times;</a>\n' + msg +
        '</div>'

    $(".flash_area").html(html)
}