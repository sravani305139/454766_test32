function close_req{
param(

$number,
[string]$Notes
)

try{


$Notes



#$Task_sysid = "e8ba53b04f4433000f47417da310c76d"

#work_notes to be updated

$work_notes = $notes


#state to Closed completed with status 3
$close_state = "3"

#Updated Assignment group

#Reading from Json
$Configfile = Get-Content $jsonpath | ConvertFrom-Json
$user = $Configfile.Username
$InstanceName = $Configfile.Instance_name
$state = $Configfile.state
$assignment_group_update  = $Configfile.re_Assignment_group
    
#password
#$securePwd = Read-Host -AsSecureString -Prompt "Enter the password of Service Now for Instance $InstanceName"
    #$pass =[Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePwd))
    
$key_path = "$folder_path\Conf\Pass.txt"
if(!(Test-Path $key_path))
{
    $Password = Read-Host -AsSecureString  "Enter password" | ConvertFrom-SecureString | Out-File $key_path
}

$user = "sravani"
    #$Password = Read-Host -AsSecureString  "Enter password" | ConvertFrom-SecureString | Out-File "D:\powershell\client\packages\Service_Request\Scripts\Pass.txt"
    
$SecurePassword = Get-Content $key_path | ConvertTo-SecureString
$pass = (New-Object PSCredential $user,$SecurePassword).GetNetworkCredential().Password
        
        $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $user, $pass)))

        # Set proper headers
        $headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
        $headers.Add('Authorization',('Basic {0}' -f $base64AuthInfo))
        $headers.Add('Accept','application/json')
        $headers.Add('Content-Type','application/json')

        $InstanceName = "https://dev50379.service-now.com"
        # Specify endpoint uri
        $first = "$InstanceName/api/now/table/sc_task/"
        $last = "?sysparm_fields=number%2Cstate"
        
        $uri = $first+$Task_sysid+$last
        # Specify HTTP method
        $method = "put"

        # Specify request body
        $body = "{""work_notes"":""$work_notes"",""state"":""$close_state"",""assignment_group"":""$assignment_group_update"",""close_code"": ""4"",""close_notes"" : ""Resolving"" }"

        # Send HTTP request
        $response = Invoke-WebRequest -Headers $headers -Method $method -Uri $uri -Body $body

        # Print response
        $response.RawContent
        $LogWritter+="`r`n"+(Get-Date).ToUniversalTime().ToString("yyyy_MM_dd_HH_mm_ss")+" updating incident with following work notes `r`n $response `r`n";
        $LogWritter 
        Write-Host "Task updated successfully"
      }
catch{
    $Error_msg = $_
    $Error_msg
    }

 

}
function Verify_XML{
param($path)
try{
      $sourceDirectory = $path
        $xml_filelist = Get-ChildItem $sourceDirectory -Filter *.xml 


        if($xml_filelist.Count -ge 0){
           # echo "xml files exists"

            foreach($file in $xml_filelist)
                {
                $xml_file = $sourceDirectory+$file.Name
                [xml]$xml_data = Get-content $xml_file
                $jsonpath = "$folder_path\Conf\keys.json"
                if(((Test-Path $jsonpath) -eq $false) -and ((Get-Content $jsonpath) -eq $Null)){
                    Write-Logs -message "Enter the values in the jsonkeys.json file" 
                    Exit;
                }
                else{
                    #Write-Host "checking to map solutions"
                    $
                   # Start-Job powershell '+ Flow + ' -Number ' + Number + ' -ticket_type ' + "\"" + ticket_type + "\""
                    #Write-Host $map_solution[4]
            
                }
            }
            
    
       

      }
    }
    catch{
        $_
    }  

}
function validate_output_files{
param($path)
$sourceDirectory = $path
$output_filelist = Get-ChildItem $sourceDirectory -Filter *.txt
if($output_filelist.Count -ge 0){
    foreach($file in $output_filelist){
        $out_file = $sourceDirectory+$file.Name
        $out_data = Get-content $out_file
        Write-Host $out_data
        Write-Host $out_data[-2]
        $start_time = $out_data[0]
        $task_num = $out_data[1]
        $task_pid = $out_data[2]
        $task_notes = $out_data[3..($out_data.length - 3)]
        $task_result = $out_data[-2]
        $end_time= $out_data[-1]
        
        if($task_result -like "*executed*"){
        #close task
        }
        if($task_result -like "*escalate*"){
        #re-assign task
        }
       
    
    }

}
}
$trigger_solutions = close_req -number SCTASK0010344 -Notes "resolving"
$trigger_solutions