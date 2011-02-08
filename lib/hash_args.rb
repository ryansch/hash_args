module CoreExtensions #:nodoc:
	module Hash #:nodoc:
		# Allows a Hash to more easily be used to pass arguments to methods.
		module Parameters
			#Works like Hash#fetch with 2 additions.  It will optionally treat nil like a missing key (that's the default).  It will also allow the caller to require a parameter or it will raise an exception.
			def fetch_arg(key, default = nil, opts = {}, &block)
				if opts[:required] == true
					raise ArgumentError, "#{key.to_s.capitalize} required." if not has_key? key
				end

				if not default.nil? or block.nil?
					ret = fetch key, default
				else
					ret = fetch key, &block
				end

				if ret == nil and opts[:ignore_nil] != true
					if opts[:required] == true
						raise ArgumentError, "#{key.to_s.capitalize} required."
					end

					if not block.nil?
						ret = block.call(key)
					else
						ret = default
					end
				end

				if opts[:array] == true and not ret.is_a? Array
					ret = [ret]
				end

				ret
			end

			def fetch_arg_array(key, default = nil, opts = {}, &block)
				opts.merge!(:array => true)
				fetch_arg(key, default, opts, &block)
			end
		end
	end
end

class Hash #:nodoc:
	include CoreExtensions::Hash::Parameters
end
