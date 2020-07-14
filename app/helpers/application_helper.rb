module ApplicationHelper

	def subject_options
		config=YAML.load_file(Rails.root.join("config/subjects.yml"))

		config.each do |subject, url|
			subject
			url
		end
	end

end
