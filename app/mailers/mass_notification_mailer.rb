class MassNotificationMailer < ApplicationMailer
  # Оптимизация
  # В мейлер передается сразу коллекция вопросов,
  # чтобы каждый раз не перегружать их из базы.
  def digest(user, questions)
    @user = user
    @questions = questions

    mail to: @user.email, subject: "Дайджест свежих вопросов"
  end

  def question_subscribers(user, question, answer)
    @user = user
    @question = question
    @answer = answer

    mail to: @user.email, subject: "На ваш вопрос \"#{@question.title}\" дан новый ответ"  
  end
end