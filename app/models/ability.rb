# frozen_string_literal: true

class Ability
  include CanCan::Ability

  # The first argument to `can` is the action you are giving the user
  # permission to do.
  # If you pass :manage it will apply to every action. Other common actions
  # here are :read, :create, :update and :destroy.
  #
  # The second argument is the resource the user can perform the action on.
  # If you pass :all it will apply to every resource. Otherwise pass a Ruby
  # class of the resource.
  #
  # The third argument is an optional hash of conditions to further filter the
  # objects.
  # For example, here the user can only update published articles.
  #
  #   can :update, Article, published: true
  #
  # See the wiki for details:
  # https://github.com/CanCanCommunity/cancancan/blob/develop/docs/define_check_abilities.md

  def initialize(user)
    return if user.blank?

    if user.is_admin?
      can :manage, User, id: user.id
      can [:show, :destroy], User
      can :manage, Sabeel
      can :manage, Thaali
      can :manage, Transaction
    end

    if user.is_member?
      can [:show, :update, :destroy], User, id: user.id
      can :manage, Sabeel
      cannot [:create, :destroy], Sabeel
      can :manage, Thaali
      can :manage, Transaction
    end

    if user.is_viewer?
      can [:read, :stats, :active, :inactive], Sabeel
      can [:read, :stats, :complete, :pending, :all], Thaali
      can [:all, :show], Transaction
    end
  end
end
