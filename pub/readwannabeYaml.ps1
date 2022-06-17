$content = Get-Content .\1.yaml

foreach($line in $content){
    $cmd  = $line.Replace(" ","").split(":")[0]
    $value = $line.Replace(" ","").split(":")[1]
    switch($cmd){

        
    }
}