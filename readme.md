## Offensive Security / Red-Teaming

<p align="center">
  <img src="https://i.pinimg.com/originals/28/d9/a5/28d9a5107af5d4c4da117c05b4393b83.gif" />
</p>

TTP's, collection of useful tools for pen testing, random notes and knowledge base.

> [!WARNING]
>
> DISCLAIMER:  Use responsibly and within legal parameters.
> Unauthorized use, including but not limited to attacking 
> systems without explicit owner consent, is strictly prohibited 
> and violates international cybercrime laws.

> [!NOTE]
>
> Proof of concept and known exploits reside in this directory,
> be advised that if you have anti-malware it will find stuff here
> (not malicious until used...).

> [!WARNING]
> Tip: Don't execute malware samples on your host machine, use a VM or container to execute for analysis.

Pro-tip:

Static/Behavioral analysis using a sandbox is always a good option (execute here, before you have to reimage).

https://tria.ge/submit/file

Example: red-team/tools/AsyncRAT/AsyncRAT-C#/Server/Resources/xmrig.bin: Win.Coinminer.Generic-7151250-0 FOUND

https://tria.ge/250522-ywa1psdj7w

Bulk analysis via cli (requires a researcher account to utilize the api). https://tria.ge/account/researcher_apply

https://github.com/robert-iw3/tooling/tree/test/vuln-scanning/triage

```sh
GitHub/tooling/red-team/exploits/CVE-2024-3094/xz-cve-2024-3094/liblzma.so.5.6.1.m: Unix.Backdoor.LZMABackdoor-10026037-0 FOUND
GitHub/tooling/red-team/ttps/Assembly/Winx64/payloads/6.meterpreter/meterpreter_stageless.bin: Win.Exploit.D388a-9756522-0 FOUND
GitHub/tooling/red-team/ttps/C#/DInvoke/CreateProcess_DInvoke/ConsoleApp1/ConsoleApp1/bin/Debug/netcoreapp3.1/DInvoke.dll: Win.Packed.Bulz-9964742-0 FOUND
GitHub/tooling/red-team/ttps/C#/DInvoke/MessageBoxW_DIvoke/MessageBoxW_DIvoke/bin/Debug/netcoreapp3.1/DInvoke.dll: Win.Packed.Bulz-9964742-0 FOUND
GitHub/tooling/red-team/ttps/C#/DInvoke/MessageBoxW_DIvoke/MessageBoxW_DIvoke/obj/Debug/netcoreapp3.1/DInvoke.dll: Win.Packed.Bulz-9964742-0 FOUND
GitHub/tooling/red-team/ttps/C#/DInvoke/Syscalls_DInvoke/ConsoleApp1/ConsoleApp1/bin/Debug/netcoreapp3.1/DInvoke.dll: Win.Packed.Bulz-9964742-0 FOUND
GitHub/tooling/red-team/ttps/C#/HookBypass/ConsoleApp1/bin/Debug/netcoreapp3.1/DInvoke.dll: Win.Packed.Bulz-9964742-0 FOUND
GitHub/tooling/red-team/ttps/malware_research/PayloadDownloader/calc.ico: Win.Trojan.MSShellcode-6 FOUND
GitHub/tooling/red-team/ttps/malware_research/PayloadInResource/PayloadInResource/PayloadInResource.aps: Win.Trojan.MSShellcode-6 FOUND
GitHub/tooling/red-team/ttps/malware_research/PayloadInResource/PayloadInResource/calc.ico: Win.Trojan.MSShellcode-6 FOUND
GitHub/tooling/red-team/ttps/techniques/Reverse_Shell/Powercat_Rev_Shell.txt: Win.Trojan.PowercatDownloader-9840813-0 FOUND
GitHub/tooling/red-team/ttps/techniques/Reverse_Shell/Reverse_TCP_Shell_SRV_Examples.ps1: Win.Downloader.Clickfix-10044129-0 FOUND
GitHub/tooling/red-team/ttps/techniques/Reverse_Shell/one_line_PS_Rev_Shell_2.txt: Win.Trojan.PowershellReverseShellOneLine-9840826-0 FOUND
GitHub/tooling/red-team/ttps/techniques/Reverse_Shell/one_line_PS_Rev_Shell_4.txt: Win.Trojan.MSShellcode-88 FOUND
GitHub/tooling/red-team/ttps/APT-Attack-Simulation-study/North Koreans APT/Velvet Chollima/Fake-Captcha technique.html: Html.Phishing.Emmenhtal-10044030-0 FOUND
GitHub/tooling/red-team/ttps/APT-Attack-Simulation-study/Russian APT/APT28-Adversary-Simulation/parliament_rew.xlsx: Doc.Exploit.CVE_2021_40444-9891528-0 FOUND
GitHub/tooling/red-team/tools/AsyncRAT/AsyncRAT-C#/Server/Resources/xmrig.bin: Win.Coinminer.Generic-7151250-0 FOUND
GitHub/tooling/red-team/tools/RedirectThread/ShellcodeExamples/w10-x64-calc-shellcode-msfvenom.bin: Win.Trojan.MSShellcode-6 FOUND
GitHub/tooling/red-team/tools/Check-LocalAdminHash/Check-LocalAdminHash.ps1: Win.Exploit.CVE_2017_0144-7404604-0 FOUND
```
