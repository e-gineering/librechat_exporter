# Changelog

## [2.2.0](https://github.com/e-gineering/librechat_exporter/compare/v2.1.0...v2.2.0) (2025-07-31)


### Features

* add API cost tracking metric with LiteLLM integration ([a42d61c](https://github.com/e-gineering/librechat_exporter/commit/a42d61c51fe7450c5eb52271a8500712ca1cb3b7)), closes [#7](https://github.com/e-gineering/librechat_exporter/issues/7)
* Add metrics for error counts in last 5 minutes ([2bddc4b](https://github.com/e-gineering/librechat_exporter/commit/2bddc4b5d820ae634a8e20de3c3b6fa0bd867e0b))
* add user_email labels to per-model metrics ([8b2d70d](https://github.com/e-gineering/librechat_exporter/commit/8b2d70d9d6645df80204ab99f8381d97ca36d6a1)), closes [#6](https://github.com/e-gineering/librechat_exporter/issues/6)
* **metrics:** implement time-based metrics for enhanced monitoring ([2787bdf](https://github.com/e-gineering/librechat_exporter/commit/2787bdf6b0463aac128d663e829cb942d8a348a3))
* migrate from pip to uv package management ([444cd1c](https://github.com/e-gineering/librechat_exporter/commit/444cd1cf8bb34903ba1cea303700dabd8aecd5dd))


### Bug Fixes

* Correct typo in collect_registered_user_count method name ([7152478](https://github.com/e-gineering/librechat_exporter/commit/7152478df872e46ea3384c15c6e8433b451edca9))
* linting errors ([9e337b3](https://github.com/e-gineering/librechat_exporter/commit/9e337b3b4c5f9ab8e5dcb39068ae41756c0f1b79))
* linting errors ([2f22128](https://github.com/e-gineering/librechat_exporter/commit/2f221280d2c1fc9a8ea56d9753fdfc5ab4bfc452))


### Documentation

* add comprehensive CLAUDE.md for future development ([2ec3881](https://github.com/e-gineering/librechat_exporter/commit/2ec388192cfdc83abedaed51390b65f77b4dd93f))


### Miscellaneous

* build and publish multi-arch container images for amd64 and arm64 ([4edbd6c](https://github.com/e-gineering/librechat_exporter/commit/4edbd6c257291ac1d5239540f455d20f70fbc6cb))
* build and publish multi-arch container images for amd64 and arm64 platforms ([d6f41ff](https://github.com/e-gineering/librechat_exporter/commit/d6f41ffa30a3449f137b2ec0bfde8381f9cf02f7))


### Code Refactoring

* Change librechat_registered_users_total to Gauge ([67dad32](https://github.com/e-gineering/librechat_exporter/commit/67dad32578ece4f3e61188a49763764597f3a97e))
* **metrics:** change metrics from Gauge to Counter for better tracking ([3b278dd](https://github.com/e-gineering/librechat_exporter/commit/3b278dd97d4b5995c8c05bfc50381214b27b2cbe))


### Continuous Integration

* add release-please configuration for automated releases ([3579ef9](https://github.com/e-gineering/librechat_exporter/commit/3579ef9736364ba3d102094c6477f1fe7eafc93e))
* add renovate configuration for automated dependency updates ([742cb8d](https://github.com/e-gineering/librechat_exporter/commit/742cb8d2df0569e110e804c70d35075dcff50ade))
* allow ty type checker to fail in pre-alpha ([f422fb0](https://github.com/e-gineering/librechat_exporter/commit/f422fb0fca725c4da0853fc5b9fd89df312d1457))
* migrate from flake8/bandit to ruff and add ty type checker ([dfcc92d](https://github.com/e-gineering/librechat_exporter/commit/dfcc92d79be0e5c6c464d84bfb6bc17031459c2f))
