### How to clean all the repository recursively ?

For Unix/Linux/MacOS:
* bash
  ```
  find . -type d -exec sh -c 'cd "{}" && test -f Cargo.lock && (cargo clean; rm -f Cargo.lock)' \;
  ```

For Windows Powershell: 

* Latest Powershell Version:
  ```
  Get-ChildItem -Directory -Recurse | ForEach-Object { if (Test-Path "$_\Cargo.lock") { Set-Location $_; cargo clean; Remove-Item "Cargo.lock" -ErrorAction SilentlyContinue; Set-Location .. } }
  ```

* PowerShell 5.1 and earlier:
  ```
  Get-ChildItem -Recurse | Where-Object { $_.PSIsContainer } | ForEach-Object { if (Test-Path "$($_.FullName)\Cargo.lock") { Set-Location $_.FullName; cargo clean; Remove-Item "Cargo.lock" -ErrorAction SilentlyContinue; Set-Location .. } }
  ```

* Command Prompt(CMD)
  ```
  for /r %d in (.) do @if exist "%d\Cargo.lock" (cd /d "%d" & cargo clean & del /q "%d\Cargo.lock" & cd ..)
  ```


