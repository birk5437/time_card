authorization do
  role :guest do
    # add permissions for guests here, e.g.
    # has_permission_on :conferences, :to => :read
    has_permission_on :users_registrations, to: [:create]
    # has_permission_on :users_registrations, to: :signup
    # has_permission_on :users, to: :signup
  end

  role :barista do
    has_permission_on :shifts, to: :manage do
      if_attribute :user_id => is { user.id }
    end
    has_permission_on :users, to: [:account, :update, :show, :clock_in, :clock_out] do
      if_attribute :id => is { user.id }
    end
    has_permission_on :users, to: [:clock_page]
  end

  role :manager do
    includes :barista
  end

  role :admin do
    includes :manager
    has_permission_on :shifts, to: :manage
    has_permission_on :users, to: :manage
  end

  role :superuser do
    has_omnipotence
  end
  
  # permissions on other roles, such as
  # role :admin do
  #   has_permission_on :conferences, :to => :manage
  # end
  # role :user do
  #   has_permission_on :conferences, :to => [:read, :create]
  #   has_permission_on :conferences, :to => [:update, :delete] do
  #     if_attribute :user_id => is {user.id}
  #   end
  # end
  # See the readme or GitHub for more examples
end

privileges do
  # default privilege hierarchies to facilitate RESTful Rails apps
  privilege :manage, :includes => [:create, :read, :update, :delete]
  privilege :read_and_update, :includes => [:create, :read, :update]
  privilege :read_and_update_without_index, :includes => [:create, :update, :show]
  privilege :update_and_show, :includes => [:create, :update, :show]
  privilege :read, :includes => [:index, :show]
  privilege :create, :includes => [:new, :create]
  privilege :update, :includes => [:edit, :update]
  privilege :delete, :includes => :destroy

end
