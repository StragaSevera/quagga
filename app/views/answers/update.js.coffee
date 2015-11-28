<% if @answer.errors.empty? %>
$('#answer-<%= @answer.id %>').html '<%= j render @answer %>'
bindToggleAnswerForms()
<% else %>
$('#answer-edit-errors-<%= @answer.id %>').html '<%= j render "shared/error_messages", object: @answer %>'
<% end %>