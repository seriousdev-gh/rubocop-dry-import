# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Dry::UnusedImport, :config do
  it 'registers an offense for unused imported dependencies' do
    expect_offense(<<~RUBY)
      class FooService
        include Import['service_a', 'service_b']
                       ^^^^^^^^^^^ Imported dependency `service_a` is not used in the class.
        def call
          service_b.call
        end
      end
    RUBY
  end

  it 'does not register offense when all dependencies are used' do
    expect_no_offenses(<<~RUBY)
      class FooService
        include Import['service_a', 'service_b']

        def call
          service_a.call
          service_b.call
        end
      end
    RUBY
  end

  it 'registers an offense when using hash-style import with unused keys' do
    expect_offense(<<~RUBY)
      class FooService
        include Import[
          foo: 'namespace.bar',
          baz: 'other.dep'
          ^^^^^^^^^^^^^^^^ Imported dependency `baz` is not used in the class.
        ]

        def call
          foo.call
        end
      end
    RUBY
  end

  it 'does not register offense when all hash keys are used' do
    expect_no_offenses(<<~RUBY)
      class FooService
        include Import[foo: 'namespace.bar', baz: 'other.dep']

        def call
          foo.call
          baz.call
        end
      end
    RUBY
  end

  context 'with custom config' do
    let(:config) do
      RuboCop::Config.new(
        'Dry/UnusedImport' => { 'InjectorName' => 'AutoInject' }
      )
    end
    it 'respects custom import name from config' do
      expect_offense(<<~RUBY, cop)
        class FooService
          include AutoInject['foo', 'bar']
                             ^^^^^ Imported dependency `foo` is not used in the class.
          def call
            bar.call
          end
        end
      RUBY
    end
  end
end
