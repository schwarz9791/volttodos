class MainController < Volt::ModelController
  self.model :store

  def index
    # Add code for when the index view is loaded
  end

  def about
    # Add code for when the about view is loaded
  end

  def todos
    if Volt.user then
      _todos.find(user_id: Volt.user._id).then do |mytodos|
        self._todos = mytodos
      end
    end
  end

  def owner(todo)
    store._users.find_one(_id: todo._user_id)._name
  end

  def created_at(todo)
    todo._created_at
  end

  def add_todo
    self._todos << { name: _new_todo, user_id: Volt.user._id, created_at: Time.now, updated_at: Time.now }
    store._new_todo = ''
  end

  def remove_todo(todo)
    self._todos.delete(todo)
  end

  def current_todo
    self._todos[params._index.or(0).to_i]
  end

  def check_all
    self._todos.each { |todo| todo._completed = true }
  end

  def completed
    self._todos.count { |todo| todo._completed }
  end

  def incomplete
    self._todos.size - completed
  end

  def percent_complete
    return (( completed.or(0) / self._todos.size.to_f ) * 100.0).round
  end

  private

  # the main template contains a #template binding that shows another
  # template.  This is the path to that template.  It may change based
  # on the params._controller and params._action values.
  def main_path
    params._controller.or('main') + '/' + params._action.or('index')
  end

end
