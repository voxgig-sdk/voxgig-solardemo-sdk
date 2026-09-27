-- VoxgigSolardemo SDK error

local VoxgigSolardemoError = {}
VoxgigSolardemoError.__index = VoxgigSolardemoError


function VoxgigSolardemoError.new(code, msg, ctx)
  local self = setmetatable({}, VoxgigSolardemoError)
  self.is_sdk_error = true
  self.sdk = "VoxgigSolardemo"
  self.code = code or ""
  self.msg = msg or ""
  self.ctx = ctx
  self.result = nil
  self.spec = nil
  return self
end


function VoxgigSolardemoError:error()
  return self.msg
end


function VoxgigSolardemoError:__tostring()
  return self.msg
end


return VoxgigSolardemoError
