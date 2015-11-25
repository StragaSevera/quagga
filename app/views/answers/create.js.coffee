$('#answer-errors').html '<%= render "shared/error_messages", object: @answer %>'

<% if @result %>
$('#answers-block').prepend '<%= j render @answer %>'
$('#answer_body').val('')
<% end %>