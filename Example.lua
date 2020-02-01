--[[
    ---------------------------------------------------------
    ## Filebox lib example


    filebox.openfile(<label>, <rootPath>, <currentPath>, <fileExtension>, <callBack>, <escSubform> [, <subformFilebox>])

    Parameters:
    - label (string) - filebox label 
    - rootPath (string) - root path of filebox
    - currentPath (string) - current path that open filebox
    - fileExtension (array) - list of displayed file extensions, "*" prints all files
    - callBack (function) - call this function, if exits the filebox
    - escSubform (number) - subform ID of the last form, it calls when the filebox closes
    - [optional] subformFilebox (number) - subform ID of the filebox

    (c) 2019 by M. Lehmann
    ---------------------------------------------------------

    V1.1    22.12.19    Subform_ID of the filebox as an internal default value   
    V1.0    01.06.19    initial release

--]]

----------------------------------------------------------------------
-- Locals for the application
local appVersion,appName="1.0","Filebox example"
local formView

-- filebox lib
local filebox = require("lib/filebox")

----------------------------------------------------------------------
-- callback if file selected
local function newFile(file)
    local msgText = ""
    if(file)then
        msgText = "selected file: ".. file
        print(msgText)
        print(filebox.getFilePath(file))
        print(filebox.getFileName(file))
        print(filebox.getFileExtension(file))
    else
        msgText = "No file selected !"
        print(msgText)
    end
    system.messageBox(msgText, 5)
end


----------------------------------------------------------------------
-- Latches the current keyCode
local function keyForm(keyCode)
    -- update filebox keys periodically
    filebox.updatekey(keyCode)
    
    -- main menu
    if(formView==1)then
        if(keyCode==KEY_1)then
            -- open a log file
            filebox.openfile("Choose log file","/log","/log",{"log"},newFile,formView)
        end
        
        if(keyCode==KEY_2)then
            -- open a file in /Apps folder
            filebox.openfile("Choose app","/Apps","/",{"lua","lc"},newFile,formView)
        end
        
    end
end

----------------------------------------------------------------------
-- Draw the main form (Application menu interface)
local function initForm(subform)
    -- update filebox form periodically
    filebox.updateform(subform)
    
    -- main menu   
    if(subform==1)then
        form.setTitle(appName)
        form.setButton(1,"Log",ENABLED)
        form.setButton(2,"App",ENABLED)
        
        -- add filebox to a formlink
        form.addLink((function()filebox.openfile("Choose file","/","/",{"*"},newFile,subform) end),{label = "open file.."})
        form.addLink((function()filebox.openfile("Choose audio file","/","/",{"wav","mp3"},newFile,subform) end),{label = "open audio file.."})
    
    end
    
    formView = subform
end



----------------------------------------------------------------------
-- Runtime functions
local function loop()

end

----------------------------------------------------------------------
-- Application initialization
local function init()
    system.registerForm(1,MENU_APPS,appName,initForm,keyForm)
end

----------------------------------------------------------------------
return {init=init,loop=loop,author="M.Lehmann",version=appVersion,name=appName}
