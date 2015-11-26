$("#question-edit-errors").html '<%= render "shared/error_messages", object: @question %>'

<% if @question.errors.empty? %>
$('#question-content').html '<%= j render @question %>'
toggleQuestionForm()
<% end %>