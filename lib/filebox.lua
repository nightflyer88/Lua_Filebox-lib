--[[
    ---------------------------------------------------------
    Filebox lib 

    (c) 2019 by M. Lehmann
    ---------------------------------------------------------

    V1.0    05.09.19    initial release

--]]

----------------------------------------------------------------------
-- Locals for the lib

local filebox = {}

local subform_ID, returnedSubform = nil,nil
local title_String,current_Path,root_Path,displayedFileExtensions = "","","",{}
local fileType = {wav = ":sndOn", mp3 = ":music", log = ":graph", lua = ":edit", jsn = ":edit", josn = ":edit", txt = ":edit"}
local callback

local maxFilesPerPage = 40
local startPageFile = 0




----------------------------------------------------------------------
-- private functions
local function appendPath(path, file)
    if(string.sub(path,#path,#path) ~= '/')then
        path = path.."/"
    end
    path = path.. file
    return path
end


local function containsExtension(extensionList, extension)
  for k,v in pairs(extensionList) do
    if v == extension then return true end
  end
end


local function exitFileBox(successful)
    subform_ID = nil
    if(successful == true)then
        callback(current_Path)  
    else
        callback(nil)
    end
    form.reinit(returnedSubform)
end

----------------------------------------------------------------------
-- public functions
function filebox.getSubformID()
    return subform_ID
end

function filebox.getFilePath(file)
    local p = string.find(string.reverse(file), '/', 1, true)
    if(p ~= nil and p <= #file)then
        return string.sub(file,1,#file - p)
    end
    return nil
end

function filebox.getFileName(file)
    local p = string.find(string.reverse(file), '/', 1, true)
    if(p ~= nil and p <= #file)then
        return string.sub(file,#file - p + 2,#file)
    end
    return nil
end

function filebox.getFileExtension(file)
    local p = string.find(string.reverse(file), '.', 1, true)
    if(p ~= nil and p < #file)then
        return string.sub(file,#file - p + 2,#file)
    end
    return nil
end

function filebox.getFileSize(file)
    local filePath = filebox.getFilePath(file)
    local fileName = filebox.getFileName(file)
    for name, filetype, size in dir(filePath) do
        if(name == fileName)then
            return size
        end
    end
    return nil
end

function filebox.updatekey(subform,keyCode)
    if(subform_ID == subform)then  
        
        if(keyCode==KEY_5)then
            form.preventDefault()
        end
        
        if(keyCode==KEY_ESC or keyCode==KEY_1)then
            -- abort
            form.preventDefault()
            exitFileBox(false)
        end
    end
end


function filebox.updateform(subform)
    if(subform_ID == subform)then

        form.setTitle(title_String)
        form.setButton(1,"ESC",ENABLED)
        form.setButton(5,"",ENABLED)
        
        system.setProperty("CpuLimit", 0)
        
        local curFilesRead = 0
        local skipPrint, pageBackPrinted = true,false

        for name, filetype, size in dir(current_Path) do

            if(curFilesRead >= startPageFile)then
                skipPrint = false
            end

            -- page back
            if(startPageFile > 0 and pageBackPrinted == false)then
                form.addLink((function() 
                                startPageFile = startPageFile - maxFilesPerPage
                                form.reinit(subform_ID) 
                            end),
                {label = "<<"})
                pageBackPrinted = true
            end

            -- folder back
            if (#current_Path > #root_Path and name == ".") then
                if (skipPrint == false) then
                    form.addLink((function() 
                                    local p = string.find(string.reverse(current_Path), '/', 1, true)
                                    if(p ~= nil and p < #current_Path)then
                                        current_Path = string.sub(current_Path,0,#current_Path - p)
                                    else
                                        current_Path = root_Path
                                    end
                                    startPageFile = 0
                                    form.reinit(subform_ID) 
                                end),
                    {label = ".."})
                end
                curFilesRead = curFilesRead + 1
            elseif(string.sub(name,1,1) ~= ".") then
                -- if folder
                if (filetype=="folder") then
                    if (skipPrint == false) then
                        form.addRow(2)
                        form.addIcon(":folder",{width=30, enabled = false})
                        form.addLink((function() 
                                        current_Path = appendPath(current_Path, name)
                                        startPageFile = 0
                                        form.reinit(subform_ID) 
                                    end),
                                    {label = name})
                    end
                    curFilesRead = curFilesRead + 1
                end  

                -- if file
                if(filetype=="file")then
                    local fileExtensionIcon = ":file"
                    local fileExtension = filebox.getFileExtension(name)
                    local icon = fileType[fileExtension]
                    if(icon ~= nil)then
                        fileExtensionIcon = icon
                    end
                    if(containsExtension(displayedFileExtensions, fileExtension) or containsExtension(displayedFileExtensions, "*"))then
                        if (skipPrint == false) then
                            local fileName
                            if(fileExtension == "log")then
                                local f = io.open(appendPath(current_Path, name),"r") 
                                fileName = string.gsub(string.sub(name,1,#name-4), "-", ":").."  "..string.sub(io.readline(f),3)
                            else
                                fileName = name
                            end
                            form.addRow(3)
                            form.addIcon(fileExtensionIcon,{width=30, enabled = false})
                            form.addLink((function() 
                                            current_Path = appendPath(current_Path, name)
                                            exitFileBox(true) 
                                        end),
                            {label = fileName,width=200})
                            form.addLabel({label=string.format("%.1f",(size/1000)).."KB",alignRight=true})
                        end
                        curFilesRead = curFilesRead + 1
                    end
                end
            end
            
            -- next page
            if(curFilesRead > maxFilesPerPage + startPageFile)then
                form.addLink((function() 
                                startPageFile = startPageFile + maxFilesPerPage
                                form.reinit(subform_ID) 
                            end),
                {label = ">>"})
                break
            end
        end
        system.setProperty("CpuLimit", 1)
    end    
end


function filebox.openfile(subformFilebox, label, rootPath, currentPath, fileExtension, callBack, escSubform)
    subform_ID = subformFilebox
    title_String = label
    root_Path = rootPath
    if(#root_Path > #currentPath)then
        current_Path = root_Path
    else
        current_Path = currentPath
    end
    displayedFileExtensions = fileExtension
    callback = callBack
    returnedSubform = escSubform
    
    startPageFile = 0

    form.reinit(subform_ID)
end


return filebox
