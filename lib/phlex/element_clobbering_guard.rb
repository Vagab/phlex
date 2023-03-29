# frozen_string_literal: true

# @api private
module Phlex::ElementClobberingGuard
	def method_added(method_name)
		if method_name[0] == "_" && (element_method_name = method_name[1..]&.to_sym) && element_method?(element_method_name)
			raise Phlex::NameError, "👋 Redefining the method `#{name}##{method_name}` is not a good idea."
		else
			# @type self: Class
			super
		end
	end
end
