# MODULES

module Menu

	def menu
		" 		
		1 --- Add Task
		2 --- Show Task List
		3 --- Update Task
		4 --- Delete Task
		5 --- Write to a File
		6 --- Read from a File
		7 --- Toggle Status
		Q --- Quit 

		"
	end

	def show_menu
		menu
	end

end

module Promptable

	def prompt(message = 'What would you like to do?', symbol = ':>')
		print message
		print symbol
		gets.chomp
	end
end



# LIST

class List

	attr_reader :all_tasks

	def initialize
		@all_tasks = []
	end	

	def add(task)
		all_tasks << task
	end

	def show
		all_tasks.map.with_index { |l, i| "(#{i.next}): #{l}"} # iterating through the all_tasks array, tasks are listed in the given format
		#all_tasks.each { |task| p task.description} # / EARLIER VERSION different from instructions on codecademy
	end

	def update(task_number, task)
		all_tasks[task_number - 1] = task
	end

	def delete(task_number)
		all_tasks.delete_at(task_number - 1)
	end

	def write_to_file(filename) #outputs each of the tasks on a new line. You can use the write method in the IO class. 
		machinified = @all_tasks.map(&:to_machine).join("\n") #string saved in a variable before passed to IO.write
		IO.write(filename, machinified)		#The string outputs each task in all_tasks on a new line. to_mashine method to be used on each task we output.
		#IO.write(filename, @all_tasks.map(&:to_s).join("\n")) / EARLIER VERSION BEFORE TASK STATUS WAS ADDED
	end

	def read_from_file(filename)
		IO.readlines(filename).each do |line|
			status, *description = line.split(':') #two parts of data to be separated when colon comes
			status = status.downcase.include?('x')
			add(Task.new(description.join(':').strip, status))
			#add(Task.new(line.chomp)) / EARLIER VERSION BEFORE TASK STATUS WAS ADDED
		end
	end

	def toggle(task_number) #call the toggle_status method on the appropriate task from the all_tasks array.
		all_tasks[task_number - 1].toggle_status
	end
end

# TASK

class Task

	attr_reader :description
	attr_accessor :completed_status

	def initialize(description, completed_status = false)
		@description = description
		@completed_status = completed_status
	end

	def to_s
		"#{description} #{represent_status} "
		#description / EARLIER VERSION
	end	

	def completed? #We now have a way to call the completed? method on a Task object to check its completed status.
		completed_status
	end
	
	def toggle_status #negate the completed? method, and set it to the new instance variable
		@completed_status = !completed?
	end

	def to_machine #This method display both the represent_status method and the description, separated by a colon.
		"#{represent_status} : #{description}"
	end


	private
	def represent_status
		completed? ? '[X]' : '[ ]'
	end
	
end

# PROGRAM RUNNER

if "todo.rb" == $PROGRAM_NAME
	include Menu
	include Promptable
	my_list = List.new

	puts "Welcome to your Todo List! This menu will help you use the Task List System."

	#puts "Please choose from the following list."
	#puts menu.show
	#user_input = gets.chomp

	until ['q'].include?(user_input = prompt(show_menu).downcase) # use prompt of Promptable module and show menu from Menu module
	
		case user_input
			when '1' 
				my_list.add(Task.new(prompt('What is the task you would like to accomplish?'))) # use prompt of Promptable module this time with another message
				puts 'Task has been added.'
			when '2' 
				puts my_list.show
			when '3'
				puts my_list.show
				my_list.update(prompt('Which task to update?').to_i,
				Task.new(prompt('What is the new task description?')))
				puts 'Task has been updated.'
			when '4'
				puts my_list.show
				my_list.delete(prompt('Which task number to delete?').to_i)
				puts 'Task has been deleted.'
				#puts my_list.show
			when '5'
				my_list.write_to_file(prompt('What is the filename to write to?'))
				puts 'File has been updated.'
			when '6'
				begin
					my_list.read_from_file(prompt('What is the filename to read from?'))
				rescue Errno::ENOENT
					puts 'File not found. Please verify your filename and path.'
				end
			when '7'
				puts my_list.show
				my_list.toggle(prompt('Which task status to toggle?').to_i)
				puts "Status has been changed."
			else 
				puts "Sorry, I didn't understand. Try again."
		end
		#prompt('Press enter to continue', '')
	end

	puts 'Thanks for using the menu system.'

end


	
=begin	

	puts "You have created a new list."
	my_list.add(Task.new('Make breakfast'))
	puts "You have added a task to the Todo List."
	my_list.add(Task.new('Do shopping'))
	puts "You have added a task to the Todo List."
	my_list.add(Task.new('Wash breakfast dishes'))
	puts "You have added a task to the Todo List."
    puts 'Your task list: '
	puts my_list.show

=end



