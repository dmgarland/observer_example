module Observable

  def observers
    @observers ||= []
  end

  def add_observer(observer)
    observers << observer
  end

  def notify_observers(event, *args)
    observers.each do |observer|
      observer.call event, *args
    end
  end

end