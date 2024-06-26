# frozen_string_literal: true

Product = Struct.new(:name, :price)

class Example < Phlex::CSV
	def escape_csv_injection?
		true
	end

	def view_template(product)
		column("name", product.name)
		column("price", product.price)
	end
end

class ExampleWithoutHeaders < Example
	def render_headers?
		false
	end
end

describe Phlex::CSV do
	test "renders a CSV" do
		products = [
			Product.new("Apple", 1.00),
			Product.new("Banana", 2.00),
		]

		csv = Example.new(products).call

		expect(csv) == <<~CSV
			name,price
			Apple,1.0
			Banana,2.0
		CSV
	end

	test "escapes commas" do
		product = Product.new("Apple, Inc.", 1.00)
		csv = Example.new([product]).call

		expect(csv) == <<~CSV
			name,price
			"Apple, Inc.",1.0
		CSV
	end

	test "escapes newlines" do
		product = Product.new("Apple\nInc.", 1.00)
		csv = Example.new([product]).call

		expect(csv) == <<~CSV
			name,price
			"Apple\nInc.",1.0
		CSV
	end

	test "escapes quotes" do
		product = Product.new("Apple\"Inc.", 1.00)
		csv = Example.new([product]).call

		expect(csv) == <<~CSV
			name,price
			"Apple""Inc.",1.0
		CSV
	end

	test "renders without headers" do
		products = [
			Product.new("Apple", 1.00),
			Product.new("Banana", 2.00),
		]

		csv = ExampleWithoutHeaders.new(products).call

		expect(csv) == <<~CSV
			Apple,1.0
			Banana,2.0
		CSV
	end
end
