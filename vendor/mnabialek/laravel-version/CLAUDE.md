# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Laravel Version is a lightweight PHP library for detecting Laravel/Lumen framework versions. It provides a simple API to:
- Determine if the application is Laravel or Lumen
- Get the current framework version
- Compare against minimum version requirements

The library supports Laravel/Lumen versions 5.8 through 11.x across PHP 7.2-8.5.

## Architecture

### Core Structure

The codebase has a simple, single-purpose architecture:

- **src/Version.php**: The main (and only) class that encapsulates all version detection logic
  - Uses dependency injection to receive the Illuminate Container
  - Detects framework type by checking if "Lumen" appears in the version string
  - Parses Lumen version strings using regex pattern `#Lumen\s*\((.*)\)#U`
  - Exposes methods: `isLaravel()`, `isLumen()`, `full()`, `get()`, `min($version)`

- **tests/**: PHPUnit tests with Mockery for mocking the Container
  - Base class: `UnitTestCase` handles Mockery cleanup in tearDown
  - Tests use Orchestra Testbench for Laravel-specific testing

### Multi-Version Support Strategy

This package maintains compatibility across many Laravel/PHP versions simultaneously. The CI matrix tests every combination of Laravel 5.8-11.x with compatible PHP versions. Dependencies are dynamically managed:

- `composer.json` uses broad version constraints (`illuminate/container: 5.*|6.*|7.*|8.*|9.*|10.*|11.*`)
- CI removes PHPUnit/PHPStan from requirements and lets Testbench manage them
- Testbench version is mapped to Laravel version in the CI workflow

## Development Commands

### Using Docker (Recommended for Local Development)

```bash
# Initial setup - builds container and installs dependencies
make setup

# Run tests
make test

# Run tests with HTML coverage report (outputs to build/coverage/)
make test-coverage

# Check code style (PHP CS Fixer - dry run)
make cs-check

# Fix code style automatically
make cs-fix

# Run PHPStan static analysis
make phpstan

# Access container shell
make shell

# Install a composer package
make composer require package/name
```

## Code Style and Quality

### PHP CS Fixer Configuration (.php-cs-fixer.php)

- Uses PSR-12 as base standard
- Short array syntax required
- Single quotes for strings
- Specific spacing rules for concatenation (one space: `$a . $b`)
- Ordered class elements (constants, properties, methods)
- Targets: src/ and tests/

### PHPStan Configuration (phpstan.neon)

- Level 1 analysis
- Targets PHP 8.3+ features
- Excludes tests/Fixtures/
- Output cached to build/phpstan/

## Testing

### Test Execution

- PHPUnit configuration: phpunit.xml
- Test files must end with `Test.php` suffix
- All tests extend `UnitTestCase` which provides Mockery cleanup
- Use Orchestra Testbench for Laravel integration testing

### Running Specific Tests

```bash
# Run a specific test file
vendor/bin/phpunit tests/VersionTest.php

# Run tests with specific filter
vendor/bin/phpunit --filter testMethodName
```

## CI/CD Workflow

The GitHub Actions workflow (.github/workflows/tests.yml) runs:

1. **Code Style Check**: PHP CS Fixer on PHP 8.5
2. **PHPStan Analysis**: Level 1 on PHP 8.5
3. **Test Matrix**: All Laravel/PHP version combinations
4. **Coverage Report**: Uploads to Codecov

Important CI notes:
- Uses Composer 2.2 to avoid security audit blocking
- Removes composer.lock before installing to ensure fresh dependency resolution
- Removes PHPUnit/PHPStan from composer.json (managed by Testbench)
- Uses `--with-all-dependencies` flag to allow dependency downgrades for older versions

## Important Patterns

### Version Detection Strategy

The library distinguishes Laravel from Lumen by checking for "Lumen" in the version string:
- Laravel: Returns version string as-is (e.g., "8.83.27")
- Lumen: Parses from format "Lumen (5.5.2) (Laravel Components 5.5.*)"

### Dependency Injection

The `Version` class receives `Illuminate\Container\Container` via constructor injection. This allows testing with mocked containers and ensures compatibility across all Laravel/Lumen versions.