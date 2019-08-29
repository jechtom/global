# This script returns installed version of .NET 4.*
# from github.com/jechtom/global/scripts/netver.ps1
# Data source: https://github.com/dotnet/docs/blob/master/docs/framework/migration-guide/how-to-determine-which-net-framework-updates-are-installed.md

$release = (Get-ItemProperty "HKLM:SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full").Release;
$versions = @{
".NET Framework 4.5"   = 378389;
".NET Framework 4.5.1" = 378675;
".NET Framework 4.5.2" = 379893;
".NET Framework 4.6"   = 393295;
".NET Framework 4.6.1" = 394254;
".NET Framework 4.6.2" = 394802;
".NET Framework 4.7"   = 460798;
".NET Framework 4.7.1" = 461308;
".NET Framework 4.7.2" = 461808;
".NET Framework 4.8"   = 528040
};
$versions.Keys | 
    % { [PSCustomObject]@{Name=$_; Release=$versions[$_]; Installed=$release; IsPresent=$release -ge $versions[$_]} } | 
    Sort-Object -Property Release | Format-Table -AutoSize