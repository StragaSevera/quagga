@toggleQuestionForm = (e) ->
  e.preventDefault() unless e == undefined
  $('.question-edit').toggleClass('block-hidden')

bindToggleQuestionForms = ->
  $('.question-show-edit-form').rebind("click", toggleQuestionForm)

$(document).bindOnLoad(bindToggleQuestionForms)

bindVote('question')