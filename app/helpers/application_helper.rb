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

		uri = URI('https://archives.albany.edu/history/catalog.json' + search_path)
		#raise uri.path

		req = Net::HTTP::Get.new(uri)

		res = Net::HTTP.start(
			uri.host, uri.port, 
			:use_ssl => uri.scheme == 'https', 
			:verify_mode => OpenSSL::SSL::VERIFY_NONE) do |https|
			https.request(req)
		end

		#response = Net::HTTP.get(url)
		res = JSON.parse(res.body)
		puts res["meta"]["pages"]["total_count"]
		
		return res["meta"]["pages"]["total_count"]
	end

end
