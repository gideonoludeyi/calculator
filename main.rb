$operators = %w[+ - * /]

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

def split_by_operators(expr)
  $operators.reduce([expr]) do |components, operator|
    components.flat_map do |e|
      operands = e.split(operator)
      intersperse(operands, operator)
    end
  end
end

def to_rpn(expr)
  expr += ['#']
  ops = ['$']

  postfix = []
  p = 0
  expr.each do |s|
    if $operators.include?(s) or s.eql?('#')
      until priority(s) > priority(ops.last)
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
  evaluations = []
  rpn = to_rpn(split_by_operators(expr)) # reverse polish notation
  rpn.each do |o|
    if $operators.include? o # operator
      first = evaluations.pop # most recent evaluated value
      second = evaluations.pop # second most recent evaluated value
      evaluations.push(apply(o, second, first))
    else
      # operand
      evaluations.push(o.to_f)
    end
  end
  evaluations.pop # the result
end

# puts 'Enter a math expression: '
expression = '2*3-12/4'

puts evaluate expression