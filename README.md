### Hexlet tests and linter status:
[![Actions Status](https://github.com/qsimpleq/rails-project-66/workflows/hexlet-check/badge.svg)](https://github.com/qsimpleq/rails-project-66/actions)
[![CI](https://github.com/qsimpleq/rails-project-66/actions/workflows/ci.yml/badge.svg)](https://github.com/qsimpleq/rails-project-66/actions/workflows/ci.yml)

# Github Repository Quality Analyzer

A study project that helps to automatically monitor the quality of repositories on Github.
It tracks changes and runs them through the built-in parsers.
Then it generates reports and sends them to the user.

Supported languages: javascript, ruby

Link to service demo: [example-github-quality](https://example-github-quality.qsimpleq.su)

Deployed with self-hosted [dokku](https://dokku.com)

## Local development
```shell
make setup
make envfile
```
Put your github credentials to .env file and run
```shell
make dev
```

### Extra commands
```shell
make lint
make test
make test-lint
make lint-test
```

Run erb2slim with rubocop autofixer:
```shell
make fixer
```
