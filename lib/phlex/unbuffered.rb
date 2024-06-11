# frozen_string_literal: true

# @api private
class Phlex::Unbuffered < BasicObject
	def initialize(object)
		@object = object
	end

	def inspect
		"Unbuffered(#{@object.class.name})[object: #{@object.inspect}]"
	end

	# Borrow some important methods from Object
	define_method :__class__,
		::Object.instance_method(:class)

	define_method :__public_send__,
		::Object.instance_method(:public_send)

	def respond_to_missing?(...)
		@object.respond_to?(...)
	end

	def method_missing(name, ...)
		if @object.respond_to?(name)

			__class__.define_method(name) do |*a, **k, &b|
				@object.capture { @object.public_send(name, *a, **k, &b) }
			end

			# Now we've defined this missing method, we can call it.
			__public_send__(name, ...)
		else
			super
		end
	end

	# Forward some methods to the original underlying method
	def call(...)
		@object.call(...)
	end

	def send(...)
		warn "Unbuffered#send is deprecated, use #__send__ instead"
		@object.__send__(...)
	end

	def __send__(...)
		@object.__send__(...)
	end

	def public_send(...)
		@object.public_send(...)
	end
end
