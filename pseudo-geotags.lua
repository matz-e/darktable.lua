math = require "math"
string = require "string"

darktable = require "darktable"

-- Detaches tags containing " Km to " from images and detelets the tags
function remove_km()
  print("Checking for distance tags")
  for _, v in ipairs(darktable.database) do
    tags = darktable.tags.get_tags(v)
    for _, tag in ipairs(tags) do
      if string.find(tag.name, " Km to ") then
        print("Detaching ", tag.name)
        darktable.tags.detach(tag, v)
      end
    end
  end
  print("Done checking for distance tags")
  print("Deleting distance tags")
  for _, tag in ipairs(darktable.tags) do
    if string.find(tag.name, " Km to ") then
      print("Deleting ", tag.name)
      darktable.tags.delete(tag)
    end
  end
  print("Done deleting distance tags")
end

-- Detaches tags starting with "geo:" and moves the contents into location
-- info of the image
function remove_geo()
  local lookup = {
    lat = "latitude",
    lon = "longitude"
  }
  for _, tag in ipairs(darktable.tags) do
    member, value = string.match(tag.name, "^geo:(l%a%a)=(-?%d+%.%d+)")
    if member then
      member = lookup[member]
    end
    if value then
      value = tonumber(value)
    end
    if member and value then
      success = true
      print("Deleting ", tag.name)
      size = #tag
      if size > 0 then
        for i, img in ipairs(tag) do
          if not img[member] then
            img[member] = value
          elseif math.abs(img[member] - value) > 1e-5 then
            print("Mismatch for", member, img[member], value)
            success = false
          end
          if i == size then
            break
          end
        end
      end
      if success then
        darktable.tags.delete(tag)
      end
    end
  end
end

local box = darktable.new_widget("box") {
  orientation = "vertical",
  darktable.new_widget("button") {
    label = "remove tags containing \"Km to\"",
    clicked_callback = remove_km
  },
  darktable.new_widget("button") {
    label = "remove tags starting with \"geo:\"",
    clicked_callback = remove_geo
  }
}

darktable.register_lib(
  "pseudo-geotags",
  "pseudo geotags",
  true,
  false,
  {
    [darktable.gui.views.lighttable] = {"DT_UI_CONTAINER_PANEL_LEFT_CENTER",20},
  },
  box
)
