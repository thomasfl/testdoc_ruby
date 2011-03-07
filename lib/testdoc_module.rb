
module TestDoc

  require 'erb'
  require File.dirname(__FILE__) +  '/testdoc/testdocoptions'
  require File.dirname(__FILE__) +  '/testdoc/testdocparser'

  class TestDoc

    GENERATORS = {} # Not in use

    # Name of the dotfile that contains the description of files to be
    # processed in the current directory
    DOT_DOC_FILENAME = ".document"

    # Main method
    def document(argv)

      options = Options.instance
      options.parse(argv, GENERATORS)
      @generated_content = ""

      puts "Title: " + options.title
      @title =  options.title
      header = File.dirname(__FILE__) + "/testdoc/header.html.erb"
      @generated_content = process_template(header, nil) unless options.text
      @progress = $stderr unless options.quiet
      @num_files = 0
      @options = options
      files = options.files
      files = ["."] if files.empty?

      file_list = normalized_file_list(options, files, true)

      template_file = File.dirname(__FILE__) + "/testdoc/template.html.erb"
      if(options.text) then
        template_file = File.dirname(__FILE__) + "/testdoc/template.debug.erb"
      end

      file_list.each do |fn|
        $stderr.printf("\n%35s: ", File.basename(fn)) unless options.quiet
        content = File.open(fn, "r") {|f| f.read}
        testdoc_directives = []
        testdoc_directives = parse_file(content)
        parser = TestDocParser.new(testdoc_directives,File.basename(fn))
        parser.options = options
        testplans = []
        testplans = parser.process_testplan
        if(testplans) then
          @generated_content += process_template(template_file,testplans)
          @num_files += 1
        end

      end

      if(not options.quiet) then
        puts ''
        puts ''
        puts 'Generating TestDoc HTML: testplan.html...'

        puts "Parsed files: #@num_files"
      end

      if( not options.text) then
        footer = File.dirname(__FILE__) + "/testdoc/footer.html.erb"
        @generated_content += process_template(footer, nil)
        output_file = File.new("testplan.html", "w")
        output_file.puts @generated_content
      else
        puts @generated_content
      end

    end

    def process_template(template_file,testplans)
      template = File.open(template_file, "r") {|f| f.read}
      rhtml = ERB.new(template, safe_level = 0, trim_mode = 1 )
      generated_html = rhtml.result(b=binding() ).gsub(/\n\n/,"\n")
    end

    # Exctract comments from file and return it in an array
    def parse_file(content)

      if /\t/ =~ content
        tab_width = Options.instance.tab_width
        content = content.split(/\n/).map do |line|
          1 while line.gsub!(/\t+/) { ' ' * (tab_width*$&.length - $`.length % tab_width)}  && $~ #`
          line
        end .join("\n")
      end
      @content   = content
      @content << "\n" unless @content[-1,1] == "\n"

      testdoc_array = []
      counter = 0

      symbol = nil
      line_number = 0
      content.split(/\n/).map do |line|
        line_number = line_number + 1

        if line =~ /.*#.*@test (.*)/i then
          symbol = :test
          testdoc_array[counter] = [:test,$1.gsub(/^\s+/, ""),line_number]
          counter = counter + 1
        elsif line =~ /.*#.*@task (.*)/i then
          testdoc_array[counter] = [:task,$1.gsub(/^\s+/, ""),line_number]
          counter = counter + 1
          symbol = :task
        elsif line =~ /.*#.*@check (.*)/i then
          testdoc_array[counter] = [:check,$1.gsub(/^\s+/, ""),line_number]
          counter = counter + 1
          symbol = :check
        elsif line =~ /.*#.*@testplan (.*)/i then
          testdoc_array[counter] = [:testplan,$1.gsub(/^\s+/, "") + "#",line_number]
          counter = counter + 1
          symbol = :testplan
        elsif line =~ /.*#(.*)/ && symbol != nil then
          testdoc_array[counter - 1][1] = testdoc_array[counter - 1][1] + " " + $1.gsub(/^ */, ' ')

        else
          symbol = nil
        end

      end

      return testdoc_array
    end

    # Given a list of files and directories, create a list
    # of all the Ruby files they contain.
    def normalized_file_list(options, relative_files, force_doc = false, exclude_pattern=nil)
      file_list = []

      relative_files.each do |rel_file_name|
        next if exclude_pattern && exclude_pattern =~ rel_file_name
        stat = File.stat(rel_file_name)
        case type = stat.ftype
        when "file"
          next if @last_created and stat.mtime < @last_created
          file_list << rel_file_name.sub(/^\.\//, '') ##  if force_doc || ParserFactory.can_parse(rel_file_name)
        when "directory"
          next if rel_file_name == "CVS" || rel_file_name == ".svn"
          # puts "DEBUG: rel_file_name: " + rel_file_name
          dot_doc = File.join(rel_file_name, DOT_DOC_FILENAME)
          if File.file?(dot_doc)
            file_list.concat(parse_dot_doc_file(rel_file_name, dot_doc, options))
          else
            file_list.concat(list_files_in_directory(rel_file_name, options))
          end
        else
          raise TestDocError.new("I can't deal with a #{type} #{rel_file_name}")
        end
      end
      file_list
    end

    # Return a list of the files to be processed in
    # a directory. We know that this directory doesn't have
    # a .document file, so we're looking for real files. However
    # we may well contain subdirectories which must
    # be tested for .document files
    def list_files_in_directory(dir, options)
      normalized_file_list(options, Dir.glob(File.join(dir, "*")), false, options.exclude)
    end

  end

  class TestDocError < Exception
  end

end


