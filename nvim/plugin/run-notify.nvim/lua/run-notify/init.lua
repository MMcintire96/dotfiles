local M = {}

vim.notify = require("notify")

function processInp(id, data, name) 
    print(id, data, name)
  --[[ for _, n in ipairs(data) do
    vim.notify("data", "info")
  end ]]
end



M.setup = function(options) 
  --[[ local addr = "/tmp/nrunner.sock"
  local handle = io.popen("nc -lkU /tmp/nrunner.sock &")
  local cb = function(id, data, name) 
    print(id, data, name)
  end
  local sockId = vim.fn.sockconnect("pipe", addr, {rpc = true})
  vim.notify("Connected to " .. addr, "info") ]]
end

M.connect = function(addr)
end

M.Test = function() 
  processInp()
end

M.Connect = function(addr) 

end

return M
