local interface = wrap.CInterface.new()
print("CURRENT")
print(arg[0])
print("HHQ")
package.path=package.path..';/home/robotbase/workspace/torch7-android/torch-android/src/pkg/torch/torchcwrap.lua;'
--/home/robotbase/workspace/torch7-android/torch-android/src/pkg/torch
print(package.path)
require('torchcwrap')

interface:print(
   [[
#include "luaT.h"
#include "TH.h"
   ]])

for _,name in ipairs({"seed", "initialSeed"}) do
   interface:wrap(name,
                  string.format("THRandom_%s",name),
                  {{name="long", creturned=true}})
end

interface:wrap('manualSeed',
               'THRandom_manualSeed',
               {{name="long"}})

interface:register("random__")
                
interface:print(
   [[
void torch_random_init(lua_State *L)
{
  luaL_register(L, NULL, random__);
}
   ]])

interface:tofile(arg[1])
