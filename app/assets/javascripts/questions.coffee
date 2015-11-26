@toggleQuestionForm = ->
  $('.question-edit-row').toggleClass 'block-hidden'

bindToggleForms = ->
  $('.question-show-edit-form').click (e) ->
    e.preventDefault()
    toggleQuestionForm()

$(document).ready(bindToggleForms)
$(document).on('page:load', bindToggleForms)