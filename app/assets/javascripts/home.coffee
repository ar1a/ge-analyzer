# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->
  if $('#back-to-top').length
    scrollTrigger = 100

    backToTop = ->
      scrollTop = $(window).scrollTop()
      if scrollTop > scrollTrigger
        $('#back-to-top').removeClass 'scale-out'
      else
        $('#back-to-top').addClass 'scale-out'

    backToTop()
    $(window).on 'scroll', ->
      backToTop()
    $('#back-to-top').on 'click', (e) ->
      e.preventDefault()
      $('html,body').animate { scrollTop: 0 }, 700

