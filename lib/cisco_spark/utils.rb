module Utils
  extend self

  def camelize(obj)
    obj.to_s.split('_').inject([]){ |buffer,e| buffer.push(buffer.empty? ? e : e.capitalize) }.join
  end
end