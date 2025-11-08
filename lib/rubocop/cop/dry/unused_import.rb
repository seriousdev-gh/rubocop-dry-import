# frozen_string_literal: true

module RuboCop
  module Cop
    module Dry
      class UnusedImport < Base
        MSG = 'Imported dependency `%<name>s` is not used in the class.'

        def_node_matcher :possible_injector_include?, <<~PATTERN
          (send nil? :include
            (send
              (const nil? $_) :[] ...))
        PATTERN

        # search for method calls
        def on_send(node)
          # search for method calls with specific pattern `include <included_const_name>[<...>]`
          possible_injector_include?(node) do |included_const_name|
            next if included_const_name.to_s != injector_name

            injector_call_node = node.arguments.first
            class_node = node.parent

            imported = extract_imported_methods(injector_call_node)
            break if imported.empty?

            unused = filter_unused_imported_methods(class_node, imported.dup)
            unused.each do |name, import_node|
              add_offense(import_node, message: format(MSG, name:))
            end
          end
        end

        private

        def injector_name
          cop_config['InjectorName'] || 'Import'
        end

        def extract_imported_methods(injector_call_node)
          imported_methods = {}

          injector_call_node.arguments.each do |arg|
            case arg.type
            when :str, :sym
              name = arg.value.to_s.split('.').last
              imported_methods[name.to_s] = arg
            when :hash
              arg.pairs.each do |pair_node|
                name = pair_node.key.value
                imported_methods[name.to_s] = pair_node
              end
            end
          end

          imported_methods
        end

        def filter_unused_imported_methods(class_node, imported)
          class_node.each_descendant(:send).each do |node|
            break if imported.empty?

            name = node.method_name.to_s
            imported.delete(name) if imported.key?(name)
          end

          imported
        end
      end
    end
  end
end
