# Оборачиваем привязку голоса в замыкание.
# Конечно, хорошо бы не засорять глобальный неймспейс
# и обернуть в объект, но пока, думаю, это overengineering
@bindVote = (klass, changeScore) ->
  voteSuccess = (e, data, status, xhr) ->
    score = $.parseJSON(xhr.responseText).score
    id = $(this).data("#{klass}Id")
    $("##{klass}-score-value-#{id}").html(score)

  voteFailure = (e, xhr, status, error) ->
    alert("Произошла ошибка при отправке голоса!")

  bindVoteHandlers = ->
    $(".#{klass}-vote-link").rebind('ajax:success', voteSuccess)
    .rebind('ajax:error', voteFailure)

  $(document).bindOnLoad(bindVoteHandlers)