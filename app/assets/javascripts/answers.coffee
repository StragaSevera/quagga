toggleAnswerForm = (e) ->
  e.preventDefault()
  answer_id = $(this).data('answerId')
  $("#answer-edit-#{answer_id}").toggleClass 'block-hidden'
  

@bindToggleAnswerForms = ->
  $('.answer-show-edit-form').rebind("click", toggleAnswerForm)

$(document).bindOnLoad(bindToggleAnswerForms)



voteAnswerSuccess = (e, data, status, xhr) ->
	score = $.parseJSON(xhr.responseText).score
	answer_id = $(this).data('answerId')
	$("#answer-score-value-#{answer_id}").html(score)

voteAnswerFailure = (e, xhr, status, error) ->
	alert("Произошла ошибка при отправке голоса!")

bindAnswerVote = ->
	$('.answer-vote').rebind('ajax:success', voteAnswerSuccess)
	.rebind('ajax:error', voteAnswerFailure)

$(document).bindOnLoad(bindAnswerVote)