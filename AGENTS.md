# AGENTS.md

## Project Overview

Snaptab is a simple, mobile first, dumb-free expense tracking app for lazy young people. The app allows seamless input of expenses via recipt pictures and voice input. No need for manual form input. Motto is keep in the tab and forget it.

## Tech Stack

- **Backend:** Rails 8.0, Ruby 3.3.5, PostgreSQL
- **Frontend:** Tailwind CSS 4, Stimulus, Turbo Rails, DaisyUI.
- **Auth:** Rails built in authentication
- **Testing:** RSpec, Capybara with Cuprite, FactoryBot, WebMock/VCR

## Common Commands

### Development

```bash
bin/dev            # Start dev server (Puma + Tailwind)
```

### Testing

TBD

### Linting

```bash
bin/rubocop              # Ruby linting
bin/erb_lint --lint-all  # ERB template linting
```

## Architecture

### Key Patterns

- **Routes** are under `config/routes/`
- **Service objects** in `app/services/` encapsulate business logic.
- **Policies** in `app/policies/` handle authorization. Done with Pundit ge

### Key frontend notes

- It should strictly use DaisyUI components as much as possible for consistency
- Should only use daisy-ui related CSS and tailwindcss classes. Custom style generation is not allowed unless told to.


### Core Domain Models

- **User** rails generated user model.
- **Expense** which records a single instance of expense.
- **Subscriptions** recurring payments that the user sets


### Documentations

- For DaisyUI compoenents, checkout `@fetch https://daisyui.com/llms.txt`
- For Icons, use https://heroicons.com/outline
