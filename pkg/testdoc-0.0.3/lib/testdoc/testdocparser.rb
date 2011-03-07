# TestDocParser

class TestPlan
  attr_accessor :tests, :title, :comments
end


class TestItem
    attr_accessor :tasks, :title, :id, :number_of_checks, :checks_tasks_count
end

class Task
  attr_accessor :checks, :title, :id
end

class Check
  attr_accessor :title, :id
end

class TestDocParser

  attr_accessor :options

  def initialize(lines,filename)
    @lines = lines
    @filename = filename
    @line_counter = 0
    read_line()
    @progress = $stderr
  end

  def error(msg)
    puts @filename + ":" + @src_line_number.to_s + " Error: " + msg
    puts "  # " + @tag.to_s + ":" + @param
    exit(0)
  end

  def read_line
    src_line = @lines[@line_counter]
    if src_line == nil then
      @tag = ""
      @param = ""
      return false
    end
    @tag = src_line[0]
    @param = src_line[1]
    @src_line_number = src_line[2]
    @line_counter = @line_counter + 1
    return true
  end

  def progress(char)
    unless @options.quiet
      @progress.print(char)
      @progress.flush
    end
  end


  # Directive 'testplan:' is optional, but is expected to be first.
  def process_testplan
    testplans = []
    @testplans_counter = 0

    if(@tag == :testplan) then
      testplan = TestPlan.new
      testplan.title = @param.split("#")[0]
      testplan.comments = @param.split("#")[1]
      read_line()
    else
      testplan = TestPlan.new
    end
    testplan.tests = process_tests()
    testplans[@testplans_counter] = testplan
    @testplans_counter += 1

    # count number of tasks and checks for each test
    # for setting correct rowspan in html
    if (testplans == nil)
      return nil
    end
    testplans.each do |testplan|
      if (testplan.tests == nil)
        return nil
      end
      testplan.tests.each do |test|
        checks_tasks_count = 0

        test.tasks.each do |task|
          if(task.checks.size == 0)
            checks_tasks_count += 1
          end
          task.checks.each do |check|
            checks_tasks_count += 1
          end
        end
        # number_of_checks is an alias for checks_tasks_count
        test.number_of_checks = checks_tasks_count.to_s
        test.checks_tasks_count = checks_tasks_count.to_s
      end
    end

    # return parsed testplan
    return testplans
  end

  def process_tests
    tests = []
    @tests_counter = 0
    if (@tag == :test)
      while(@tag == :test ) do
        progress("t")
        test = TestItem.new()
        test.title = @param
        test.id = (@tests_counter + 1).to_s
        read_line()

        test.tasks = process_tasks
        tests[@tests_counter] = test
        @tests_counter += 1
      end
      return tests
    else
      progress("-")
      # progress("Warning: no directives found")
      ## error("Could not find any 'test:' directives.")
      return nil
    end
  end

  def process_tasks
    tasks = []
    @tasks_counter = 0
    if(@tag == :check) then
      error("Excepted 'task:' directive before 'check:' directive.")
    end
    while(@tag == :task) do
      progress(".")
      task = Task.new
      task.title = @param
      task.id = (@tests_counter + 1).to_s + "." + (@tasks_counter + 1).to_s
      read_line()

      task.checks = process_checks
#       # pad tree with 'empty' checks
#       if(task.checks.size == 0)then
#         checks = []
#         check = Check.new
#         check.title = "- Empty -"
#         check.id = "0"
#         checks[0] = check
#         task.checks = checks
#       end
      tasks[@tasks_counter] = task
      @tasks_counter += 1
    end
    return tasks
  end


  def process_checks
    checks = []
    @checks_counter = 0
    while(@tag == :check) do
      progress("c")
      check = Check.new
      check.title = @param
      check.id = (@tests_counter + 1).to_s
      check.id = check.id + "." + (@tasks_counter + 1).to_s
      check.id = check.id + "." + (@checks_counter + 1).to_s
      checks[@checks_counter] = check
      @checks_counter += 1
      read_line()
    end
    return checks
  end

end
