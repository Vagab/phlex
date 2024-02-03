# frozen_string_literal: true

describe Phlex::HTML do
	Phlex::HTML::StandardElements.registered_elements.each do |method_name, tag|
		test "<#{tag}>" do
			component = component_with_template do
				send(method_name.to_s,
					class: "hello",
					data: { foo: 1 }
				) { "content" }
			end

			expect(component.call) == %(<#{tag} class="hello" data-foo="1">content</#{tag}>)
		end
	end

	Phlex::HTML::VoidElements.registered_elements.each do |method_name, tag|
		test "<#{tag}>" do
			component = component_with_template do
				send(method_name.to_s)
			end

			expect(component.call) == "<#{tag}>"
		end
	end
end

def component_with_template(&block)
	Class.new(Phlex::HTML) do
		define_method(:view_template, &block)
	end
end
