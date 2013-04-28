require '../lib/kul'

Kul::RouteListing.new.list_routes.each { |x| puts x }