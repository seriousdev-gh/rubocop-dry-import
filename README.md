# RuboCop Dry Import

A custom [RuboCop](https://github.com/rubocop/rubocop) extension that detects **unused `Import` dependencies** in classes using [dry-rb’s dependency injection](https://dry-rb.org/gems/dry-auto_inject/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rubocop-dry-import', require: false
```

## Usage

Add the extension to your `.rubocop.yml`:

```yaml
require:
  - rubocop-dry-import

Dry/UnusedImport:
  Enabled: true
  ImportName: 'Import' # Optional, defaults to "Import"
```

Run RuboCop as usual:

```bash
bundle exec rubocop
```

## Example

```ruby
class FooService
  include Import['service_a', 'service_b']

  def call
    service_b.call
  end
end
```

**Offense:**
```
Include Import['service_a', 'service_b']
               ^^^^^^^^^^^ Imported dependency `service_a` is not used in the class.
```

**Autocorrect:** Not available (yet).

## Development

Clone and setup:

```bash
git clone https://github.com/seriousdev-gh/rubocop-dry-import
cd rubocop-dry-import
bundle install
```

Run tests:

```bash
bundle exec rspec
```

Run RuboCop locally:

```bash
bundle exec rubocop --require rubocop-dry-import path/to/file.rb
```

## Contributing

1. Fork the project.
2. Create your feature branch (`git checkout -b feature/new-cop`).
3. Commit your changes (`git commit -am 'Add new cop'`).
4. Push to the branch (`git push origin feature/new-cop`).
5. Open a Pull Request.

## License

This project is licensed under the [MIT License](LICENSE).

