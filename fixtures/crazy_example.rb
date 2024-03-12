module SomeNamespace
	class CrazyComponent < Phlex::HTML
		def initialize(name)
			@name = name
		end

		def template
			article do
				h1 { "Hello, #{@name}" }
				yield
			end
		end
	end
end
