module ApplicationHelper
	require 'net/http'

	def source_name
      'UAlbany History'
    end

	def subject_options
		config=YAML.load_file(Rails.root.join("config/subjects.yml"))

		config.each do |subject, url|
			subject
			url
		end
	end

	def decade_counter(search_path, decade_start, decade_end)

		url = URI('https://archives.albany.edu/history/catalog.json' + search_path)
		response = Net::HTTP.get(url)
		res = JSON.parse(response)
		
		return res["meta"]["pages"]["total_count"]
	end

end
