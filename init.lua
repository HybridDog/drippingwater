--Dripping Water Mod
--by kddekadenz

-- License of code, textures & sounds: CC0


--Drop entities

--water

minetest.register_entity("drippingwater:drop_water", {
	hp_max = 2000,
	physical = true,
	collisionbox = {0,0,0,0,0,0},
	visual = "cube",
	visual_size = {x=0.05, y=0.1},
	textures = {"default_water.png","default_water.png","default_water.png","default_water.png", "default_water.png", 	"default_water.png"},
	spritediv = {x=1, y=1},
	initial_sprite_basepos = {x=0, y=0},

	on_activate = function(self, staticdata)
		self.object:setsprite({x=0,y=0}, 1, 1, true)
		self.object:setacceleration({x=0, y=-5, z=0})
	end,

	on_step = function(self, dtime)
		if self.object:getvelocity().y ~= 0 then
			return
		end

		local ownpos = self.object:getpos()
		ownpos.y = ownpos.y - 0.5

		if minetest.get_node(ownpos).name ~= "air" then
			self.object:remove()
			ownpos.y = ownpos.y + 0.5
			minetest.sound_play({name="drippingwater_drip"}, {pos = ownpos, gain = 0.5, max_hear_distance = 8})
		end
	end,
})



--lava

minetest.register_entity("drippingwater:drop_lava", {
	hp_max = 2000,
	physical = true,
	collisionbox = {0,0,0,0,0,0},
	visual = "cube",
	visual_size = {x=0.05, y=0.1},
	textures = {"default_lava.png","default_lava.png","default_lava.png","default_lava.png", "default_lava.png", "default_lava.png"},
	spritediv = {x=1, y=1},
	initial_sprite_basepos = {x=0, y=0},

	on_activate = function(self, staticdata)
		self.object:setsprite({x=0,y=0}, 1, 0, true)
		self.object:setacceleration({x=0, y=-5, z=0})
	end,

	on_step = function(self, dtime)
		if self.object:getvelocity().y ~= 0 then
			return
		end

		local ownpos = self.object:getpos()
		ownpos.y = ownpos.y - 0.5

		if minetest.get_node(ownpos).name ~= "air" then
			self.object:remove()
			ownpos.y = ownpos.y + 0.5
			minetest.sound_play({name="drippingwater_lavadrip"}, {pos = ownpos, gain = 0.5, max_hear_distance = 8})
		end
	end,
})


local function spawn_drop(pos, name)
	if minetest.get_node({x=pos.x, y=pos.y -1, z=pos.z}).name == "air"
	and minetest.get_node({x=pos.x, y=pos.y -2, z=pos.z}).name == "air" then
		minetest.add_entity({x=pos.x+(math.random()-0.5)*0.9, y=pos.y-0.5, z=pos.z+(math.random()-0.5)*0.9}, name)
	end
end



--Create drop

minetest.register_abm({
	nodenames = {"group:crumbly"},
	neighbors = {"group:water"},
	interval = 2,
	chance = 22,
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
	action = function(pos)
		spawn_drop(pos, "drippingwater:drop_lava")
	end,
})
