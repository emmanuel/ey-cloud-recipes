class Chef
  class Recipe
    def app_name
      node[:applications][node[:applications].keys.first]
    end
  end
end