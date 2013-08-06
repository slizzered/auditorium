# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).foundation('joyride', 'start');

$('.choosable').on 'click', (event) ->
  event.preventDefault()
  selected_group = $(this)
  $('.choosable').removeClass('selected')
  selected_group.addClass('selected')
  console.log selected_group
  $.ajax 
    url: '/groups/change_group_type'
    data: { group_type: $(selected_group).data('id') }
    error: (jqXHR, textStatus, errorThrown) ->
      console.log errorThrown
    success: 
      $("html, body").animate({ scrollTop: $('#group-basic-information').offset().top }, 1000);


$('.input-fields input#question_subject').on 'focus', (e) ->
  $('#question_subject').attr('placeholder', i18n_question_subject_placeholder)
  $('#new-question-fields').slideDown()

$('.input-fields input#announcement_subject').on 'focus', (e) ->
  $('#announcement_subject').attr('placeholder', i18n_announcement_subject_placeholder)
  $('#new-announcement-fields').slideDown()

$('.input-fields input#group_subject').on 'focus', (e) ->
  $('#group_subject').attr('placeholder', i18n_group_subject_placeholder)
  $('#new-group-fields').slideDown()