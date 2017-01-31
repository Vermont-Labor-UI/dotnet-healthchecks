Param( 
   [string]$AppUrl,
   [bool]$DoHealthCheck = $true,
   [bool]$DoSwaggerCheck = $true

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

if ($DoHealthCheck -eq $true) {
   $exit_code = CheckHealthUrl($AppUrl);
   if($exit_code -ne 0) {
      exit 1; 

   }
}

if ($DoSwaggerCheck -eq $true) {
   $exit_code = CheckSwaggerUrl($AppUrl);
   if($exit_code -ne 0) {
      exit 1;
   }
}

exit 0;
