' Script to manage toolbar toggles with predefined positions
' Simply executes toolbar toggle commands you configure
' Version: 2.1 - Removed selective restore (use Restore All instead!)

Option Explicit

Function OnInit(initData)
    initData.name = "Toolbar Toggle Manager"
    initData.version = "2.1"
    initData.desc = "Manages toolbar visibility using predefined toggle commands"
    initData.default_enable = True
    initData.min_version = "13.0"

    ' Configuration settings
    Dim config: Set config = initData.config
    Dim config_desc: Set config_desc = DOpus.Create.Map
    Dim config_groups: Set config_groups = DOpus.Create.Map

    ' Toolbar commands - each line is: DisplayName|ToolbarCommand
    config.ToolbarCommands = "Header|Toolbar NAME=Header STATE=top LINE=0" & vbCrLf & _
                            "Menu|Toolbar NAME=Menu STATE=top LINE=1" & vbCrLf & _
                            "Operations|Toolbar NAME=Operations STATE=top LINE=2" & vbCrLf & _
                            "File Display|Toolbar NAME=""File Display"" STATE=bottom"
    
    config_desc("ToolbarCommands") = "List of toolbars with their toggle commands. Format: DisplayName|ToolbarCommand (one per line)"
    config_groups("ToolbarCommands") = "1 - Toolbar Configuration"

    ' Debug logging
    config.DebugLevel = DOpus.Create.Vector(0, "0 - Off (Default)", "1 - Info", "2 - Debug")
    config_desc("DebugLevel") = "Set the level of debug output"
    config_groups("DebugLevel") = "2 - Settings"

    initData.config_desc = config_desc
    initData.config_groups = config_groups

    ' Add commands
    Dim cmd
    
    Set cmd = initData.AddCommand()
    cmd.name = "RestoreAllToolbars"
    cmd.method = "OnRestoreAllToolbars"
    cmd.desc = "Execute all toolbar toggle commands at once"
    cmd.label = "Restore All Toolbars"
    cmd.template = ""
    cmd.hide = False
    cmd.icon = "refresh"

    Set cmd = initData.AddCommand()
    cmd.name = "ShowToolbarCommands"
    cmd.method = "OnShowToolbarCommands"
    cmd.desc = "Display the list of configured toolbar commands"
    cmd.label = "Show Toolbar Commands"
    cmd.template = ""
    cmd.hide = False
    cmd.icon = "info"
End Function

Sub DebugOutput(level, message)   
    If Script.config.DebugLevel >= level Then
        Dim levelString
        Select Case level
            Case 1: levelString = "[Info]  | "
            Case 2: levelString = "[Debug] | "
            Case Else: levelString = "[Log]   | "
        End Select
        DOpus.Output levelString & message
    End If
End Sub

Function ParseToolbarCommands()
    ' Parse the toolbar commands configuration
    ' Returns a Vector of Maps with "name" and "command" keys
    Dim toolbarList: Set toolbarList = DOpus.Create.Vector
    Dim lines, line, parts
    
    lines = Split(Script.config.ToolbarCommands, vbCrLf)
    
    For Each line In lines
        line = Trim(line)
        
        ' Skip empty lines and comments
        If line <> "" And Left(line, 1) <> "'" And Left(line, 1) <> "#" Then
            parts = Split(line, "|")
            
            If UBound(parts) >= 1 Then
                Dim toolbar: Set toolbar = DOpus.Create.Map
                toolbar("name") = Trim(parts(0))
                toolbar("command") = Trim(parts(1))
                
                toolbarList.push_back toolbar
                
                DebugOutput 2, "Loaded: " & toolbar("name") & " -> " & toolbar("command")
            End If
        End If
    Next
    
    Set ParseToolbarCommands = toolbarList
End Function

Function ExecuteToolbarCommand(scriptCmdData, toolbarCommand)
    ' Execute a single toolbar command
    On Error Resume Next
    
    Dim cmd: Set cmd = DOpus.Create.Command
    cmd.SetSourceTab scriptCmdData.func.sourcetab
    
    DebugOutput 1, "Executing: " & toolbarCommand
    cmd.RunCommand toolbarCommand
    
    If Err.Number <> 0 Then
        DebugOutput 1, "Error executing command: " & Err.Description
        ExecuteToolbarCommand = False
        Exit Function
    End If
    
    ExecuteToolbarCommand = True
    
    On Error Goto 0
End Function

Function OnRestoreAllToolbars(scriptCmdData)
    DebugOutput 1, "Restoring all toolbars..."
    
    Dim toolbarList: Set toolbarList = ParseToolbarCommands()
    Dim i, toolbar, executed
    
    executed = 0
    
    For i = 0 To toolbarList.count - 1
        Set toolbar = toolbarList(i)
        
        If ExecuteToolbarCommand(scriptCmdData, toolbar("command")) Then
            executed = executed + 1
            DebugOutput 1, "Executed: " & toolbar("name")
        End If
        
        ' Small delay between commands to let them process
        DOpus.Delay 50
    Next
    
    DOpus.Output "Executed " & executed & " of " & toolbarList.count & " toolbar command(s)"
End Function

Function OnShowToolbarCommands(scriptCmdData)
    Dim output: output = "Configured Toolbar Commands:" & vbCrLf & vbCrLf
    Dim toolbarList: Set toolbarList = ParseToolbarCommands()
    Dim i, toolbar
    
    For i = 0 To toolbarList.count - 1
        Set toolbar = toolbarList(i)
        output = output & (i + 1) & ". " & toolbar("name") & vbCrLf
        output = output & "   Command: " & toolbar("command") & vbCrLf & vbCrLf
    Next
    
    If toolbarList.count = 0 Then
        output = output & "No toolbar commands configured yet." & vbCrLf & vbCrLf
        output = output & "Configure commands in Settings > Preferences > Toolbars > Scripts" & vbCrLf
        output = output & "Edit the 'ToolbarCommands' field with format:" & vbCrLf
        output = output & "DisplayName|Toolbar NAME=ToolbarName STATE=position TOGGLE"
    End If
    
    DOpus.Output output
    
    ' Also show in dialog
    Dim dlg: Set dlg = DOpus.Dlg
    dlg.window = scriptCmdData.func.sourcetab.lister
    dlg.title = "Configured Toolbar Commands"
    dlg.message = output
    dlg.buttons = "OK"
    dlg.icon = "info"
    dlg.Show
End Function