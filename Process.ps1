$excel=new-object -com excel.application
$wb=$excel.workbooks.open("C:\Users\phandfield\Desktop\p regex\S.xlsx")
#$list = [System.Collections.ArrayList]::new()
$ControlContent = Get-Content "SettingsControl.txt"
$GeneralContent = Get-Content "SettingKeyValue.txt"

$Regex_ActionKeyList = "ActionName=""XXXXXXXXXX"",Keys=\(\(?(?:Key=)?([a-z0-9._]*),?([a-z0-9]*)=?(?:[a-z1-9]*)\)?,?\(?(?:Key=)?([a-z0-9._]*),?([a-z0-9]*)=?(?:[a-z1-9]*)\)?(?:.*)"
$Regex_MouseSensitiveList = "MouseSensitiveName=""XXXXXXXXXX"",MouseSensitivity=([0-9\.]*)(?:.*)"
$Regex_CustomInputSettins = "XXXXXXXXXX=([a-z]*)(?:.*)"
$Regex_AxisKeyList = "AxisName=""XXXXXXXXXX"",Scale=([0-9\.-]*),Keys=\(\(?(?:Key=)?([a-z0-9._]*),?([a-z0-9]*)=?(?:[a-z1-9]*)\)?,?\(?(?:Key=)?([a-z0-9._]*),?([a-z0-9]*)=?(?:[a-z1-9]*)\)?(?:.*)"
$RegexDefault = "XXXXXXXXXX=([a-z0-9\._]*)"

# First sheet
$sh=$wb.Sheets.Item(1)

$nbOfLoops = 300
for($i=2; $i -le $nbOfLoops; $i++) { 
    $display = $sh.Cells.Item($i,1).Value2
    $group = $sh.Cells.Item($i,2).Value2
    $Caption = $sh.Cells.Item($i,3).Value2
    $Name = $sh.Cells.Item($i,4).Value2
    $Key = $sh.Cells.Item($i,5).Value2
    $Path = $sh.Cells.Item($i,6).Value2
    $IsPosAxis = $sh.Cells.Item($i,7).Value2
    $Function = $sh.Cells.Item($i,8).Value2

    if($display -ne "x" -OR [string]::IsNullOrEmpty($Key)) { continue }

    $regex = ""
    Write-Host "$key... $i/$nbOfLoops"

    switch($Path)
    {
        ActionKeyList { 
            $regex = $Regex_ActionKeyList.Replace("XXXXXXXXXX", $key) 
            $r = [System.Text.RegularExpressions.Regex]::new($regex, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
            $match = $r.Match($ControlContent)

            if($match.Success) {
                $sh.Cells.Item($i,9).Value2 = $match.Groups[1].Value
                $sh.Cells.Item($i,10).Value2 = $match.Groups[2].Value
                $sh.Cells.Item($i,11).Value2 = $match.Groups[3].Value
                $sh.Cells.Item($i,12).Value2 = $match.Groups[4].Value
            } else {
                #$sh.Cells.Item($i,4).Value2 = "NO MATCH"
                Write-Host "No Match"
            }
        }
        MouseSensitiveList 
        { 
            $regex = $Regex_MouseSensitiveList.Replace("XXXXXXXXXX", $key) 
            $r = [System.Text.RegularExpressions.Regex]::new($regex, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
            $match = $r.Match($ControlContent)

            if($match.Success) {
                $sh.Cells.Item($i,9).Value2 = $match.Groups[1].Value
            } else {
                #$sh.Cells.Item($i,4).Value2 = "NO MATCH"
                Write-Host "No Match"
            }


        }
        CustomInputSettins { 
            $regex = $Regex_CustomInputSettins.Replace("XXXXXXXXXX", $key) 
            $r = [System.Text.RegularExpressions.Regex]::new($regex, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
            $match = $r.Match($ControlContent)

            if($match.Success) {
                $sh.Cells.Item($i,9).Value2 = $match.Groups[1].Value
            } else {
                #$sh.Cells.Item($i,4).Value2 = "NO MATCH"
                Write-Host "No Match"
            }

        }
        AxisKeyList { 
            $regex = $Regex_AxisKeyList.Replace("XXXXXXXXXX", $key) 
            $r = [System.Text.RegularExpressions.Regex]::new($regex, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
            $match = $r.Match($ControlContent)

            if($match.Success) {
                $sh.Cells.Item($i,9).Value2 = $match.Groups[1].Value
                $sh.Cells.Item($i,10).Value2 = $match.Groups[2].Value
                $sh.Cells.Item($i,11).Value2 = $match.Groups[3].Value
                $sh.Cells.Item($i,12).Value2 = $match.Groups[4].Value
                $sh.Cells.Item($i,13).Value2 = $match.Groups[5].Value
            } else {
                #$sh.Cells.Item($i,4).Value2 = "NO MATCH"
                Write-Host "No Match"
            }
        }
        default { 
            $Regex = $RegexDefault.Replace("XXXXXXXXXX", $key) 
            $r = [System.Text.RegularExpressions.Regex]::new($regex, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
            $match = $r.Match($GeneralContent)

            if($match.Success) {
                $sh.Cells.Item($i,9).Value2 = $match.Groups[1].Value
            } else {
                #$sh.Cells.Item($i,4).Value2 = "NO MATCH"
                Write-Host "No Match"
            }

        }
    }

    
}

$wb.Close($true)
$excel.Quit()
[void][Runtime.Interopservices.Marshal]::ReleaseComObject($excel)
