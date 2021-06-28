# BGInfo System Snapshot

I'm a big fan of Sysinternals, and the BGInfo applet was particularly useful. It's a long-standing tool that's commonly deployed on servers for admins that may log in to multiple sessions across a cluster. It provides the name and status of the targeted system at a glance. 

![BGInfo on Windows background image](/images/BGInfo_screengrab.png)

During the WSL2 beta I got into creating an optimized profile for display on my desktop. And while I thought I'd eventually get rid of it, it's just *handy* to have this info on screen, for at-a-glance simiplicity or to run as a checksum against other monitoring tools.

The part that I really like is the ability to eyeball the container load while also looking at overall CPU and GPU load. The Hyper-V info shows what's going on with the containers in WSL2 and gives me an overall view of CPU separate from those workloads. I was running a *lot* of GPU-based machine learning processes and wanted to know where the "heat" was coming from. I would sometimes get a thermal throttling state and this would be handy for spotting the culprit. So if this seems like it might be useful to tuck away on your desktop, feel free to set it up - and modify it to suit your needs.

## Assets

There are a handful of scripts and artifacts that get places in various nooks and crannies on your system for this to operate. It's a bit of a Rube Goldberg machine - but when configured it's fire-and-forget easy to use. 

## Asset Placement and Tweaks

> See the scripts folder for the assets you'll need. I simply placed them in my own Documents folder but you can place them wherever you like and adjust the paths accordingly.

1. Download [Sysinternals](https://docs.microsoft.com/en-us/sysinternals/downloads/sysinternals-suite) 
1. Unzip SysinternalsSuite.zip and place folder in your "Program Files" directory (see "Permissions" below)
1. Right-click BGInfo.exe and select Properties. Go to the "Security" and Administrators.
1. In the Permissions window select "Adminstrators" and select "Full Control" in the lower window.
1. Select "OK" through those windows to commit the change.
1. Place config.bgi and freememory.vbs in a folder (I put it in my "Documents")

![BGInfo app permissions](/images/BGInfo_app-set-permission.png)

> As noted above - you can place the individual scripts wherever you like, so long as the "BGInfo_task.xml" lists the appropriate named path to reach them wherever you decide to put them on your system.

```xml
<Actions Context="Author">
  <Exec>
    <Command>"C:\Program Files\SysinternalsSuite\Bginfo.exe"</Command> 
    <Arguments>C:\Users\[USERID]\Documents\config.bgi /SILENT /NOLICPROMPT /TIMER:0</Arguments>
  </Exec>
</Actions>

```

7. Right-click and "Open" config.bgi and use the dialog to navigate to C:\Program Files\SysinternalsSuite\BGInfo.exe - and set it as the default application.
1. Under Fields click "Custom".
9. In the User Defined Fields dialog select "Free Memory" and select "Edit..."
10. Ensure the path leads to the location of your "freememory.vbs" file
11. Commit the changes and back in the main BGInfo window click the "Apply" button to check that background image resets with updated systems info listed. (check "Snapshot Time")

![vbs path location](/images/BGInfo_vbs-modify-path.png)

## Permissions

> 90% of the questions I get when someone is putting this on their system eventually comes back to either paths or permissions.

Many of the wrinkles in this process require that you're logged in as local admin, so when running Task Scheduler you'll do so as adminstrator, and some of the function configuration below requires setting up the task to run with elevated priviledges. So if you encounter an issue in the process, check that area first.

1. Per standard Windows practice, modifying files/folders in the "Program Files" folder required admin access. You *can* simply choose to put these files somewhere else - just know that you'll be modifying almost every script/element "under the hood" to reflect that change in convention. YMMV
1. Task Scheduler must run as admin, and the permission used to run the script should be set to local admin. See the notes on that process below.

![Task import](/images/BGInfo_import-task.png)

## Task Scheduler Setup

1. Open Task Scheduler (as administrator) using the Windows start menu.
1. After the standard set of tasks load, create a new folder under "Task Scheduler Library" called "BGTasks"
1. Right click in the empty window frame and click "Import Task". 
1. Select BGInfo_task and import.
1. In the Properties window select "Change User or Group" and ensure that local machine "Administrators" is chosen.
1. Select "Run with highest priviledges" and confirm the dialog window.
1. Click on the "Run" button in the side window to the right and check that "Snapshot Time" updates.

![Set task properties](/images/BGInfo_set-task-properties.png)

## Runtime

So now the image should update every 15 minutes - OR - when HyperV changes status. You can also right-click and open config.bgi and click "Apply" to force a re-pole for data and refresh of the table. 

## Extra Credit: WSL2 Processor Affinity

If you don't change the WSL2 processor affinity then you'll see a LOOOONG list of 0s under "Hyper V Virt Pct". I have a habit of putting a .wslconfig file in my "Documents" folder which defines the amount of RAM and number of V-cores that HyperV/WSL can use. Simply there's more information on that [by following this link](https://docs.microsoft.com/en-us/windows/wsl/wsl-config#configure-global-options-with-wslconfig). I'm sure this and other features will be under review as I settle in with local dev workloads.

As usual, if anyone has any tweaks, advice or questions please feel free to let me know!