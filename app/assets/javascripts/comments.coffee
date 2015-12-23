handleToggleCommentForm = (commentableName) ->
  $("##{commentableName}-comment-form").toggleClass('block-hidden')

toggleCommentForm = (e) ->
  e.preventDefault() unless e == undefined
  commentableName = $(this).data('commentableName')
  handleToggleCommentForm(commentableName)
  

bindToggleCommentForms = ->
  $('.commentable-show-comment-form').rebind("click", toggleCommentForm)

$(document).bindOnLoad(bindToggleCommentForms)

# Рендерим комментарий, если его еще нет на странице.
# Если задан user_id, рендерит лишь при несовпадающих с текущим id пользователя
@addComment = (comment, id, commentableName, userId) ->
  if userId == undefined || userId != gon.currentUserId
    $("##{commentableName}-comments-block").append(comment) if $("#{commentableName}-comment-#{id}").length == 0
    handleToggleCommentForm(commentableName)