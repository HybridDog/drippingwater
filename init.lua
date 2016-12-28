--Dripping Water Mod
--by kddekadenz

-- License of code, textures & sounds: CC0

-- forum mod topic at https://forum.minetest.net/viewtopic.php?f=11&t=1688


--Drop entities

--water

local function can_fall_through(name)
	local def = minetest.registered_nodes[name]
	return def
		and def.walkable == false
		and def.liquidtype == "none"
end

local def = {
	hp_max = 2000,
	physical = true,
	collisionbox = {0,0,0,0,0,0},
	visual = "cube",
	visual_size = {x=0.05, y=0.1},
	spritediv = {x=1, y=1},
	initial_sprite_basepos = {x=0, y=0},

	textures = {"default_water.png","default_water.png","default_water.png","default_water.png", "default_water.png", "default_water.png"},

	on_activate = function(self)
		self.object:setsprite({x=0,y=0}, 1, 1, true)
		self.object:setacceleration({x=0, y=-5, z=0})
	end,

	on_step = function(self)
		if self.object:getvelocity().y ~= 0 then
			return
		end

		local ownpos = self.object:getpos()
		ownpos.y = ownpos.y - 0.5

		if not can_fall_through(minetest.get_node(ownpos).name) then
			self.object:remove()
			ownpos.y = ownpos.y + 0.5
			minetest.sound_play({name="drippingwater_drip"}, {pos = ownpos, gain = 0.5, max_hear_distance = 8})
		end
	end,
}

minetest.register_entity("drippingwater:drop_water", table.copy(def))



--lava

def.textures = {"default_lava.png","default_lava.png","default_lava.png","default_lava.png", "default_lava.png", "default_lava.png"}
def.on_activate = function(self)
	self.object:setsprite({x=0,y=0}, 1, 0, true)
	self.object:setacceleration({x=0, y=-5, z=0})
end
def.on_step = function(self)
	if self.object:getvelocity().y ~= 0 then
		return
	end

	local ownpos = self.object:getpos()
	ownpos.y = ownpos.y - 0.5

	if not can_fall_through(minetest.get_node(ownpos).name) then
		self.object:remove()
		ownpos.y = ownpos.y + 0.5
		minetest.sound_play({name="default_cool_lava"}, {pos = ownpos, gain = 0.025, max_hear_distance = 8})
	end
end

minetest.register_entity("drippingwater:drop_lava", def)



local function spawn_drop(pos, name)
	local def = minetest.registered_nodes[minetest.get_node{x=pos.x, y=pos.y +1, z=pos.z}.name]
	if not def
	or def.liquidtype == "none" then
		return
	end
	if can_fall_through(minetest.get_node({x=pos.x, y=pos.y -1, z=pos.z}).name)
	and can_fall_through(minetest.get_node({x=pos.x, y=pos.y -2, z=pos.z}).name) then
		minetest.add_entity({x=pos.x+(math.random()-0.5)*0.9, y=pos.y-0.5, z=pos.z+(math.random()-0.5)*0.9}, name)
	end
end



--Create drop

minetest.register_abm({
	nodenames = {"group:crumbly"},
	neighbors = {"group:water"},
	interval = 2,
	chance = 22,
	catch_up = false,
	action = function(pos)
		spawn_drop(pos, "drippingwater:drop_water")
	end,
})



--Create lava drop

minetest.register_abm({
	nodenames = {"group:crumbly"},
	neighbors = {"group:lava"},
	interval = 2,
	chance = 22,
	catch_up = false,
	action = function(pos)
		spawn_drop(pos, "drippingwater:drop_lava")
	end,
})
