module Finances
  module ExpensesHelper

    def month_step_links actual_month, path
      actual_month ||= Date.today.strftime '%Y-%m'
      actual_month_date = Date.new(*actual_month.split('-').map(&:to_i), 1)
      previous_month = actual_month_date.prev_month.strftime '%Y-%m'
      next_month     = actual_month_date.next_month.strftime '%Y-%m'

      content_tag :nav, class: 'nav nav-bar col-xs-12' do
        link_to(previous_month, "#{path}/#{previous_month}", class: 'navbar-text') +
          link_to(next_month, "#{path}/#{next_month}", class: 'pull-right navbar-text')
      end
    end

  end
end
