toggleAnswerForm = (e) ->
  e.preventDefault()
  answer_id = $(this).data('answerId')
  $("#answer-edit-#{answer_id}").toggleClass 'block-hidden'
  

@bindToggleAnswerForms = ->
  $('.answer-show-edit-form').off("click", toggleAnswerForm)
  $('.answer-show-edit-form').on("click", toggleAnswerForm)

$(document).ready(bindToggleAnswerForms)
$(document).on('page:load', bindToggleAnswerForms)