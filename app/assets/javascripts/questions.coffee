@toggleQuestionForm = ->
  $('.question-edit').toggleClass 'block-hidden'

bindToggleQuestionForms = ->
  $('.question-show-edit-form').click (e) ->
    e.preventDefault()
    toggleQuestionForm()

$(document).ready(bindToggleQuestionForms)
$(document).on('page:load', bindToggleQuestionForms)