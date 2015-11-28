$('#answer-row-<%= @answer.id %>').remove()
renderFlash("<%= j render 'layouts/flash' if flash.any? %>")