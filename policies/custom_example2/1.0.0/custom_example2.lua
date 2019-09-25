local _M = require('apicast.policy').new('Custom Example2', '1.0.0')

local new = _M.new

local ipairs = ipairs
local insert = table.insert


function _M.new(configuration)
  local self = new()

  local config = configuration or {}

  return self
end


function _M:init()
  -- do work when nginx master process starts
end

function _M:init_worker()
  -- do work when nginx worker process is forked from master
end

function _M:rewrite()
  -- change the request before it reaches upstream
  ngx.log(ngx.NOTICE, '################CustomExamplePolicy2') 
  ngx.log(ngx.NOTICE, '################CustomExamplePolicy2-global_value', ngx.ctx.global_value) 

  ngx.log(ngx.NOTICE, '########global_value: ', ngx.ctx.global_value, ' headers: ', ngx.req.get_headers())  

end

function _M:access()
  -- ability to deny the request before it is sent upstream
end

function _M:content()
  -- can create content instead of connecting to upstream
end

function _M:post_action()
  -- do something after the response was sent to the client
end

function _M:header_filter()
  -- can change response headers
end

function _M:body_filter()
  -- can read and change response body
  -- https://github.com/openresty/lua-nginx-module/blob/master/README.markdown#body_filter_by_lua
end

function _M:log()
  -- can do extra logging
end

function _M:balancer()
  -- use for example require('resty.balancer.round_robin').call to do load balancing
end

return _M
