bigAsteroidTracker = {}

smallAsteroidTracker = {}

function spawnbigAsteroid(x, y, vx, vy)
	bigAsteroid = {}
		bigAsteroid.x = x
		bigAsteroid.y = y
		bigAsteroid.vectorX = vx
		bigAsteroid.vectorY = vy
		bigAsteroid.direction = 1
		bigAsteroid.speed = 100
		bigAsteroid.offsetX = sprites.asteroid1:getWidth()/2
		bigAsteroid.offsetY = sprites.asteroid1:getHeight()/2--center bigAsteroid pivot point
		bigAsteroid.despawn = false	
		
		
	table.insert(bigAsteroidTracker, bigAsteroid)--adds this bigAsteroid table to the bigAsteroidTracker table in love.load()
end

function spawnSmallAsteroid(x, y, vx, vy)
	smallAsteroid = {}
		smallAsteroid.x = x
		smallAsteroid.y = y
		smallAsteroid.vectorX = vx
		smallAsteroid.vectorY = vy
		smallAsteroid.speed = 150
		smallAsteroid.offsetX = sprites.asteroid2:getWidth()/2
		smallAsteroid.offsetY = sprites.asteroid2:getHeight()/2--center bigAsteroid pivot point
		smallAsteroid.despawn = false	
		
	table.insert(smallAsteroidTracker, smallAsteroid)--adds this bigAsteroid table to the bigAsteroidTracker table in love.load()
end

function asteroidUpdate()
	--moves bigAsteroid towards player
	for i,z in ipairs(bigAsteroidTracker) do
		z.x = z.x + z.vectorX * z.speed * z.direction * dt
		z.y = z.y + z.vectorY * z.speed * dt
		
		--stops asteroids from leaving screen
		if z.x <= 0 or z.x >= love.graphics:getWidth() then
			z.direction = z.direction * -1
		end
		
		if distanceBetween(z.x, z.y, player.x, player.y) < 70 then --this if condition also calls the function
			for i,z in ipairs(bigAsteroidTracker) do
					if invulnerability == false then
						invulnerability = true
						healthLength = healthLength - 50
						invulnerabilityTimer = 1
					end
				smallAsteroidTracker[i] = nil
			end
		end
		--stops asteroids from leaving screen
		end
	
	--moves smallAsteroid towards player
	for i,z in ipairs(smallAsteroidTracker) do
		z.x = z.x + z.vectorX * z.speed * dt
		z.y = z.y + z.vectorY * z.speed * dt
			
		--stops asteroids from leaving screen
		if z.x <= 0 or z.x >= love.graphics:getWidth() then
			z.vectorX = z.vectorX * -1
		end
		
		--collision with player
		if distanceBetween(z.x, z.y, player.x, player.y) < 50 then --this if condition also calls the function
			for i,z in ipairs(smallAsteroidTracker) do
				if invulnerability == false then
						invulnerability = true
						healthLength = healthLength - 50
						invulnerabilityTimer = 1
					end
				smallAsteroidTracker[i] = nil
			end
		end
	end


	--this implements collision between bigAsteroid and bullets
	for i, z in ipairs(bigAsteroidTracker) do
		for j, b in ipairs(bulletTracker) do --using j because i is taken
			if distanceBetween(z.x,z.y,b.x,b.y)	<60 then
				b.despawn = true
				deathSFX:play()
				z.despawn = true
			end	
		end
	end
	
		--this implements collision between bigAsteroid and multishot
	for i, z in ipairs(bigAsteroidTracker) do
		for j, b in ipairs(multishotTracker) do --using j because i is taken
			if distanceBetween(z.x,z.y,b.x,b.y) < 60 then
				b.despawn = true
				deathSFX:play()
				z.despawn = true
			end	
			if distanceBetween(z.x,z.y,b.x2,b.y2) < 60 then
				b.despawn = true
				deathSFX:play()
				z.despawn = true
			end	
		end
	end
	
	
	--this implements collision between smallAsteroid and bullets
	for i, z in ipairs(smallAsteroidTracker) do
		for j, b in ipairs(bulletTracker) do --using j because i is taken
			if distanceBetween(z.x,z.y,b.x,b.y)	<30 then
				deathSFX:play()
				z.despawn = true
				b.despawn = true
			end	
		end
	end
	
		--this implements collision between smallAsteroid and multishot
	for i, z in ipairs(smallAsteroidTracker) do
		for j, b in ipairs(multishotTracker) do --using j because i is taken
			if distanceBetween(z.x,z.y,b.x,b.y) < 60 then
				b.despawn = true
				deathSFX:play()
				z.despawn = true
			end	
			if distanceBetween(z.x,z.y,b.x2,b.y2) < 60 then
				b.despawn = true
				deathSFX:play()
				z.despawn = true
			end	
		end
	end	

	--destroy bigAsteroids
	for i=#bigAsteroidTracker, 1, -1 do 
		
		local z = bigAsteroidTracker[i]
		
		if z.despawn == true then
		
			--spawn small asteroids
			spawnSmallAsteroid(z.x, z.y, z.vectorX, z.vectorY) --exact same velocity as big asteroid 
			spawnSmallAsteroid(z.x, z.y, (z.vectorX*-1), z.vectorY) --inverse x velocity
			
			
			table.remove(bigAsteroidTracker, i) 
			--destroys any bigAsteroids that meet the conditions
		end	
	end
	
	
	--this destroy smallAsteroids who have despawn = true
	for i=#smallAsteroidTracker, 1, -1 do 
		
		local z = smallAsteroidTracker[i]
		
		if z.despawn == true then
			table.remove(smallAsteroidTracker, i) 
			--destroys any smallAsteroids that meet the conditions
		end	
	end
end

function drawAsteroid()
	--draws bigAsteroids
	for i, z in ipairs(bigAsteroidTracker) do
		love.graphics.draw(sprites.asteroid1, z.x, z.y,nil, nil,nil, bigAsteroid.offsetX, bigAsteroid.offsetY)-- z is the current bigAsteroid we are on
	end
	
	--draws smallAsteroids
	for i, z in ipairs(smallAsteroidTracker) do
		love.graphics.draw(sprites.asteroid2, z.x, z.y,nil, nil,nil, smallAsteroid.offsetX, smallAsteroid.offsetY)-- z is the current bigAsteroid we are on
	end
end