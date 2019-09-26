local _M = require('apicast.policy').new('Custom Example', '1.0.0')

local new = _M.new

local ipairs = ipairs
local insert = table.insert

function _M.new(configuration)
  local self = new()

  local ops = {}

  local config = configuration or {}
  local set_header = config.set_header or {}

  local global_value = config.global_value or {}

  for _, header in ipairs(set_header) do
    insert(ops, function()
      ngx.log(ngx.WARN, '######CustomExamplePolicy-setting header: ', header.name, ' to: ', header.value)
      ngx.req.set_header(header.name, header.value)
    end)
  end

  self.global_value = global_value
  self.ops = ops

  return self
end


function _M:init()
  -- do work when nginx master process starts
end

function _M:init_worker()
  -- do work when nginx worker process is forked from master
end

function _M:rewrite(context)
  -- change the request before it reaches upstream

  -- Write global_value into the context so other policies or later phases can read it.
  context.global_value = self.global_value
  ngx.log(ngx.WARN, '######CustomExamplePolicy-set context.global_value: ', context.global_value)


  for _,op in ipairs(self.ops) do
    op()
  end
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
