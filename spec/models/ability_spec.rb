require 'rails_helper'

# Выглядит не очень красиво. Нет ли какого-то трюка для упрощения?
def it_should_have_ability_by_user(action, model, own = true)
  context "should be able to #{action.to_s} on #{model.to_s} when #{!own ? "not " : ""}owned" do
    if own
      let!(:model_allowed) { create(model, user: user) }
      let!(:model_denied) { create(model, user: other) }
    else
      let!(:model_allowed) { create(model, user: other) }
      let!(:model_denied) { create(model, user: user) }
    end

    it { should be_able_to action, model_allowed }
    it { should_not be_able_to action, model_denied }
  end
end

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:other) { create(:user_multi) }

    it { should be_able_to :read, User }
    it { should be_able_to :me, User }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :toggle_subscription, Question }

    it_should_have_ability_by_user(:update, :question)
    it_should_have_ability_by_user(:update, :answer)

    it_should_have_ability_by_user(:destroy, :question)
    it_should_have_ability_by_user(:destroy, :answer)

    it_should_have_ability_by_user(:vote, :question, false)
    it_should_have_ability_by_user(:vote, :answer, false)

    # В теории, ценой усложнения функции it_should_have_ability_by_user
    # (через передачу в хеше параметров двух моделей)
    # можно и эти тесты реализовать в меньшем объеме. Но стоит ли?..
    context "should be able to switch promotion on answer when question owner" do
      let(:question_own) { create(:question, user: user) }
      let(:answer_on_own) { create(:answer, question: question_own, user: other) }

      let(:question_not_own) { create(:question, user: other) }
      let(:answer_not_on_own) { create(:answer, question: question_not_own, user: user) }

      it { should be_able_to :switch_promotion, answer_on_own }
      it { should_not be_able_to :switch_promotion, answer_not_on_own }
    end

    context "should be able to destroy attachment when attachable owner" do
      let(:question_own) { create(:question, user: user) }
      let(:attachment_on_own) { create(:attachment, attachable: question_own) }

      let(:question_not_own) { create(:question, user: other) }
      let(:attachment_not_on_own) { create(:attachment, attachable: question_not_own) }    

      it { should be_able_to :destroy, attachment_on_own }
      it { should_not be_able_to :destroy, attachment_not_on_own }  
    end
  end
end 