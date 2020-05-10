abstract type Expression end
abstract type Statement end

struct Program
  statements::Array{Statement}
end
