$('.answer-check').removeClass("answer-best").addClass("answer-normal")

<% if @answer.best? %>
$('#answer-check-<%= @answer.id %>').removeClass("answer-normal").addClass("answer-best")
<% end %>
