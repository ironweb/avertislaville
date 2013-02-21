class Attribute

  attr_reader :code
  attr_reader :datatype
  attr_reader :description
  attr_reader :datatype_description
  attr_reader :order
  attr_reader :required
  attr_reader :values
  attr_reader :variable

  def initialize(data)
    @code = data['code']
    @datatype = data['datatype']
    @description = data['description']
    @datatype_description = data['datatype_description']
    @order = data['order']
    @required = data['required']
    @values = data['values']
    @variable = data['variable']
  end

end
