class SystemSetting < RailsSettings::CachedSettings
	cache_prefix { Rails.env }

	class << self
		def _vars
			vars = {}
			self.all.map{|s| vars[s.var] = s.value}
			vars
		end
	end
end
