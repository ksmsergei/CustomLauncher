# CustomLauncher
A very simple program that allows you to run the desired program with arguments from the list.

Usage
---
The list of programs available to run is defined by a JSON file like this one:<br />
```json
[
  {
    "name": "echo (Linux)",
    "command": "gnome-terminal",
    "args": ["--", "sh", "-c", "bash -c 'echo EXAMPLE; exec bash'"]
  },
  {
    "name": "echo (Windows)",
    "command": "cmd",
    "args": ["/c", "start", "cmd", "/k", "echo EXAMPLE && pause"]
  },
  {
    "name": "calc (Windows) (No args)",
    "command": "calc"
  }
]
```

You need to specify:
- **name** - the string to be displayed in the launcher
- **command** - the program to start
- **args (optional)** - array of arguments with which to start the above program

After creating such a JSON file, you should run the program itself from the console or by creating a shortcut with the path to the file as an argument:
```bat
CustomLauncher.jar "json/example.json"
```