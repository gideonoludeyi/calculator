$operators = %w[+ - * /]

class Stack
  def push(item)
    @top = Node.new(item, @top)
  end

  def pop
    item = @top.item
    @top = @top.next
    item
  end

  def top
    @top&.item
  end

  def empty
    @top.nil?
  end

  def each
    node = @top
    until node.nil?
      yield node.item
      node = node.next
    end
  end

  def to_s
    s = ''
    each do |x|
      s += "#{x} "
    end
    "[#{s.strip}]"
  end

  class Node
    attr_accessor :item, :next

    def initialize(item, node)
      @item = item
      @next = node
    end
  end
end

def priority(char)
  case char
  when '*', '/'
    2
  when '+', '-'
    1
  when '#'
    0
  when '$'
    -1
  else
    0
  end
end

def intersperse(xs, v)
  arr = [xs[0]]
  xs[1..].each do |x|
    arr.push(v, x)
  end
  arr
end

def split(expr)
  components = [expr]
  $operators.each do |operator|
    components = components.flat_map do |e|
      operands = e.split(operator)
      intersperse(operands, operator)
    end
  end
  components
end

def to_rpn(expr)
  expr += ['#']
  ops = Stack.new
  ops.push('$')

  postfix = []
  p = 0
  expr.each do |s|
    if $operators.include?(s) or s.eql?('#')
      until priority(s) > priority(ops.top)
        postfix[p] = ops.pop
        p += 1
      end
      ops.push(s)
    else
      # operands
      postfix[p] = s
      p += 1
    end
  end
  postfix
end

def apply(op, x, y)
  case op
  when '+'
    x + y
  when '-'
    x - y
  when '*'
    x * y
  when '/'
    x / y
  else
    throw "Invalid operator"
  end
end

def evaluate(expr)
  stack = Stack.new
  rpn = to_rpn(split(expr)) # reverse polish notation
  rpn.each do |o|
    if $operators.include? o # operator
      first = stack.pop # most recent
      second = stack.pop # second recent
      stack.push(apply(o, second, first))
    else
      # operand
      stack.push(o.to_f)
    end
  end

  stack.pop # the result
end

# puts 'Enter a math expression: '
expression = '2*3-12/4'

puts evaluate expression
