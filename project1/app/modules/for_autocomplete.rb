module ForAutocomplete
  def self.included(base)
    base.class_eval do
      scope :for_autocomplete, -> (query) do
        results = where("(name like ?)", "%#{query}%").select('id, name')
        return results.sort_by { |u| u.name.length } if results.any?

        names = query.split(' ')
        names = names.sort_by(&:length).reverse
        results = names.collect { |name| where("(name like ?)", "%#{name}%").select('id, name') }
        results = results.flatten.uniq(&:name)
        results
      end
    end
  end
end
