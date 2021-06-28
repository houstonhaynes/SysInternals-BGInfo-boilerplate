    winmgt = "winmgmts:{impersonationLevel=impersonate}!//"

    Set oWMI_Qeury_Result = GetObject(winmgt).InstancesOf("Win32_OperatingSystem")

    For Each oItem in oWMI_Qeury_Result
    iFreeMemory   = oItem.FreePhysicalMemory
    Next
    iFreeMemory = Round(iFreeMemory/(1024))

    Echo "" & iFreeMemory & " MB"