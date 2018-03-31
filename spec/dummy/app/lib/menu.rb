class Menu
  include Singleton
  include ActionView::Helpers

  attr_reader :items

  def initialize
    @items = {}
  end

  def generate_html view
    view.content_tag 'ul' do
      items.map do |main, routes|
        i18n_scope    = [ 'links', main ]
        routing_proxy = view.send main

        view.content_tag 'li' do
          main_link = link_to I18n.t('root', scope: i18n_scope), routing_proxy.send(routes[:root])
          sub_links = view.content_tag 'ul' do
            routes.except(:root).map do |name, routing_method|
              view.content_tag 'li' do
                link_to I18n.t(name, scope: i18n_scope), routing_proxy.send(routing_method)
              end
            end.join("\n").html_safe
          end

          main_link + sub_links
        end
      end.join("\n").html_safe
    end
  end
end
