local api = require("image")

---@class pdfreader.Image
---@field src string
---@field mode mode
local Image = {}
Image.__index = Image
Image.DEFAULT_SCALE = 60

---render image via api
---@param buffer any
---@param filepath any
---@param scale? number
local function api_render_image(buffer, filepath, scale)
	local window = vim.fn.bufwinid(buffer)
	local win_width = vim.api.nvim_win_get_width(window)
	local win_height = vim.api.nvim_win_get_height(window)
	
	vim.bo[buffer].modifiable = true
	vim.api.nvim_buf_set_lines(buffer, 0, -1, false, {})
	vim.bo[buffer].modifiable = false
	
	local image = api.from_file(filepath, {
		buffer = buffer,
		window = window,
		height = win_height,
		width = win_width,
		with_virtual_padding = true,
  	})
	if image then
		image:render()
	end
end

local function api_delete_image(buffer)
	local images = api.get_images({ buffer = buffer })
	for _, image in ipairs(images) do
		image:clear()
	end
end

---@param src string
---@param opts? pdfreader.Options
---@return pdfreader.Image
function Image.new(src, opts)
	local opts = opts or { mode = 0 }
	local self = setmetatable({}, Image)
	self.src = src
	self.mode = opts.mode
	return self
end

---
---@param buffer number
---@param scale? number
function Image:display(buffer, scale)
	local scale = scale or Image.DEFAULT_SCALE
	api_render_image(buffer, self.src, scale)
end

---@param buffer number
function Image:remove(buffer)
	api_delete_image(buffer)
end

return Image
