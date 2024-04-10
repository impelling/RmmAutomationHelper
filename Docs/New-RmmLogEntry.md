---
external help file: RMMAutomationHelper-help.xml
Module Name: RMMAutomationHelper
online version:
schema: 2.0.0
---

# New-RmmLogEntry

## SYNOPSIS
Create a new log entry in the event log, a file, or both.

## SYNTAX

```
New-RmmLogEntry [-Message] <String> [[-Destination] <String>] [[-Level] <String>] [[-LogDirectory] <String>]
 [[-Subject] <String>] [[-EventLogName] <String>] [[-EventId] <Int32>] [[-Category] <Int32>] [-SkipDatetime]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Used to keep track of automation tasks within RMM or MDM.
This function will log a message to the event log, a file, or both.

## EXAMPLES

### EXAMPLE 1
```
New-RmmLogEntry -Message 'This is a test message' -Destination 'Both' -Level 'Information'
```

Will log the message to the event log and a file with the level of Information.

## PARAMETERS

### -Message
The message to log.
Will have a datestamp prefix if written to a file (Can be skipped with -SkipDatetime)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Destination
The destination of the log entry.
Can be Event, File, or Both.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: File
Accept pipeline input: False
Accept wildcard characters: False
```

### -Level
The log level of the entry.
Can be Information, Warning, or Error.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: Information
Accept pipeline input: False
Accept wildcard characters: False
```

### -LogDirectory
The directory where the log file will be stored.
Uses C:\ProgramData\RmmAutomationHelper by default

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: C:\ProgramData\RmmAutomationHelper
Accept pipeline input: False
Accept wildcard characters: False
```

### -Subject
Used for the event log source and/or log file name excluding the extension.
Uses RmmAutomationHelper by default.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: RmmAutomationHelper
Accept pipeline input: False
Accept wildcard characters: False
```

### -EventLogName
The event log name.
Uses NinjaOneAutomation by default.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: NinjaOneAutomation
Accept pipeline input: False
Accept wildcard characters: False
```

### -EventId
The EventID to use when logging to the event log.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: 1001
Accept pipeline input: False
Accept wildcard characters: False
```

### -Category
The category ID to use when logging to the event log.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -SkipDatetime
Skip the datestamp prefix on the message written to the log file.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
It is possible to write to the event log without admin rights, if the log and source both exist.
If running as system or admin, the
event log and source will be created if they do not exist.

## RELATED LINKS
