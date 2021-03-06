# A complex number is a number represented in the form a + bi. In this form, 
# a and b are real numbers, and i is an imaginary number such as i² = -1. 
# The a is the real part of the number, and the b is the imaginary part of 
# the number.
#
# ```
# Complex.new(1, 0)   # => 1 + 0i
# Complex.new(5, -12) #  => 5 - 12i
# ```
struct Complex
  #  Returns the real part of self
  getter real : Float64

  # Returns the image part of self
  getter imag : Float64

  def initialize(real : Number, imag : Number)
    @real = real.to_f
    @imag = imag.to_f
  end

  # Determines whether self equals *other* or not
  def ==(other : Complex)
    @real == other.real && @imag == other.imag
  end

  # ditto
  def ==(other : Number)
    self == other.to_c
  end

  # ditto
  def ==(other)
    false
  end

  # Write this complex object to an io
  #
  # ```
  # Complex.new(42, 2).to_s # => 42 + 2i
  # ```
  def to_s(io : IO)
    io << @real
    io << (@imag >= 0 ? " + " : " - ")
    io << @imag.abs
    io << "i"
  end

  # Returns the absolute value of this complex number in a
  # number form, using the Pythagorean theorem.
  #
  # ```
  # Complex.new(42, 2).abs  # => 42.0476
  # Complex.new(-42, 2).abs # => 42.0476
  # ```
  def abs
    Math.hypot(@real, @imag)
  end

  # Returns the square of absolute value in a number form.
  #
  # ```
  # Complex.new(42, 2).abs2 # => 1768
  # ```
  def abs2
    @real * @real + @imag * @imag
  end

  def sign
    self / abs
  end

  # Returns the phase of self
  def phase
    Math.atan2(@imag, @real)
  end

  # Returns a tuple with the abs value and the phase.
  #
  # ```
  # Complex.new(42, 2).polar # => {2.54311, 0.665774}
  # ```
  def polar
    {abs, phase}
  end

  # Returns the conjugate of self
  #
  # ```
  # Complex.new(42, 2).conj  # => 42 - 2i
  # Complex.new(42, -2).conj # => 42 + 2i
  # ```
  def conj
    Complex.new(@real, -@imag)
  end

  # Returns the inverse of self
  def inv
    conj / abs2
  end

  # Complex.sqrt was inspired by the following blog post of Pavel Panchekha on floating point precision:
  # https://pavpanchekha.com/casio/index.html
  def sqrt
    r = abs

    re = if @real >= 0
           0.5 * Math.sqrt(2.0 * (r + @real))
         else
           @imag.abs / Math.sqrt(2 * (r - @real))
         end

    im = if @real <= 0
           0.5 * Math.sqrt(2.0 * (r - @real))
         else
           @imag.abs / Math.sqrt(2 * (r + @real))
         end

    if @imag >= 0
      Complex.new(re, im)
    else
      Complex.new(re, -im)
    end
  end

  # Calculates the exp of self
  #
  # ```
  # Complex.new(4, 2).exp #  => -22.7208 + 49.646i
  # ```
  def exp
    r = Math.exp(@real)
    Complex.new(r * Math.cos(@imag), r * Math.sin(@imag))
  end

  # Calculates the log of self
  def log
    Complex.new(Math.log(abs), phase)
  end

  # Calculates the log2 of self
  def log2
    log / Math::LOG2
  end

  # Calculates the log10 of self
  def log10
    log / Math::LOG10
  end

  # Adds the value of self to *other*
  def +(other : Complex)
    Complex.new(@real + other.real, @imag + other.imag)
  end

  # ditto
  def +(other : Number)
    Complex.new(@real + other, @imag)
  end

  #  Returns the opposite of self
  def -
    Complex.new(-@real, -@imag)
  end

  # Removes the value from *other* to self
  def -(other : Complex)
    Complex.new(@real - other.real, @imag - other.imag)
  end

  # ditto
  def -(other : Number)
    Complex.new(@real - other, @imag)
  end

  # Multiplies self by *other*
  def *(other : Complex)
    Complex.new(@real * other.real - @imag * other.imag, @real * other.imag + @imag * other.real)
  end

  # ditto
  def *(other : Number)
    Complex.new(@real * other, @imag * other)
  end

  # Divides self by *other*
  def /(other : Complex)
    if other.real <= other.imag
      r = other.real / other.imag
      d = other.imag + r * other.real
      Complex.new((@real * r + @imag) / d, (@imag * r - @real) / d)
    else
      r = other.imag / other.real
      d = other.real + r * other.imag
      Complex.new((@real + @imag * r) / d, (@imag - @real * r) / d)
    end
  end

  #  ditto
  def /(other : Number)
    Complex.new(@real / other, @imag / other)
  end

  # Returns the number 0 in complex form
  def self.zero
    new 0, 0
  end
end

struct Number
  def to_c
    Complex.new(self, 0)
  end

  def i
    Complex.new(0, self)
  end

  def ==(other : Complex)
    to_c == other
  end

  def cis
    Complex.new(Math.cos(self), Math.sin(self))
  end

  def +(other : Complex)
    Complex.new(self + other.real, other.imag)
  end

  def -(other : Complex)
    Complex.new(self - other.real, -other.imag)
  end

  def *(other : Complex)
    Complex.new(self * other.real, self * other.imag)
  end

  def /(other : Complex)
    self * inv(other)
  end
end
