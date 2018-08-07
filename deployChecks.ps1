Param( 
   [string]$AppUrl,
   [bool]$DoHealthCheck = $true,
   [bool]$DoSwaggerCheck = $true,
   [int]$RetryLimit = 5,
   [int]$RetrySleepSecs = 5

)

function CheckHealthUrl {
   param( [string] $baseUrl)

   try
   {
      $healthUrl = "$baseUrl/health"
      Write-Host "Checking Health Url: " $healthUrl
      $response = Invoke-RestMethod -Uri $healthUrl -TimeoutSec 30;
      Write-Host "Status code error: " $response.status_code;
      Write-Host $response.message;
      if ($response.status_code -ne 0) 
      {
         return 1;
      }
      else
      {
            return 0;
      }
   } catch {
      Write-Host "Error checking health: " $ApiUrl $_.Exception.Response.StatusCode.value__ ;
      Write-Host "StatusDescription:" $_.Exception;
   }
   return 1;
}

function CheckSwaggerUrl {
   param( [string] $baseUrl)


    try
   {
      $swaggerUrl = "$baseUrl/Swagger/v1/swagger.json"
      Write-Host "Checking Swagger Url $($swaggerUrl)"
      $response = Invoke-RestMethod -Uri $swaggerUrl -TimeoutSec 30;
      return 0;
   } catch {
      Write-Host "Error checking health: " $ApiUrl $_.Exception.Response.StatusCode.value__ ;
      Write-Host "StatusDescription:" $_.Exception;
   }
   return 1;
}

if ($DoHealthCheck -eq $true) 
{
   $retryCount = 0;
   while($true)
   {
      $exit_code = CheckHealthUrl($AppUrl);
      if($exit_code -ne 0) {
         if($retryCount -lt $RetryLimit)
         {
            $retryCount += 1;
            Write-Host "Request $retryCount of $RetryLimit failed.  Sleeping for $RetrySleepSecs seconds before next try." 
            Start-Sleep -Seconds $RetrySleepSecs;
         }
         else
         {
            exit 1; 
         }

      }
      else
      {
         break;
      }
   }
}

if ($DoSwaggerCheck -eq $true) 
{
   $retryCount =0;
   while($true)
   {
      $exit_code = CheckSwaggerUrl($AppUrl);
      if($exit_code -ne 0) {
         if($retryCount -lt $RetryLimit)
         {
            $retryCount += 1;
            Write-Host "Request $retryCount of $RetryLimit failed.  Sleeping for $RetrySleepSecs seconds before next try." 
            Start-Sleep -Seconds $RetrySleepSecs;
         }
         else
         {
            exit 1; 
         }
      }
      else
      {
         exit 0;
      }

   }
}

exit 0;
