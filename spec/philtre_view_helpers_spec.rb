require_relative '../lib/philtre-rails/philtre_view_helpers.rb'
require_relative '../lib/philtre-rails/order_link.rb'

describe PhiltreRails::PhiltreViewHelpers do
  def subject
    @subject ||= begin
      obj = Object.new.extend( described_class )
      class << obj
        def raw(str); str end
        def link_to(text, params, html_options)
          html_options.merge(href: params.inspect)
          html_attrs = html_options.map{|k,v| %Q{#{k}="#{v}"}}.join(' ')
          %Q{<a #{html_attrs}>#{text}</a>}
        end
      end
      obj
    end
  end

  describe '#order_by' do
    def filter
      @filter ||= Philtre::Filter.new order: [:first, :second]
    end

    it 'returns label for no filter' do
      subject.order_by( nil, :first ).should == 'First'
    end

    it 'inverts no order' do
      link_str = subject.order_by( filter, :first )
      link_str.should =~ />First.*?</
      link_str.should =~ /class="descending/
    end

    it 'inverts ascending order' do
      filter = self.filter.clone(:order => :first_asc)
      link_str = subject.order_by( filter, :first )
      link_str.should =~ />First.*?</
      link_str.should =~ /class="descending/
    end

    it 'inverts descending order' do
      filter = self.filter.clone(:order => :first_desc)
      link_str = subject.order_by( filter, :first )
      link_str.should =~ />First.*?</
      link_str.should =~ /class="ascending/
    end

    describe 'OrderLink' do
      class CustomOrderLink < PhiltreRails::OrderLink
        def css_class
          if active
            expr.descending ? 'going_down' : 'going_up'
          end
        end
      end

      it 'uses custom order link' do
        link_str = subject.order_by filter, :first, order_link_class: CustomOrderLink
        link_str.should =~ />First.*?</
        link_str.should =~ /class="going_down/
      end

      it 'changes default order link' do
        # don't modify the class definition
        subject = self.subject.clone
        class << subject
          def default_order_link_class
            CustomOrderLink
          end
        end

        link_str = subject.order_by  filter, :first, order_link_class: CustomOrderLink
        link_str.should =~ />First.*?</
        link_str.should =~ /class="going_down/
      end
    end
  end
end
