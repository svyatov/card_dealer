# Contributing

Bug reports and pull requests are welcome at https://github.com/svyatov/card_dealer/issues.

## Setup

Install Ruby 3.3 or newer, then run:

```sh
bin/setup
```

## Tests and checks

`bundle exec rake` runs what CI runs: Steep, RuboCop, and RSpec. `bundle exec rake spec` runs the tests alone.

## Pull requests

1. Fork the repository and create a branch from `main`.
2. Make the change. A change that adds or alters behavior arrives with a test in `spec/`.
3. Run `bundle exec rake` and fix what it reports.
4. Open a pull request against `main`.

CI runs `bundle exec rake` on Ruby 3.3, 3.4, and 4.0. All three must pass before merge. Pull requests are squash merged, and their titles follow [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/).

## What an acceptable change satisfies

`bundle exec rake` passes: RuboCop with the rules in [.rubocop.yml](.rubocop.yml), Steep against the signatures in [sig/](sig/), and the suite in [spec/](spec/).

## Governance

Leonid Svyatov ([@svyatov](https://github.com/svyatov)) is the only maintainer. He reviews, merges, and releases. No succession is arranged: if he stops, the project stops unless someone forks it.
