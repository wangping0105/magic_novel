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
//= require bootstrap/js/bootstrap.min
//= require jquery_ujs
//= require turbolinks
//= require kindeditor/kindeditor.js
//= require react
//= require react_ujs
//= require antd/antd
//= require components
//= require remarkable/remarkable.js
//= require_tree .

function withFayeClient(callback) {
    var init_faye = function () {
        if(!window.initFaye) {
            console.log(window.faye_client_js_url)
            console.log(window.faye_push_url)

            window.initFaye = $.ajax({
                url: window.faye_client_js_url,
                cache: true,
                dataType: "script"
            }).done(function() {
                window.fayeClient = new Faye.Client(window.faye_push_url + "/faye");
                console.log(window.fayeClient, 1112222333)
            });
        }

        window.initFaye.done(callback);
    }

    setTimeout(init_faye, 400);
}

function S4() {
    return (((1+Math.random())*0x10000)|0).toString(16).substring(1);
}
function guid() {
    return (S4()+S4()+"-"+S4()+"-"+S4()+"-"+S4()+"-"+S4()+S4()+S4());
}