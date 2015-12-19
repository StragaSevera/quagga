toggleAnswerForm = (e) ->
  e.preventDefault()
  answer_id = $(this).data('answerId')
  $("#answer-edit-#{answer_id}").toggleClass 'block-hidden'
  

@bindToggleAnswerForms = ->
  $('.answer-show-edit-form').rebind("click", toggleAnswerForm)

$(document).bindOnLoad(bindToggleAnswerForms)

bindVote('answer')

# Рендерим ответ, если его еще нет на странице.
# Если задан user_id, рендерит лишь при несовпадающих с текущим id пользователя
@addAnswer = (answer, id, userId) ->
  if userId == undefined || userId != gon.currentUserId
    $('#answers-block').prepend(answer) if $("#answer-row-#{id}").length == 0