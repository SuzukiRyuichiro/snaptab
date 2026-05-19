# AGENTS.md

## Project Overview

Snaptab is a simple, mobile first, dumb-free expense tracking app for lazy young people. The app allows seamless input of expenses via recipt pictures and voice input. No need for manual form input. Motto is keep in the tab and forget it.

## Tech Stack

- **Backend:** Rails 8.0, Ruby 3.3.5, PostgreSQL
- **Frontend:** Tailwind CSS 4, Stimulus, Turbo Rails, DaisyUI.
- **Auth:** Rails built in authentication
- **Authorization:** Pundig built by varvet.
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
- **Policies** in `app/policies/` handle authorization. Done with Pundit. Everything must be policy scoped or authorized before presenting to the user. Only landing page and other misc pages doesn't require authorization.

### Key frontend notes

- It should strictly use DaisyUI components as much as possible for consistency
- Should only use daisy-ui related CSS and tailwindcss classes. Custom style generation is not allowed unless told to.


### Core Domain Models

- **User** rails generated user model.
- **Expense** which records a single instance of expense.
- **Subscription** recurring payments that the user sets.
- **Category** category of expense, such as food, entertainment, etc. It has slugs.

### Documentations

- For DaisyUI compoenents, checkout `@fetch https://daisyui.com/llms.txt`
- For Icons, use https://heroicons.com/outline

### Localization

- This app is internationalized. First into Japanese and English
- Default locale is English
- Localization files are in config/locales.
- Every aspect of app should be localized
