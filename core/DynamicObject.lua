require("Base")

DynamicObject = Base:new()

function DynamicObject:getOid()
	if self.oid == nil then
		self.oid = tostring(math.random(99999))
	end
	return self.oid
end

function DynamicObject:reposition(x, y)
end