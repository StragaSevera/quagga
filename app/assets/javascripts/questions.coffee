@toggleQuestionForm = (e) ->
  e.preventDefault() unless e == undefined
  $('.question-edit').toggleClass('block-hidden')

bindToggleQuestionForms = ->
  $('.question-show-edit-form').rebind("click", toggleQuestionForm)

$(document).bindOnLoad(bindToggleQuestionForms)

bindVote('question')

# Рендерим вопрос, если его еще нет на странице.
# Если задан user_id, рендерит лишь при несовпадающих с текущим id пользователя.
# В принципе, можно и без этой проверки, но ради единообразия API...
@addQuestion = (question, id, userId) ->
  if userId == undefined || userId != gon.currentUserId
    $('#questions-block').prepend(question) if $("#question-row-#{id}").length == 0