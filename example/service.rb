# frozen_string_literal: true

class FooService
  include AutoInject['service_a',
                     'service_b',
                     foo: 'bar',
                     baz: 'asd']
  include Foo[]

  def call
    service_b.call
    baz
  end
end
