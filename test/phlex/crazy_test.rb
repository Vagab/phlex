require "crazy_example"

class Example < Phlex::HTML
	def template
		SomeNamespace::CrazyComponent("Joel") do
			strong { "This is mad" }
		end
	end
end

describe Example do
	it "renders a crazy example" do
		expect(Example.new.call).to be == %(<article><h1>Hello, Joel</h1><strong>This is mad</strong></article>)
	end
end
