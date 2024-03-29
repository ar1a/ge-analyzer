// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require jquery
//= require turbolinks
//= require materialize-sprockets
//= require materialize/extras/nouislider
//= require chartkick
//= require_tree .

// Tab fix

$(document).on('turbolinks:load', function(event) {
    $('ul.tabs').tabs({
        onShow: function() {
            for (var key in Chartkick.charts) {
                if(Chartkick.charts.hasOwnProperty(key)) {
                    Chartkick.charts[key].redraw();
                }
            }
        }
    });

    $('#refresh-button').on('click', function(e) {
        ga('send', 'event', 'Items', 'refresh', e.target.dataset.name);
    });

    if (typeof(ga) == 'function') {
        ga('set', 'location', event.originalEvent.data.url);
        ga('send', 'pageview');
    }

    $('select').material_select();
    $('.dropdown-btn').dropdown();
});
