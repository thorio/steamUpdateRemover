--Steam update removal utility by Thorou

function patchfile(file) --patches a single .acf file
	local f = io.open(file, "r")       --open file and extract content
	local filestring = f:read("*all")
	f:close()
	if not filestring:match('"StateFlags"		"4"') then --search for a string that signifies a pending update
		patch = patch + 1 --keep track of number of patched files
		local f = io.open(file..".bak", "w") --write original data to backup file before making any changes
		f:write(filestring)
		f:close()
		print("		removed pending update")
		filestring = filestring:gsub('"StateFlags"		"(.-)"','"StateFlags"		"4"', 1)     --replace data in .acf to remove steams knowledge of the update
		filestring = filestring:gsub('"UpdateResult"		"(.-)"','"UpdateResult"		"0"', 1)
		local f = io.open(file, "w") --open file and overwrite with changed content
		f:write(filestring)
		f:close()
	end
end

function patchlib(lib) --patches all .acf files in a directory, i.e. a steam library folder
	num = 0
	patch = 0
	print(lib)
	for name in io.popen("dir \""..lib.."\" /b"):lines() do --look at all contents of directory
		if name:match("appmanifest_(.-).acf") then --look for the .acf files
			num = num + 1
			print(num,name)
			patchfile(lib.."/"..name) --patch this file
		end
	end
	print("\nDone!\n"..num.." Entries total, "..patch.." Entries edited.\n")
end

--=============================================================================================================================

--This is where the magic happens! If you only have one library in the standard location, you can leave this as is.
--If you have a nonstandard location or more than one library, just insert the paths below and remove the -- if necessary.

patchlib("C:/Program Files (x86)/Steam/steamapps/") --standard location of main library
--patchlib("E:/Steam Library/steamapps/") --example for a secondary library on another drive

--=============================================================================================================================

io.read() --pause so the user can read the screen