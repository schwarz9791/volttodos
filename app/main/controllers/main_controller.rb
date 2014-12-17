class MainController < Volt::ModelController
  model :page

  def index
    # Add code for when the index view is loaded
  end

  def about
    # Add code for when the about view is loaded
  end

  def todos
    self.model = :store

    u = Volt.user._id if Volt.user?
    _todos.find(owner: u).then do |mytodos|
      self._todos = mytodos
    end
  end

  def owner(todo)
    store._users.find_one(_id: todo._owner)._name
  end

  def created_at(todo)
    todo._created_at
  end

  def add_todo
    if Volt.user then
      _todos << { name: _new_todo, owner: Volt.user._id, created_at: Time.now, updated_at: Time.now }
    end
   store._new_todo = '' 
  end

  def remove_todo(todo)
    _todos.delete(todo)
  end

  def current_todo
    if _todos then
      _todos[params._index.or(0).to_i]
    end
  end

  def check_all
    _todos.each { |todo| todo._completed = true }
  end

  def completed
    _todos.count { |todo| todo._completed }
  end

  def incomplete
    _todos.size - completed
  end

  def percent_complete
    return (( completed.or(0) / _todos.size.to_f ) * 100.0).round
  end
  # end

  private

  # the main template contains a #template binding that shows another
  # template.  This is the path to that template.  It may change based
  # on the params._controller and params._action values.
  def main_path
    params._controller.or('main') + '/' + params._action.or('index')
  end

end
