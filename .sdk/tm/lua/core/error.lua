-- Solardemo SDK error

local SolardemoError = {}
SolardemoError.__index = SolardemoError


function SolardemoError.new(code, msg, ctx)
  local self = setmetatable({}, SolardemoError)
  self.is_sdk_error = true
  self.sdk = "Solardemo"
  self.code = code or ""
  self.msg = msg or ""
  self.ctx = ctx
  self.result = nil
  self.spec = nil
  return self
end


function SolardemoError:error()
  return self.msg
end


function SolardemoError:__tostring()
  return self.msg
end


return SolardemoError
