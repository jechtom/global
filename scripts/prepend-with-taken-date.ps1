$photos = Get-ChildItem "*" -Include '*.jpg', '*.mov'

function PrependPhotoWithTime($file) {

    if($file.Name -match "^\d{4}\d{2}\d{2}-\d{4}_") {
        Write-Host ". Skipping: $file"
        return
    }
    else {
        Write-Host "Processing: $file"
    }

    $shellObject = New-Object -ComObject Shell.Application
    $directoryObject = $shellObject.NameSpace($file.Directory.FullName)
    $fileObject = $directoryObject.ParseName($file.Name)

    $dateTaken = $fileObject.ExtendedProperty("System.Photo.DateTaken")

    if(-not $dateTaken) {
        # use modified date - works with MOV files and JPG files edited in iPhone
        $dateTaken = $fileObject.ExtendedProperty("System.DateModified")
    }

    if(-not $dateTaken) {
        Write-Host "Can't find taken date for: $file"
        return
    }

    $prefix = $dateTaken.ToString("yyyyMMdd-HHmm_")

    $newFileName = $prefix + $file.Name

    Write-Host "Changing $file to $newFileName"
    $file | Rename-Item -NewName $newFileName
}

$photos | Foreach {
    PrependPhotoWithTime $_
}

Write-Host "Done."