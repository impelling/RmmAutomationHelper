function New-RmmLogEntry {
    <#
    .SYNOPSIS
        Create a new log entry in the event log, a file, or both.
    .DESCRIPTION
        Used to keep track of automation tasks within RMM or MDM. This function will log a message to the event log, a file, or both.
    .NOTES
        It is possible to write to the event log without admin rights, if the log and source both exist. If running as system or admin, the
        event log and source will be created if they do not exist.
    .PARAMETER Message
        The message to log. Will have a datestamp prefix if written to a file (Can be skipped with -SkipDatetime)
    .PARAMETER Destination
        The destination of the log entry. Can be Event, File, or Both.
    .PARAMETER Level
        The log level of the entry. Can be Information, Warning, or Error.
    .PARAMETER LogDirectory
        The directory where the log file will be stored. Uses C:\ProgramData\RmmAutomationHelper by default
    .PARAMETER Subject
        Used for the event log source and/or log file name excluding the extension. Uses RmmAutomationHelper by default.
    .PARAMETER EventSource
        The event log source. Uses RmmAutomationHelper by default.
    .PARAMETER EventLogName
        The event log name. Uses NinjaOneAutomation by default.
    .PARAMETER EventId
        The EventID to use when logging to the event log.
    .PARAMETER Category
        The category ID to use when logging to the event log.
    .PARAMETER SkipDatetime
        Skip the datestamp prefix on the message written to the log file.
    .EXAMPLE
        New-RmmLogEntry -Message 'This is a test message' -Destination 'Both' -Level 'Information'
        Will log the message to the event log and a file with the level of Information.
    #>
    [CmdletBinding()]
    param (
        # The message to log
        [Parameter(Mandatory = $true)]
        [string]$Message,
        # Destination of the log entry
        [Parameter()]
        [ValidateSet('Event', 'File', 'Both')]
        [string]$Destination = 'File',
        # The log level of the entry
        [Parameter()]
        [ValidateSet('Information', 'Warning', 'Error')]
        [string]$Level = 'Information',
        # The directory where the log file will be stored
        [Parameter()]
        [string]$LogDirectory = 'C:\ProgramData\RmmAutomationHelper',
        # Used for the event log source and/or log file name excluding the extension
        [Parameter()]
        [string]$Subject = 'RmmAutomationHelper',
        # The event log name
        [Parameter()]
        [string]$EventLogName = 'NinjaOneAutomation',
        # The EventID to use when logging to the event log
        [Parameter()]
        [int]$EventId = 1001,
        # The category ID to use when logging to the event log
        [Parameter()]
        [int]$Category,
        # Skip the datetime prefix on message written to the log file
        [Parameter()]
        [switch]$SkipDatetime
    )

    begin {
        # Create the log structure if file output is required
        if ($Destination -in 'File', 'Both') {
            if (-not (Test-Path -Path $LogDirectory)) {
                Write-Verbose "Creating log directory $LogDirectory"
                New-Item -Path $LogDirectory -ItemType Directory -Force | Out-Null
            }
        }
        # Create the event log and source if event log output is required
        if ($Destination -in 'Event', 'Both') {
            $IsAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

            if ($IsAdmin) {
                # test if the eventlog exists
                try {
                    Get-EventLog -LogName $EventLogName -ErrorAction SilentlyContinue | Out-Null
                }
                catch {
                    Write-Verbose 'Event log does not exist, creating it'
                    try {
                        New-EventLog -LogName $EventLogName -Source $Subject
                    }
                    catch {
                        Write-Error 'Failed to create event log.'
                        return
                    }
                }
                if (-not [System.Diagnostics.EventLog]::SourceExists($Subject)) {
                    Write-Verbose 'Event source does not exist, creating it'
                    try {
                        # Create a new source on the $EventLogName log
                        [System.Diagnostics.EventLog]::CreateEventSource($Subject, $EventLogName)
                    }
                    catch {
                        Write-Error 'Failed to create event log.'
                        return
                    }
                }
            }

        }
    }

    process {


        # Log to the event log
        if ($Destination -in 'Event', 'Both') {
            $EventParams = @{
                LogName = $EventLogName
                Source = $Subject
                EventId = $EventId
                EntryType = $Level
                Message = $Message
            }
            if ($Category) {
                $EventParams.Category = $Category
            }
            Write-Verbose "Logging to event log $EventLogName with source $Subject and message $Message"
            try {
                Write-EventLog @EventParams -ErrorAction SilentlyContinue
            }
            catch {
                if ($Destination -eq 'Event') {
                    Write-Warning 'Failed to write to event log, attempting to write to file instead.'
                    $Destination = 'File'
                }
                else {
                    Write-Verbose 'Failed to write to event log.'
                }
            }
        }

        # Log to the file
        if ($Destination -in 'File', 'Both') {
            # Create the log message
            $LogFile = Join-Path -Path $LogDirectory -ChildPath "$Subject.log"
            if (-not $SkipDatetime) {
                $LogMessage = '[{0:yyyy-MM-dd HH:mm:ss}] {1}' -f (Get-Date), $Message
            }
            Write-Verbose "Logging to file $LogFile with message $LogMessage"
            Add-Content -Path $LogFile -Value $LogMessage
        }
    }

    end {

    }
}