module ApplicationHelper
	require 'net/http'
	
	include Blacklight::LayoutHelperBehavior

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

	def transform_url(original_url)
		if original_url =~ %r{catalog/([^/]+)aspace_([0-9a-f]+)}
			collection_id = $1
			object_id = $2.sub(/^aspace_/, '')
			"https://media.archives.albany.edu/#{collection_id.gsub('-', '.')}/#{object_id}/manifest.json"
		else
			nil
			#raise "Unexpected URL format: #{original_url}"
		end
	end

	# Required for Blacklight 8 compatibility
	def render_document_main_content_partial(document = nil, **args)
		document ||= @document
		render partial: 'catalog/document', locals: { document: document, document_counter: args[:document_counter] }
	end

	def render_document_sidebar_partial(document = nil, **args)
		document ||= @document
		render partial: 'catalog/sidebar', locals: { document: document }
	end

	def render_search_bar(params: nil, q: nil, search_field: nil)
		render 'shared/search_bar', search_params: params || {}
	end

	def advanced_search_path
		'/catalog/advanced'
	end

	def container_classes
		'container'
	end

	def render_page_title
		@page_title || 'History'
	end

	def opensearch_description_tag(app_name, url)
		tag.link(rel: 'search', type: 'application/opensearchdescription+xml', title: app_name, href: url)
	end

	def render_link_rel_alternates(document = nil)
		# Placeholder for grenander compatibility
		# Renders alternate format links if needed
		safe_join([])
	end

	def render_body_class(classes = nil)
		# Renders classes for the body tag
		class_list = ['blacklight', 'blacklight-' + controller_name]
		class_list << classes if classes.present?
		class_list.join(' ')
	end

	def index_presenter(document)
		# Returns a presenter object for index view documents
		Blacklight::DocumentPresenter.new(document, self, blacklight_config.index)
	end

	def show_presenter(document)
		# Returns a presenter object for show view documents
		Blacklight::DocumentPresenter.new(document, self, blacklight_config.show)
	end

end
