module HamlsComment
  Haml::Engine.class_eval do
    alias_method :initialize_without_file_comments, :initialize

    def initialize(template, options ={})
      template = template.dup
      append_template = true
      non_commentable_directories = %w{layouts templates components}
      non_commentable_directories.each do |dir|
        append_template = false if options[:filename].to_s.include?("#{dir}/")
      end
      if append_template
        template.insert(0,"/ START #{options[:filename]}\n")
        template.insert(-1,"\n/ END #{options[:filename]}")
      end
      template.freeze
      initialize_without_file_comments(template, options)
    end

  end if Rails.env.development?
end
