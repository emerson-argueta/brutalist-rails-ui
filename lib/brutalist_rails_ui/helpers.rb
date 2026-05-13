module BrutalistRailsUi
  module Helpers
    # Nav link that highlights when active.
    # Pass mobile: true for the vertical mobile menu variant.
    def nav_link(label, path, mobile: false, **options)
      active = current_page?(path) || request.path.start_with?(path.split("?").first)
      if mobile
        classes = active \
          ? "block bg-yellow-400 text-black px-4 py-3 text-sm font-bold border-b border-gray-700" \
          : "block text-white hover:bg-gray-800 px-4 py-3 text-sm font-bold border-b border-gray-700"
      else
        classes = active \
          ? "bg-yellow-400 text-black px-3 py-4 text-sm font-bold border-r border-l border-yellow-400" \
          : "text-white hover:bg-white hover:text-black px-3 py-4 text-sm font-bold border-r border-gray-700 last:border-r-0"
      end
      link_to label, path, class: classes, **options
    end

    # Page header row: h1 title + optional action buttons block.
    #
    #   <%= page_header "Transactions" do %>
    #     <%= link_to "+ Add", new_transaction_path, class: "btn-primary" %>
    #   <% end %>
    def page_header(title, subtitle: nil, &block)
      content_tag :div, class: "flex flex-wrap items-center justify-between gap-3 mb-6" do
        concat content_tag(:div) {
          concat content_tag(:h1, title, class: "text-2xl font-black text-black uppercase tracking-tight")
          concat content_tag(:p, subtitle, class: "text-sm font-bold text-gray-500 mt-1 uppercase tracking-wide") if subtitle
        }
        concat content_tag(:div, capture(&block), class: "flex flex-wrap items-center gap-2") if block
      end
    end

    # White card with optional black header bar.
    #
    #   <%= card "Recent Transactions" do %>
    #     <p class="p-6">Content here</p>
    #   <% end %>
    def card(title = nil, &block)
      content_tag :div, class: "bg-white border-2 border-black overflow-hidden" do
        if title
          concat content_tag(:div, class: "px-6 py-3 bg-black") {
            content_tag(:h2, title, class: "text-xs font-bold text-white uppercase tracking-wider")
          }
        end
        concat capture(&block)
      end
    end

    # Card header bar with optional right-side action.
    #
    #   <%= card_header "Accounts", action_text: "View all", action_path: accounts_path %>
    def card_header(title, action_text: nil, action_path: nil)
      content_tag :div, class: "px-6 py-3 bg-black flex items-center justify-between" do
        concat content_tag(:h2, title, class: "text-xs font-bold text-white uppercase tracking-wider")
        if action_text && action_path
          concat link_to(action_text, action_path, class: "text-xs text-yellow-400 hover:text-white font-bold")
        end
      end
    end

    # Centered empty state with icon and message.
    #
    #   <%= empty_state icon: "✓", message: "All transactions assigned" %>
    #   <%= empty_state icon: "📭", message: "No accounts yet" do %>
    #     <%= link_to "Connect a bank", banks_link_path, class: "btn-primary mt-4" %>
    #   <% end %>
    def empty_state(icon: nil, message:, &block)
      content_tag :div, class: "px-6 py-12 text-center" do
        concat content_tag(:p, icon, class: "text-3xl mb-3") if icon
        concat content_tag(:p, message, class: "font-black text-black uppercase tracking-wide")
        concat capture(&block) if block
      end
    end

    # KPI stat box for summary grids.
    #
    #   <div class="grid grid-cols-2 gap-4">
    #     <%= kpi_box label: "Total Spent", value: "$12.40" %>
    #     <%= kpi_box label: "Total Calls", value: "42", dark: true %>
    #   </div>
    def kpi_box(label:, value:, dark: false)
      bg = dark ? "bg-black text-white" : "bg-white border-2 border-black text-black"
      label_class = dark ? "text-xs font-bold uppercase tracking-widest text-gray-400 mb-1" \
                         : "text-xs font-bold uppercase tracking-widest text-gray-500 mb-1"
      content_tag :div, class: "#{bg} p-5" do
        concat content_tag(:p, label, class: label_class)
        concat content_tag(:p, value, class: "text-2xl font-black")
      end
    end

    # Yellow CTA banner with headline and action link.
    #
    #   <%= cta_banner headline: "Connect a bank",
    #                  subtext: "Sync transactions automatically",
    #                  link_text: "Get Started",
    #                  path: banks_link_path %>
    def cta_banner(headline:, subtext: nil, link_text:, path:, **link_options)
      content_tag :div, class: "border-2 border-black bg-yellow-400 p-6 flex items-center justify-between gap-4" do
        concat content_tag(:div) {
          concat content_tag(:p, headline, class: "font-black text-black uppercase")
          concat content_tag(:p, subtext, class: "text-sm text-black mt-1 font-bold") if subtext
        }
        concat link_to(link_text, path, class: "btn-primary flex-shrink-0", **link_options)
      end
    end

    # Status badge pill.
    #
    #   <%= status_badge "pending" %>
    #   <%= status_badge "funded", "funded" => "bg-green-600 text-white" %>
    def status_badge(status, color_map = {})
      defaults = {
        "active"    => "bg-black text-white",
        "funded"    => "bg-black text-white",
        "over"      => "bg-red-600 text-white",
        "pending"   => "bg-yellow-400 text-black",
        "income"    => "bg-black text-white",
        "transfer"  => "bg-white text-black",
        "untracked" => "bg-white text-black"
      }.merge(color_map)
      color = defaults[status.to_s] || "bg-white text-black"
      tag.span status.to_s.humanize,
        class: "inline-flex items-center border-2 border-black px-2 py-0.5 text-xs font-bold uppercase tracking-wide #{color}"
    end

    # Format a number as currency.
    def money(amount)
      number_to_currency(amount, unit: "$", precision: 2)
    end

    # CSS class for positive/negative amounts.
    def money_class(amount)
      amount.to_f.negative? ? "text-red-600" : "text-black"
    end
  end
end
