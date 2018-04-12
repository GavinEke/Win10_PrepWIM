#Requires -Version 5.1
#Requires -RunAsAdministrator
#Requires -Modules Dism

#region Variables
$SourceImage = 'D:\sources\install.esd'
$Win10Version = 'Windows 10 Pro'
$DestinationImage = '\images\install.wim'
$MountPath = '\mount'
[regex]$DisableFeatureRegex = 'SMB1Protocol|MicrosoftWindowsPowerShellV2|MicrosoftWindowsPowerShellV2Root'
[regex]$RemoveAppxRegex = 'Microsoft.BingWeather|Microsoft.GetHelp|Microsoft.Getstarted|Microsoft.MicrosoftOfficeHub|Microsoft.MicrosoftSolitaireCollection|Microsoft.SkypeApp|Microsoft.WindowsFeedbackHub|Microsoft.XboxApp|Microsoft.ZuneMusic|Microsoft.ZuneVideo'
$WinProductKey = 'W269N-WFGWX-YVC9B-4J6C9-T83GX'
#endregion

$Win10Pro = Get-WindowsImage -ImagePath 'D:\sources\install.esd' | Where-Object {$_.ImageName -eq $Win10Version}
Export-WindowsImage -SourceImagePath 'D:\sources\install.esd' -SourceIndex $Win10Pro.ImageIndex -DestinationImagePath $DestinationImage -CompressionType Max -CheckIntegrity
Mount-WindowsImage -ImagePath $DestinationImage -Index 1 -Path $MountPath
Get-WindowsOptionalFeature -Path $MountPath | Where-Object {$_.FeatureName -match $DisableFeatureRegex} | Disable-WindowsOptionalFeature
Get-AppxProvisionedPackage -Path $MountPath | Where-Object {$_.DisplayName -match $RemoveAppxRegex} | Remove-AppxProvisionedPackage
Set-WindowsProductKey -Path $MountPath -ProductKey $WinProductKey
Dismount-WindowsImage -Path $MountPath -Save
