require "date"

class Todo < ActiveRecord::Base
  def overdue?
    Date.today > due_date
  end

  def due_today?
    Date.today == due_date
  end

  def due_later?
    Date.today < due_date
  end

  def to_displayable_string
    display_status = completed ? "[X]" : "[ ]"
    display_date = due_today? ? nil : due_date
    "#{id} #{display_status} #{todo_text} #{display_date}"
  end

  def self.overdue
    all.where(" due_date< ?", Date.today)
  end

  def self.due_today
    all.where(due_date: Date.today)
  end

  def self.due_later
    all.where("due_date> ?", Date.today)
  end

  def self.show_list
    puts "My Todo-list\n\n\n"
    puts "Overdue\n\n"
    puts overdue.map { |todo| todo.to_displayable_string }

    puts "\n\n\n"
    puts "Due Today\n\n"
    puts due_today.map { |todo| todo.to_displayable_string }
    puts "\n\n\n"

    puts "Due Later\n\n"
    puts due_later.map { |todo| todo.to_displayable_string }
    puts "\n\n\n"
  end

  def self.add_task(task)
    Todo.create!(todo_text: task[:todo_text], due_date: Date.today + task[:due_in_days], completed: false)
  end

  def self.mark_as_complete!(todo_id)
    todo = Todo.find(todo_id)
    todo.completed = true
    todo.save
    Todo.find(todo_id)
  end
end
    
    