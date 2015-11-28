$('#answer-new-errors').html '<%= j render "shared/error_messages", object: @answer %>'

<% if @answer.errors.empty? %>
$('#answers-block').prepend '<%= j render @answer %>'
$('#answer_body').val('')
<% end %>