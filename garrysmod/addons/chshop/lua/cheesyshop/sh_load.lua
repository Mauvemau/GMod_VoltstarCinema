-- This script belongs to this source: https://github.com/pixeltailgames/cinema/blob/master/cinema/gamemode/sh_load.lua --

module( "Loader", package.seeall )

BaseGamemode = "cheesyshop"

local function GetFileList( strDirectory, strFolder )
	
	local files = {}

	local realDirectory = strFolder .. "/" .. strDirectory .. "/*"
	local findFiles, findFolders = file.Find( realDirectory, "LUA" )

	for k, v in pairs( table.Add(findFiles, findFolders) ) do
	
		if ( v == "." || v == ".." || v == ".svn" ) then continue end
		
		table.insert( files, v )
		
	end
	
	return files
	
end

local function IsLuaFile( strFile )
	return ( string.sub( strFile, -4 ) == ".lua" )
end

local function IsDirectory( strDir )
	return ( string.GetExtensionFromFilename( strDir ) == nil )
end

local function LoadFile( strDirectory, strFolder, strFile )
	
	local prefix = string.sub( strFile, 0, 3 )
	local realFile = strFolder .. "/" .. strDirectory .. "/" .. strFile

	if ( prefix == "cl_" ) then
		
		if SERVER then
			AddCSLuaFile( realFile )
		else
			include( realFile )
		end
	
	elseif ( prefix == "sh_" ) then
	
		if SERVER then
			AddCSLuaFile( realFile )
		end
		
		include( realFile )
		
	elseif ( prefix == "sv_" || strFile == "init.lua" ) then
	
		if SERVER then
			include( realFile )
		end
		
	end
	
end

function LoadAction( strDirectory, strFolder, funcAction )

	local entList = GetFileList( strDirectory, strFolder )
	
	for _, v in pairs( entList ) do
	
		local entDir = strDirectory .. "/" .. v
		local entFiles = GetFileList( entDir, strFolder )

		funcAction( entDir, entFiles, v, strFolder )
		
	end
	
end

function LoadEntities( entDir, entFiles, entName, strFolder )

	_G.ENT = {}
	
	for _, entFile in pairs( entFiles ) do
		LoadFile( entDir, strFolder, entFile )
	end
	
	if _G.ENT.Type then
		scripted_ents.Register( _G.ENT, entName, false )
	end
	
	_G.ENT = nil
	
end

function LoadEnts( strDirectory, strFolder )

	local strDirectory = strDirectory .. "/ents"
	local fileList = GetFileList( strDirectory, strFolder )

	for _, v in pairs( fileList ) do

		local entFolder = strDirectory .. "/" .. v
		
		if ( v == "entities" ) then
			LoadAction( entFolder, strFolder, LoadEntities )
		end
		
	end
	
end

function Load( strDirectory, strFolder )
	
	if ( !strFolder ) then
		strFolder = BaseGamemode
	end
	
	local fileList = GetFileList( strDirectory, strFolder )

	if table.HasValue( fileList, "ents" ) then
		LoadEnts( strDirectory, strFolder )
	end

	for k, v in pairs( fileList ) do
	
		if ( IsLuaFile( v ) ) then
		
			LoadFile( strDirectory, strFolder, v )
			
		elseif ( v != "ents" ) then // we won't go into ents folders

			local strNextDir = strDirectory .. "/" .. v
			
			if IsDirectory( strNextDir ) then
				Load( strNextDir, strFolder ) // go deeper. BWOOOOOONG!!
			end
			
		end
	end
	
end