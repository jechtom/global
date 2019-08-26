
$release = (Get-ItemProperty "HKLM:SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full").Release;
$versions = @{
".NET Framework 4.5"   = 378389;
".NET Framework 4.5.1" = 378758;
".NET Framework 4.5.2" = 379893;
".NET Framework 4.6"   = 393297;
".NET Framework 4.6.1" = 394271;
".NET Framework 4.6.2" = 394806;
".NET Framework 4.7"   = 460805;
".NET Framework 4.7.1" = 461310;
".NET Framework 4.7.2" = 461814;
".NET Framework 4.8"   = 528049
};
$versions.Keys | 
    % { [PSCustomObject]@{Name=$_; Release=$versions[$_]; Installed=$release; IsPresent=$release -ge $versions[$_]} } | 
    Sort-Object -Property Release | Format-Table -AutoSize