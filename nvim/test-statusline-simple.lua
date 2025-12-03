-- Quick test - run with :luafile %
package.loaded['claude-statusline'] = nil
local c = require('claude-statusline')
local d = c.debug()
print("Active: " .. tostring(d.active))
print("Model: " .. tostring(d.model))
print("Cost: " .. tostring(d.cost))
if d.data then
  print("\nData found!")
  if d.data.model then
    print("  model.display_name = " .. tostring(d.data.model.display_name))
    print("  model.id = " .. tostring(d.data.model.id))
  end
  if d.data.cost then
    print("  cost.total_cost_usd = " .. tostring(d.data.cost.total_cost_usd))
  end
end
