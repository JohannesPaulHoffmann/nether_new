-- Vial of Reviving

local function revive_effects(player_pos)
	minetest.add_particlespawner({
		amount = 40,
		time = 0.1,
		minpos = {x = player_pos.x, y = player_pos.y + 1, z = player_pos.z},
		maxpos = {x = player_pos.x, y = player_pos.y + 2, z = player_pos.z},
		minvel = {x = -2, y = 0, z = -2},
		maxvel = {x = 2, y = 2, z = 2},
		minacc = 0.1,
		maxacc = 0.3,
		minexptime = 1,
		maxexptime = 3,
		colissiondetection = false,
		vertical = false,
		texture = "reviving_particle.png"
	})
end

minetest.register_craftitem("nether:vial_reviving", {
	description = "Vial of Reviving",
	inventory_image = "vial_reviving.png",
})

minetest.register_craftitem("nether:heart", {
	description = "Nether Heart",
	inventory_image = "nether_heart.png"
})

minetest.register_on_player_hpchange(function(player, hp_change)
	if player:get_hp() + hp_change < 1 then
		local pInv = player:get_inventory()
		if pInv:contains_item("main", "nether:vial_reviving") then
			pInv:remove_item("main", "nether:vial_reviving")
			player:set_hp(20)
			player:set_breath(1)
			revive_effects(player:getpos())
			return 0
		end
	end
	return hp_change
end, true)

minetest.register_craft({
	output = "nether:vial_reviving 8",
	recipe = {{"vessels:glass_bottle", "vessels:glass_bottle", "vessels:glass_bottle"},
			  {"vessels:glass_bottle", "nether:heart", "vessels:glass_bottle"},
			  {"vessels:glass_bottle", "vessels:glass_bottle", "vessels:glass_bottle"}},
})


minetest.register_craft({
	type = "shapeless",
	output = "nether:obsidian_enchanted",
	recipe = { "default:obsidian", "default:diamond" }
})

local obsidian_def = {
	description = "Enchanted Obsidian",
	tiles = { "nether_obsidian_enchanted.png" },
	groups = { cracky = 2 }
}

obsidian_def.on_destruct = function(pos)
	-- Get portal info
	local meta = minetest.get_meta(pos)
	local portal_str = meta:get_string("portal")
	if portal_str == "" then
		return
	end
	local portal_info = minetest.deserialize(portal_str)
	if portal_info == nil then
		return
	end
	-- Remove portal nodes
	local minC = portal_info[1]
	local maxC = portal_info[2]
	for x = minC.x, maxC.x do
		for y = minC.y, maxC.y do
			for z = minC.z, maxC.z do
				local pos = { x = x, y = y, z = z }
				minetest.set_node(pos, { name = "air" })
			end
		end
	end
	-- Update metadata for the enchanted obsidian
	for _, pos in pairs(portal_info[3]) do
		local meta = minetest.get_meta(pos)
		meta:set_string("portal", "")
	end
end

minetest.register_node("nether:obsidian_enchanted", obsidian_def)


minetest.register_node("nether:fumes", {
	descriptions = "Nether Fumes (you hacker you)",
	drawtype = "airlike",
	groups = {not_in_creative_inventory = 1},
	drop = "",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	sunlight_propagates = true,
	is_ground_content = false,
	floodable = false,
	paramtype = "light"
})

minetest.register_node("nether:magma_hot", {
	description = "Hot Nether Magma",
	drawtype = "liquid",
	tiles = {"nether_magma.png"},
	groups = {crumbly = 1},
	is_ground_content = true,
	light_source = 10,
	walkable = false,
	pointable = true,
	diggable = true,
	buildable_to = false,
	paramtype = "light",
	damage_per_second = 2,
	liquidtype = "source",
	liquid_renewable = false,
	liquid_alternative_flowing = "nether:magma_hot",
	liquid_alternative_source = "nether:magma_hot",
	liquid_viscosity = 7,
	liquids_pointable = true,
	liquid_range = 0
})

minetest.register_node("nether:magma", {
	description = "Nether Magma",
	groups = {crumbly = 2, cracky = 1},
	tiles = {"nether_magma_dim.png"},
	is_ground_content = true,
	light_source = 3,
	paramtype = "light"
})

minetest.register_node("nether:bedrock", {
	description = "Bedrock",
	tiles = {"bedrock.png"},
	is_ground_content = false,
	diggable = false,
	damage_per_second = 500, -- Keep hackers from glitching through
	drop = "",
	on_blast = function (pos, intensity) end -- Nothing happens with TNT
})


minetest.register_node("nether:heart_ore", {
	description = "Nether Heart Ore",
	tiles = {"nether_heart_ore.png"},
	groups = {cracky = 1, level = 2},
	drop = "nether:heart",
	on_blast = function (pos, intensity) end
})

if minetest.get_modpath("titanium") then
	minetest.register_node("nether:titanium_ore", {
		description = "Titanium Ore",
		groups = {cracky = 1},
		tiles = {"nether_rack.png^titanium_titanium_in_ground.png"},
		drop = "titanium:titanium"
	})
end

if minetest.get_modpath("technic_worldgen") then
	minetest.register_node("nether:sulfur_ore", {
		description = "Sulfur ore",
		groups = {cracky = 1},
		tiles = {"nether_rack.png^technic_mineral_sulfur.png"},
		drop = "technic:sulfur_lump",
	})
end

minetest.register_node("nether:rack", {
	description = "Nether Rack",
	groups = {cracky = 3, level = 2},
	tiles = {"nether_rack.png"},
	is_ground_content = true,
	sounds = default.node_sound_stone_defaults()
})


-- New netherrack

minetest.register_node("nether:heart_ore_new", {
	description = "Nether Heart Ore",
	tiles = {"nether_rack_new.png^nether_heart_ore_overlay.png"},
	groups = {cracky = 1, level = 2},
	drop = "nether:heart",
	on_blast = function (pos, intensity) end
})

if minetest.get_modpath("titanium") then
	minetest.register_node("nether:titanium_ore_new", {
		description = "Titanium Ore",
		groups = {cracky = 1},
		tiles = {"nether_rack_new.png^titanium_titanium_in_ground.png"},
		drop = "titanium:titanium"
	})
end

if minetest.get_modpath("technic_worldgen") then
	minetest.register_node("nether:sulfur_ore_new", {
		description = "Sulfur ore",
		groups = {cracky = 1},
		tiles = {"nether_rack_new.png^technic_mineral_sulfur.png"},
		drop = "technic:sulfur_lump",
	})
end


-- New deep netherrack

minetest.register_node("nether:heart_ore_deep", {
	description = "Nether Heart Ore",
	tiles = {"nether_rack_deep.png^nether_heart_ore_overlay.png"},
	groups = {cracky = 1, level = 2},
	drop = "nether:heart",
	on_blast = function (pos, intensity) end
})

if minetest.get_modpath("titanium") then
	minetest.register_node("nether:titanium_ore_deep", {
		description = "Titanium Ore",
		groups = {cracky = 1},
		tiles = {"nether_rack_deep.png^titanium_titanium_in_ground.png"},
		drop = "titanium:titanium"
	})
end





-- Mapgen
local mapgen = nether.mapgen

-- Legacy Ores
minetest.register_ore({
	ore_type       = "scatter",
	ore            = "nether:sulfur_ore_new",
	wherein        = {"nether:rack_new"},
	clust_scarcity = 11 * 11 * 11,
	clust_num_ores = 20,
	clust_size     = 6,
	y_max = mapgen.ore_ceiling,
	y_min = mapgen.ore_floor
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "nether:titanium_ore_new",
	wherein        = {"nether:rack_new"},
	clust_scarcity = 12 * 12 * 12,
	clust_num_ores = 4,
	clust_size     = 2,
	y_max = mapgen.ore_ceiling,
	y_min = mapgen.ore_floor
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "nether:titanium_ore_deep",
	wherein        = {"nether:rack_deep"},
	clust_scarcity = 11 * 11 * 11,
	clust_num_ores = 4,
	clust_size     = 2,
	y_max = mapgen.ore_ceiling,
	y_min = mapgen.ore_floor
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "nether:heart_ore_new",
	wherein        = {"nether:rack_new"},
	clust_scarcity = 22 * 22 * 22,
	clust_num_ores = 2,
	clust_size     = 1,
	y_max = mapgen.ore_ceiling,
	y_min = mapgen.ore_floor
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "nether:heart_ore_deep",
	wherein        = {"nether:rack_deep"},
	clust_scarcity = 21 * 21 * 21,
	clust_num_ores = 2,
	clust_size     = 1,
	y_max = mapgen.ore_ceiling,
	y_min = mapgen.ore_floor
})


-- Legacy Magma
minetest.register_ore({
	ore_type       = "blob",
	ore            = "nether:magma",
	wherein        = {"nether:rack_new"},
	clust_scarcity = 16 * 16 * 16,
	clust_num_ores = 50,
	clust_size     = 5,
	y_max = mapgen.ore_ceiling,
	y_min = mapgen.ore_floor
})

minetest.register_ore({
	ore_type       = "blob",
	ore            = "nether:magma",
	wherein        = {"nether:lava_crust","nether:lava_source"},
	clust_scarcity = 14 * 14 * 14,
	clust_num_ores = 100,
	clust_size     = 12,
	y_max = mapgen.ore_ceiling,
	y_min = mapgen.ore_floor
})

minetest.register_ore({
	ore_type       = "blob",
	ore            = "nether:rack",
	wherein        = {"nether:rack_new","nether:lava_crust","nether:lava_source"},
	clust_scarcity = 13 * 13 * 13,
	clust_num_ores = 80,
	clust_size     = 7,
	y_max = mapgen.ore_ceiling,
	y_min = mapgen.ore_floor
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "nether:magma_hot",
	wherein        = {"nether:rack_new","nether:rack_deep"},
	clust_scarcity = 13 * 13 * 13,
	clust_num_ores = 2,
	clust_size     = 1,
	y_max = mapgen.ore_ceiling,
	y_min = mapgen.ore_floor
})

minetest.register_ore({
	ore_type       = "scatter",
	ore            = "nether:magma_hot",
	wherein        = {"nether:lava_crust","nether:lava_source"},
	clust_scarcity = 10 * 10 * 10,
	clust_num_ores = 10,
	clust_size     = 4,
	y_max = mapgen.ore_ceiling,
	y_min = mapgen.ore_floor
})




-- Portals


local areas = minetest.global_exists("areas") and areas

local function posin(t, e)
    for k, v in pairs(t) do
        if v.x == e.x and v.y == e.y and v.z == e.z then
            return true
        end
    end
    return false
end

local function check(pos)
    local n = minetest.get_node(pos).name
    if n == "nether:obsidian_enchanted" then
        return true
    end
end

local function allequal(a, b, c, d)
    return a == b and a == c and a == d
end

local function search(pos)
    local ptable = {}
    local inX = false
    local inY = false
    local inZ = false
    for x = -1, 1 do
        if x ~= 0 then
            local pos = { x = pos.x + x, y = pos.y, z = pos.z }
            if check(pos) then
                table.insert(ptable, pos)
                inX = true
            end
        end
    end
    for y = -1, 1 do
        if y ~= 0 then
            local pos = { x = pos.x, y = pos.y + y, z = pos.z }
            if check(pos) then
                table.insert(ptable, pos)
                inY = true
            end
        end
    end
    for z = -1, 1 do
        if z ~= 0 then
            local pos = { x = pos.x, y = pos.y, z = pos.z + z }
            if check(pos) then
                table.insert(ptable, pos)
                inZ = true
            end
        end
    end
    local corner = (inX and inY) or (inX and inZ) or (inY and inZ)
    return ptable, corner
end

local function portalat(pos)
    -- Get surrounding obsidian
    local fullpos = {}
    local corners = {}
    local tosearch = { pos }
    local portal_pos = {}
    local index = 1
    while index <= #tosearch do
        local sPos = tosearch[index]
        local iscorner
        local valid, iscorner = search(sPos)
        -- Add neighboring blocks to the search table
        for k, v in pairs(valid) do
            if not posin(tosearch, v) then
                table.insert(tosearch, v)
            end
        end
        table.insert(fullpos, sPos)
        -- Check if sPos is a corner
        if iscorner then
            table.insert(corners, sPos)
        end
        index = index + 1
    end
    tosearch = nil
    -- Make sure there are 4 corners
    if #corners ~= 4 then
        return false
    end
    -- Make sure all the corners lay on a plane and all the pieces are in place if so
    local c1 = corners[1]
    local c2 = corners[2]
    local c3 = corners[3]
    local c4 = corners[4]
    if allequal(c1.x, c2.x, c3.x, c4.x) then
        local minZ = math.min(c1.z, c2.z, c3.z, c4.z)
        local minY = math.min(c1.y, c2.y, c3.y, c4.y)
        local maxZ = math.max(c1.z, c2.z, c3.z, c4.z)
        local maxY = math.max(c1.y, c2.y, c3.y, c4.y)
        for z = minZ, maxZ do
            local p1 = { x = c1.x, y = maxY, z = z }
            local p2 = { x = c1.x, y = minY, z = z }
            if not posin(fullpos, p1) or not posin(fullpos, p2) then
                return
            end
            table.insert(portal_pos, p1)
            table.insert(portal_pos, p2)
        end
        for y = minY, maxY do
            local p1 = { x = c1.x, y = y, z = maxZ }
            local p2 = { x = c1.x, y = y, z = minZ }
            if not posin(fullpos, p1) or not posin(fullpos, p2) then
                return
            end
            table.insert(portal_pos, p1)
            table.insert(portal_pos, p2)
        end
        local minC = { x = c1.x, y = minY + 1, z = minZ + 1 }
        local maxC = { x = c1.x, y = maxY - 1, z = maxZ - 1 }
        -- Make sure the rectangle has an interior
        if minC.y > maxC.y or minC.z > maxC.z then
            return
        end
        return minC, maxC, portal_pos, 1
    elseif allequal(c1.y, c2.y, c3.y, c4.y) then
        local minX = math.min(c1.x, c2.x, c3.x, c4.x)
        local minZ = math.min(c1.z, c2.z, c3.z, c4.z)
        local maxX = math.max(c1.x, c2.x, c3.x, c4.x)
        local maxZ = math.max(c1.z, c2.z, c3.z, c4.z)
        for x = minX, maxX do
            local p1 = { x = x, y = c1.y, z = maxZ }
            local p2 = { x = x, y = c1.y, z = minZ }
            if not posin(fullpos, p1) or not posin(fullpos, p2) then
                return
            end
            table.insert(portal_pos, p1)
            table.insert(portal_pos, p2)
        end
        for z = minZ, maxZ do
            local p1 = { x = maxX, y = c1.y, z = z }
            local p2 = { x = minX, y = c1.y, z = z }
            if not posin(fullpos, p1) or not posin(fullpos, p2) then
                return
            end
            table.insert(portal_pos, p1)
            table.insert(portal_pos, p2)
        end
        local minC = { x = minX + 1, y = c1.y, z = minZ + 1 }
        local maxC = { x = maxX - 1, y = c1.y, z = maxZ - 1 }
        -- Make sure the rectangle has an interior
        if minC.x > maxC.x or minC.z > maxC.z then
            return
        end
        return minC, maxC, portal_pos, 4
    elseif allequal(c1.z, c2.z, c3.z, c4.z) then
        local minX = math.min(c1.x, c2.x, c3.x, c4.x)
        local minY = math.min(c1.y, c2.y, c3.y, c4.y)
        local maxX = math.max(c1.x, c2.x, c3.x, c4.x)
        local maxY = math.max(c1.y, c2.y, c3.y, c4.y)
        for x = minX, maxX do
            local p1 = { x = x, y = maxY, z = c1.z }
            local p2 = { x = x, y = minY, z = c1.z }
            if not posin(fullpos, p1) or not posin(fullpos, p2) then
                return
            end
            table.insert(portal_pos, p1)
            table.insert(portal_pos, p2)
        end
        for y = minY, maxY do
            local p1 = { x = maxX, y = y, z = c1.z }
            local p2 = { x = minX, y = y, z = c1.z }
            if not posin(fullpos, p1) or not posin(fullpos, p2) then
                return
            end
            table.insert(portal_pos, p1)
            table.insert(portal_pos, p2)
        end
        local minC = { x = minX + 1, y = minY + 1, z = c1.z }
        local maxC = { x = maxX - 1, y = maxY - 1, z = c1.z }
        -- Make sure the rectangle has an interior
        if minC.x > maxC.x or minC.y > maxC.y then
            return
        end
        return minC, maxC, portal_pos, 0
    end
end

local function makeportal(minC, maxC, portal_pos, param2, target)
    -- Create the portal
    for x = minC.x, maxC.x do
        for y = minC.y, maxC.y do
            for z = minC.z, maxC.z do
                local pos = { x = x, y = y, z = z }
                minetest.set_node(pos, { name = "nether:portal", param2 = param2 })
                local meta = minetest.get_meta(pos)
                meta:set_string("target", minetest.serialize(target))
            end
        end
    end
    -- Update metadata for the enchanted obsidian
    local portal_str = minetest.serialize({ minC, maxC, portal_pos })
    for _, pos in pairs(portal_pos) do
        local meta = minetest.get_meta(pos)
        meta:set_string("portal", portal_str)
    end
end

minetest.register_node("nether:portal", {
    description = "Nether Portal (you hacker you)",
    tiles = {
        "nether_transparent.png",
        "nether_transparent.png",
        "nether_transparent.png",
        "nether_transparent.png",
        {
            name = "nether_portal.png",
            animation = {
                type = "vertical_frames",
                aspect_w = 16,
                aspect_h = 16,
                length = 0.5,
            },
        },
        {
            name = "nether_portal.png",
            animation = {
                type = "vertical_frames",
                aspect_w = 16,
                aspect_h = 16,
                length = 0.5,
            },
        },
    },
    drawtype = "nodebox",
    paramtype = "light",
    paramtype2 = "facedir",
    sunlight_propagates = true,
    use_texture_alpha = true,
    walkable = false,
    diggable = false,
    pointable = false,
    buildable_to = false,
    is_ground_content = false,
    drop = "",
    light_source = 5,
    post_effect_color = { a = 180, r = 128, g = 0, b = 128 },
    alpha = 192,
    node_box = {
        type = "fixed",
        fixed = {
            { -0.5, -0.5, -0.1, 0.5, 0.5, 0.1 },
        },
    },
    groups = { not_in_creative_inventory = 1 }
})

nether_teleports = {}
minetest.register_abm({
    label = "Nether teleport",
    nodenames = { "nether:portal" },
    interval = 1,
    chance = 1,
    action = function(pos, node, active_object_count, active_object_count_wider)
        local targets = minetest.get_objects_inside_radius(pos, 0.95)
        for _, player in pairs(targets) do
            if player:is_player() and nether_teleports[player:get_player_name()] == nil then
                local name = player:get_player_name()
                nether_teleports[name] = player:get_pos()
                minetest.after(3, function()
                    if not minetest.get_player_by_name(name) then
                        nether_teleports[name] = nil
                        return
                    end
                    local oldpos = nether_teleports[name]
                    local newpos = player:get_pos()
                    if oldpos.x == newpos.x and oldpos.z == newpos.z then
                        local meta = minetest.get_meta(pos)
                        local pos_str = meta:get_string("target")
                        if pos_str == "" then
                            return
                        end
                        local pos = minetest.deserialize(pos_str)
                        if pos == nil then
                            return
                        end
                        minetest.log("action", ("[nether] moving %s from %s to %s"):format(name, minetest.pos_to_string(newpos), minetest.pos_to_string(pos)))
                        player:set_pos(pos)
                    end
                    nether_teleports[name] = nil
                end)
            end
        end
    end
})
