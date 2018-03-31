module Finances
  Engine.routes.draw do
    resources :expense_categories, except: :show do
      resources :expenses, only: :index do
        get '/:month' => :index, on: :collection, constraints: Constraints::MonthConstraint
      end
    end

    resources :expenses, except: :show do
      collection do
        get '/:month' => :index,                  constraints: Constraints::MonthConstraint
        get 'statistics(/:month)' => :statistics, constraints: Constraints::MonthConstraint, as: :statistics
      end
    end
  end
end
