# frozen_string_literal: true

require_relative 'lib/rubocop_dry_import/version'

Gem::Specification.new do |spec|
  spec.name                  = 'rubocop-dry-import'
  spec.version               = RuboCopDryImport::VERSION
  spec.authors               = ['seriousdev-gh']
  spec.email                 = ['borisdrovnin@gmail.com']

  spec.summary               = 'RuboCop extension that detects unused dry-rb Import dependencies.'
  spec.description           = 'rubocop-dry-import adds a RuboCop cop (Dry/UnusedImport) that warns when imported ' \
                               'dependencies via dry-rb’s Import or AutoInject are not used within the class.'
  spec.homepage              = 'https://github.com/seriousdev-gh/rubocop-dry-import'
  spec.license               = 'MIT'
  spec.required_ruby_version = '>= 3.2.0'

  spec.metadata['source_code_uri']       = spec.homepage
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      f.start_with?(*%w[bin/ Gemfile .gitignore .rspec spec/ .github/ example/ .rubocop.yml])
    end
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'rubocop', '>= 1.0', '< 2.0'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'
end
