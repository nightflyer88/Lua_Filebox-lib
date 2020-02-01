# LUA Filebox-lib

[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=R69PMKTCXQBUU&source=url)

Jeti library for LUA app developers. Open files with this beautiful Filebox library.

![screen000](https://raw.githubusercontent.com/nightflyer88/Lua_Filebox-lib/master/img/Screen001.png)
![screen001](https://raw.githubusercontent.com/nightflyer88/Lua_Filebox-lib/master/img/Screen002.png)

## How to use

In the following steps you will learn how to integrate the filebox lib into your app. Check out the sample app on how to use Lib.

### Add Lib to your app

Place the file filebox.lc in your app folder for example: /Apps/myapp/filebox.lc
Please do not put it in a general folder like /Apps , as this can lead to version conflicts if other apps also use the Lib.

Integrate the lib into your appcode with the following line:
```
local filebox = require("myapp/filebox")
```

### Open file function

Opens the filebox dialog and the user can select a file.

```
filebox.openfile(<label>, <rootPath>, <currentPath>, <fileExtension>, <callBack>, <escSubform> [, <subformFilebox>])
```
Parameters:
- label (string) - filebox label 
- rootPath (string) - root path of filebox
- currentPath (string) - current path that open filebox
- fileExtension (array) - list of displayed file extensions, "*" prints all files
- callBack (function) - call this function, if exits the filebox
- escSubform (number) - subform ID of the last form, it calls when the filebox closes
- [optional] subformFilebox (number) - subform ID of the filebox

Returns filepath as string, eg: "/path/to/file/myfile.txt" or nil if no file selectet.

### update form function

```
filebox.updateform(subform)
```
Updates the filebox form, place this function in the From function of the app.

### update key function

```
filebox.updatekey(keyCode)
```
Updates the filebox keys, place this function in the key function of the app.

## Helper functions

Additional helper functions.

```
filebox.getFilePath(file)
```
Returns the path of a file.

```
filebox.getFileName(file)
```
Returns the filename.

```
filebox.getFileExtension(file)
```
Returns the fileextension.

```
filebox.getFileSize(file)
```
Returns the filesize.
