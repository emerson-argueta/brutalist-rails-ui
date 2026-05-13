# brutalist_rails_ui

Neobrutalist UI component library for Rails. Thick black borders, yellow accents, uppercase type, no rounded corners.

Built with Tailwind CSS v4 + Hotwire.

## Installation

Add to your Gemfile:

```ruby
gem "brutalist_rails_ui", path: "path/to/brutalist_rails_ui"
```

Run the installer:

```bash
bundle install
rails g brutalist_rails_ui:install
bin/rails tailwindcss:build
```

Add to `app/helpers/application_helper.rb`:

```ruby
module ApplicationHelper
  include BrutalistRailsUi::Helpers
end
```

The generator:
- Copies `brutalist_rails_ui.css` → `app/assets/tailwind/`
- Injects `@import "./brutalist_rails_ui"` into `application.css`
- Copies `modal_controller.js` → `app/javascript/controllers/`

Add `modal_controller` to your importmap in `application.html.erb`:

```erb
"controllers/modal_controller": "<%= asset_path('controllers/modal_controller.js') %>"
```

## CSS Directives

| Class | Use |
|-------|-----|
| `.btn-primary` | Black button, yellow on hover |
| `.btn-secondary` | White button, yellow on hover |
| `.btn-danger` | Red button |
| `.input` | Form input field |
| `.label` | Form label |
| `.card` | White box with black border |
| `.card-header` | Black bar with white text (inside `.card`) |
| `.table-brutal` | Table with black header and dividers |
| `.badge` | Inline status pill |
| `.money-input` | Wrapper for `$`-prefixed number inputs |
| `.progress-bar` | Gray track with `.progress-bar-fill` inside |

## View Helpers

### `page_header`

```erb
<%= page_header "Transactions" do %>
  <%= link_to "+ Add", new_transaction_path, class: "btn-primary text-sm" %>
<% end %>

<%# With subtitle %>
<%= page_header "Unassigned", subtitle: "42 transactions need a category" %>
```

### `card`

```erb
<%= card "Recent Activity" do %>
  <p class="p-6">Content here</p>
<% end %>

<%# No header %>
<%= card do %>
  <p class="p-6">Content</p>
<% end %>
```

### `card_header`

```erb
<div class="card">
  <%= card_header "Accounts", action_text: "View all", action_path: accounts_path %>
  ...
</div>
```

### `empty_state`

```erb
<%= empty_state icon: "✓", message: "All transactions assigned" %>

<%= empty_state icon: "📭", message: "No accounts yet" do %>
  <%= link_to "Connect a bank", banks_link_path, class: "btn-primary mt-4" %>
<% end %>
```

### `kpi_box`

```erb
<div class="grid grid-cols-2 gap-4">
  <%= kpi_box label: "Total Spent", value: "$12.40" %>
  <%= kpi_box label: "Total Calls", value: "42", dark: true %>
</div>
```

### `cta_banner`

```erb
<%= cta_banner headline: "Connect a bank",
               subtext: "Sync transactions automatically",
               link_text: "Get Started",
               path: banks_link_path %>
```

### `status_badge`

```erb
<%= status_badge "pending" %>
<%= status_badge "over", "over" => "bg-red-600 text-white" %>
```

### `nav_link`

```erb
<%= nav_link "Dashboard", root_path %>
<%= nav_link "Transactions", transactions_path %>
```

### `money` / `money_class`

```erb
<span class="<%= money_class(transaction.amount) %>">
  <%= money(transaction.amount) %>
</span>
```

## Partials

### Modal

Wraps content in a Turbo Frame modal overlay with backdrop-click-to-close.

```erb
<%# In your view (e.g. transactions/new.html.erb) %>
<%= render "brutalist_rails_ui/modal", title: "Add Transaction", width: "max-w-md" do %>
  <%= render "form", transaction: @transaction %>
<% end %>
```

Options:
- `title` — header text (required)
- `width` — Tailwind max-width class (default: `max-w-sm`)
- `frame_id` — turbo-frame id (default: `modal`)
- `body_class` — padding class for body wrapper (default: `p-6`)

Add `<turbo-frame id="modal"></turbo-frame>` to your layout.

### Flash

```erb
<%= render "brutalist_rails_ui/flash" %>
```

### Pagination

Requires [Pagy](https://github.com/ddnexus/pagy).

```erb
<%= render "brutalist_rails_ui/pagination", pagy: @pagy %>
```

### Form buttons

```erb
<%= render "brutalist_rails_ui/form_buttons",
    f: f,
    cancel_path: transactions_path,
    submit_text: "Add Transaction" %>
```

Options:
- `f` — form builder (required)
- `cancel_path` — cancel link href (required)
- `submit_text` — submit button label (default: `Save`)
- `cancel_text` — cancel button label (default: `Cancel`)
- `cancel_frame` — turbo frame for cancel link (default: `_top`)

## Usage with WASM (wasm-rails)

When running inside [wasm-rails](https://github.com/emerson-argueta/wasm-rails), three extra steps are required because Bundler auto-require and engine view path registration don't work in the WASM environment.

### 1. Explicit require in `config/application.rb`

`Bundler.require` is skipped in WASM, so add an explicit require alongside your other gems:

```ruby
require "wasm_rails"
require "brutalist_rails_ui"
require "turbo-rails"
```

### 2. Include helpers in `ApplicationHelper`

Rails hooks like `ActiveSupport.on_load` and `config.to_prepare` don't fire reliably in WASM. Include helpers directly instead:

```ruby
module ApplicationHelper
  include BrutalistRailsUi::Helpers
end
```

### 3. Bundle the gem's ERB partials

Add `brutalist_rails_ui` to `GEM_EXTRA_PATHS` in `bin/build_app_bundle.mjs` so the gem's `app/views` are included in the WASM bundle:

```js
const GEM_EXTRA_PATHS = {
  'turbo-rails': ['app/controllers', 'app/controllers/concerns', 'app/helpers', 'app/models', 'app/models/concerns', 'app/views'],
  'brutalist_rails_ui': ['app/views'],
};
```

Then rebuild:

```bash
npm run build:app
```

## Requirements

- Ruby 3.1+
- Rails 7.1+
- Tailwind CSS v4 (via tailwindcss-rails)
- Hotwire / Stimulus (for modal controller)
