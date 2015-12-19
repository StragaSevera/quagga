toggleAnswerForm = (e) ->
  e.preventDefault()
  answer_id = $(this).data('answerId')
  $("#answer-edit-#{answer_id}").toggleClass 'block-hidden'
  

@bindToggleAnswerForms = ->
  $('.answer-show-edit-form').rebind("click", toggleAnswerForm)

$(document).bindOnLoad(bindToggleAnswerForms)

bindVote('answer')