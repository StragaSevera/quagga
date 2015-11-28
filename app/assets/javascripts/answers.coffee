toggleAnswerForm = (id) ->
  $("#answer-edit-#{id}").toggleClass 'block-hidden'

@bindToggleAnswerForms = ->
  $('.answer-show-edit-form').click (e) ->
    e.preventDefault()
    answer_id = $(this).data('answerId')
    toggleAnswerForm(answer_id)

$(document).ready(bindToggleAnswerForms)
$(document).on('page:load', bindToggleAnswerForms)