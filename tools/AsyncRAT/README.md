<img src="https://i.imgur.com/KbomEco.png">

# AsyncRAT
AsyncRAT is a Remote Access Tool (RAT) designed to remotely monitor and control other computers through a secure encrypted connection

# Included projects
##### This project includes the following
- Plugin system to send and receive commands
- Access terminal for controlling clients
- Configurable client manageable via Terminal
- Log server recording all significant events

##### Features Include:
- Client screen viewer & recorder
- Client Antivirus & Integrity manager
- Client SFTP access including upload & download
- Client & Server chat window
- Client Dynamic DNS & Multi-Server support (Configurable)
- Client Password Recovery
- Client JIT compiler 
- Client Keylogger 
- Client Anti Analysis (Configurable)
- Server Controlled updates
- Client Antimalware Start-up 
- Server Config Editor
- Server multiport receiver (Configurable)
- Server thumbnails 
- Server binary builder (Configurable)
- Server obfuscator (Configurable)
- And much more!

### Technical Details
The following online servers / resources are used in this project
* [pastebin.com] - used for the "PasteBin" option in client builder
* [github.com] - used for downloading and uploading changes to the project
### Installation & Deployment

AsyncRAT requires the [.Net Framework](https://dotnet.microsoft.com/download/dotnet-framework/net46) v4 (client) and v4.6+ (server) to run.

```diff
- to compile this project(s) visual studio 2019 or above to is required
```

### Plugins
Currently the program makes use of several integrated DLL's (see below for more details)

| Plugin | Source |
| ------ | ------ |
| StealerLib | [gitlab.com/thoxy/stealerlib] |

