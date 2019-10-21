# https://stackoverflow.com/questions/3135575/programmatically-derive-a-regular-expression-from-a-string
# by Joc

LOOP_COUNT = 100

class Attempt

  # let's try email
  HITS    = %w[j@j.com j@j.co.uk gates@microsoft.com sales@microsoft.com sjobs@apple.com sales@apple.com frddy@aol.com thing1@charity.org sales@mybad.org.uk thing.one@drseuss.com]
  MISSES  = %w[j@j j@j@.com j.com @domain.com nochance eric@google. eric@google.com. username-at-domain-dot-com linux.org eff.org microsoft.com sjobs.apple.com www.apple.com]

  # odd mixture of numbers and letters, designed to confuse
  # HITS = %w[a123 a999 a600 a545 a100 b001 b847 a928 c203]
  # MISSES = %w[abc def ghi jkl mno pqr stu vwx xyz h234 k987]

  # consonants versus vowels
  # HITS = %w[bcd cdb fgh ghf jkl klj mnp npm qrs srq tvw vwt xzb bzx]
  # MISSES = %w[aei oyu oio euu uio ioe aee ooo]

  # letters < 11 chars and no numbers
  # HITS = %w[aaa aaaa abaa azaz monkey longstring stringlong]
  # MISSES = %w[aa aa1 aa0 b9b 6zz longstringz m_m ff5 666 anotherlongstring]

  MAX_SUCCESSES = HITS.size + MISSES.size

  # Setup the various Regular Expression operators, etc..
  RELEMENTS = %w[. ? * + ( ) \[ \] - | ^ $ \\ : @ / { }]
  %w[A b B d D S s W w z Z].each do |chr|
    RELEMENTS << "\\#{chr}"
  end
  %w[alnum alpha blank cntrl digit lower print punct space upper xdigit].each do |special|
    RELEMENTS << "[:#{special}:]"
  end
  ('a'..'z').each do |chr|
    RELEMENTS << chr
  end
  ('A'..'Z').each do |chr|
    RELEMENTS << chr
  end
  (0..9).each do |chr|
    RELEMENTS << chr.to_s
  end

  START_SIZE = 8

  attr_accessor :operators, :successes

  def initialize(ary = [])
    @operators = ary
    if ary.length < 1
      START_SIZE.times do
        @operators << random_op
      end
    end
    @score = 0
    @decay = 1
    make_regexp
  end

  def make_regexp
    begin
      @regexp = Regexp.new( @operators.join("") )
    rescue
      # "INVALID Regexp"
      @regexp = nil
      @score = -1000
    end
  end

  def random_op
    RELEMENTS[rand(RELEMENTS.size)]
  end

  def decay
    @decay -= 1
  end

  def test
    @successes = 0
    if @regexp
      HITS.each do |hit|
        result = (hit =~ @regexp)
        if result != nil
          reward
        end
      end
      MISSES.each do |miss|
        result = (miss =~ @regexp)
        if result == nil
          reward
        end
      end
    end
    @score = @successes
    self
  end

  def reward
    @successes += 1
  end

  def cross other
    len = size
    olen = other.size
    split = rand(len)
    ops = []
    @operators.length.times do |num|
      if num < split
        ops << @operators[num]
      else
        ops << other.operators[num + (olen - len)]
      end
    end
    Attempt.new ops
  end

  # apply a random mutation, you don't have to use all of them
  def mutate
    send [:flip, :add_rand, :add_first, :add_last, :sub_rand, :sub_first, :sub_last, :swap][rand(8)]
    make_regexp
    self
  end

  ## mutate methods
  def flip
    @operators[rand(size)] = random_op
  end
  def add_rand
    @operators.insert rand(size), random_op
  end
  def add_first
    @operators.insert 0, random_op
  end
  def add_last
    @operators << random_op
  end
  def sub_rand
    @operators.delete_at rand(size)
  end
  def sub_first
    @operators.delete_at 0
  end
  def sub_last
    @operators.delete_at size
  end
  def swap
    to = rand(size)
    begin
      from = rand(size)
    end while to == from
    @operators[to], @operators[from] = @operators[from], @operators[to]
  end

  def regexp_to_s
    @operators.join("")
  end

  def <=> other
    score <=> other.score
  end

  def size
    @operators.length
  end

  def to_s
    "#{regexp_to_s} #{score}"
  end

  def dup
    Attempt.new @operators.dup
  end

  def score
    if @score > 0
      ret = case
      when (size > START_SIZE * 2)
        @score-20
      when size > START_SIZE
        @score-2
      else
        @score #+ START_SIZE - size
      end
      ret + @decay
    else
      @score + @decay
    end
  end

  def == other
    to_s == other.to_s
  end

  def stats
    puts "Regexp #{@regexp.inspect}"
    puts "Length #{@operators.length}"
    puts "Successes #{@successes}/#{MAX_SUCCESSES}"
    puts "HITS"
    HITS.each do |hit|
      result = (hit =~ @regexp)
      if result == nil
        puts "\tFAIL #{hit}"
      else
        puts "\tOK #{hit} #{result}"
      end
    end
    puts "MISSES"
    MISSES.each do |miss|
      result = (miss =~ @regexp)
      if result == nil
          puts "\tOK #{miss}"
        else
          puts "\tFAIL #{miss} #{result}"
      end
    end
  end

end

$stderr.reopen("/dev/null", "w") # turn off stderr to stop streams of bad rexexp messages

# find some seed attempt values
results = []
10000.times do
  a = Attempt.new
  a.test
  if a.score > 0
    # puts "#{a.regexp_to_s} #{a.score}"
    results << a
  end
end

results.sort!.reverse!

puts "SEED ATTEMPTS"
puts results[0..9]

old_result = nil

LOOP_COUNT.times do |i|
  results = results[0..9]
  results.map {|r| r.decay }
  3.times do
    new_results = results.map {|r| r.dup.mutate.test}
    results.concat new_results
    new_results = results.map {|r| r.cross( results[rand(10)] ).test }
    results.concat new_results
  end
  new_results = []
  20.times do
    new_results << Attempt.new.test
  end
  results.concat new_results
  results.sort!.reverse!
  if old_result != results[0].score
    old_result = results[0].score
  end
  puts "#{i}   #{results[0]}"
end
puts "\n--------------------------------------------------"
puts "Winner! #{results[0]}"
puts "--------------------------------------------------\n"
results[0].stats