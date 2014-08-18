# http://api.rubyonrails.org/classes/Rails/Railtie.html
module PhiltreRails
  module PhiltreViewHelpers
    # There is a nicer way to do this, but it means monkey-patching Array.
    # Which upsets some folks.
    def unify_array( ary )
      case ary.size
      when 0; nil
      when 1; ary.first
      else; ary
      end
    end

    # can be overridden
    def default_order_link_class
      OrderLink
    end

    # Heavily modified from SearchLogic.
    def order_by( filter, *fields, label: fields.first.to_s.titleize, order_link_class: default_order_link_class )
      return label if filter.nil?

      # current ordering from the filter
      # each expr is a Sequel::SQL::Expression
      exprs = Hash[ filter.order_expressions ]

      # Invert each ordering for the generated link. Current sort order will be displayed.
      order_links = fields.map do |field|
        if exprs[field]
          order_link_class.new exprs[field].invert, active: true
        else
          order_link_class.new Sequel.asc(field)
        end
      end

      # filter params must have order in the right format
      filter_params = filter.filter_parameters.dup
      filter_params[:order] = unify_array( order_links.map( &:name ) )

      params_hash = {filter.class::Model.model_name.param_key.to_sym => filter_params}
      link_text = raw( [label, order_links.first.andand.icon].compact.join(' ') )
      link_to link_text, params_hash, {class: order_links.first.andand.css_class}
    end
  end
end
