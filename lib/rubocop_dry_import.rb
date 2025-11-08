# frozen_string_literal: true

require_relative 'rubocop_dry_import/version'
require_relative 'rubocop/cop/dry/unused_import'

module RuboCopDryImport
  def self.inject!
    path = File.expand_path(__dir__)
    RuboCop::ConfigLoader.default_configuration = RuboCop::ConfigLoader.default_configuration.merge(
      YAML.safe_load_file(File.join(path, 'config', 'default.yml'), aliases: true)
    )
  end
end
