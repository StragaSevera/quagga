module SearchHelper
  def options_scope
    options = Search::SCOPES.map {|s| [t('.' + s), s]}
    options_for_select(options)
  end

  def select_search_scope
    select_tag :scope, options_scope, class: 'form-control'
  end

  def result_title(item)
    case item
    when Question
      link_to "вопрос \"#{item.title}\"", question_path(item.id)
    when Answer
      link_to "ответ к \"#{item.question.title}\"", question_path(item.question.id)
    when Comment
      if item.commentable_type == "Question"
        link_to "комментарий к \"#{item.commentable.title}\"", question_path(item.commentable.id)
      else
        link_to "комментарий к ответу к \"#{item.commentable.question.title}\"", question_path(item.commentable.question.id)
      end
    when User
      "Пользователь:"
    end    
  end

  def result_body(item)
    case item
    when User
      user.name
    else
      item.body
    end    
  end
end
