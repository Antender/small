class Array

def randomize
    arr=self.dup
    self.collect { arr.slice!(rand(arr.length)) }
end

def randomize!
    self.replace self.randomize
end

def random
    self.randomize.first
end

def randomize2
self.sort_by { rand }
end

def randomize2!
self.replace(randomize)
end

end