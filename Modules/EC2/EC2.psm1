function Get-EC2InstancePassword($machine, $region = "eu-west-1") {
    $instance_id = Get-Content .\.vagrant\machines\$machine\aws\id
    ec2-get-password $instance_id -k $env:AWS_PRIVATE_KEY_PATH --region $region
}

Set-Alias ec2Password Get-EC2InstancePassword

Export-ModuleMember -Alias * -Function *