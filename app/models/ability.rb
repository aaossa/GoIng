# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # Root of web app
    can :index, WelcomeController
    # Email callbacks/routes
    can :answer_student_yes, ConfirmedClass
    can :answer_student_no, ConfirmedClass
    can :answer_teaching_assistant_yes, ConfirmedClass
    can :answer_teaching_assistant_no, ConfirmedClass
    can :show, ConfirmedClass
    # Available courses (?)
    can :index, Course
    # Sessions
    can [:create, :failure], SessionsController
    return if user.nil?
    if user.role?(:admin)
        # Admin can manage everything
        can :manage, :all
    elsif user.role?(:teaching_assistant)
        # TA can see assigned classes
        can :index, ConfirmedClass, teaching_assistant: { email: user.google_email }
        # TA can see each course
        can [:show], Course
        # TA can see every TA...
        can [:index, :show], TeachingAssistant
        # ... but can only change its own details
        can [:edit, :update], TeachingAssistant, email: user.google_email
        # TAs can create requests
        can [:new], Request
        # TAs can manage request where they participate (except destroy and update)
        can [:create, :index, :show], Request, Request.participates(user) do |request|
            request.participants.include? user.google_email
        end
        # Available time blocks in form
        can :options, TimeBlock
        # Sessions
        can [:destroy], SessionsController
    elsif user.role?(:student)
        can [:show], Course # Maybe teaching assistants
        # Students can create requests
        can [:new], Request
        # Students can manage request where they participate (except destroy and update)
        can [:create, :index, :show], Request, Request.participates(user) do |request|
            request.participants.include? user.google_email
        end
        # Available time blocks in form
        can :options, TimeBlock
        # Sessions
        can [:destroy], SessionsController
    end
  end
end
