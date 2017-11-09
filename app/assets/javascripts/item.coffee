# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->
  $('#favourite-link').on 'click', (e) ->
    e.preventDefault()
    # e.target.textContent = "favorite"
    $.ajax
      type: 'PUT'
      beforeSend: (xhr) ->
        xhr.setRequestHeader 'X-CSRF-TOKEN', $('meta[name="csrf-token"]').attr('content')
      url: $(this).data('url')
      dataType: 'script'
      success: (_, __, xhr) ->
        if xhr.status == 200
          e.target.textContent = "favorite_border"
        else
          e.target.textContent = "favorite"
