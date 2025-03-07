local a = function(number) {
    a: number
};

local b = function(a) {
  b: a(2)
};

b(a)