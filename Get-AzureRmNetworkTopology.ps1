function CreateSVG{
$script:SVG = @"
<svg width="2000" height="2000" xmlns="http://www.w3.org/2000/svg">
<title>topology</title>

"@
}

function AddCircle{
param([int]$x, [int]$y, [int]$r)
$script:SVG += @"
<circle cx="$x" cy="$y" r="$r" style="stroke: black; fill: none"/>

"@
}

function AddRectangle{
param([int]$x, [int]$y, [int]$w, [int]$h)
$script:SVG += @"
<rect x="$x" y="$y" width="$w" height="$h" style="stroke: black; fill: none"/>

"@
}

function AddLine{
param([int]$x, [int]$y, [int]$x2, [int]$y2)
$script:SVG += @"
<line x1="$x" y1="$y" x2="$x2" y2="$y2" style="stroke: black; fill: none"/>

"@
}

function AddText{
param([int]$x, [int]$y,[String]$Text)
$script:SVG += @"
<text x="$x" y="$y">$Text</text>

"@
}

function CloseSVG{
$script:SVG += @"
</svg>
"@
}

function SaveSVG{
    $script:SVG | Out-File "$env:USERPROFILE\Desktop\NetworkTopology.svg"
}

#Param
$Distance_y = 100
$Vnet_h = 50

#Get Network Info
$AzureRmVirtualNetwork = Get-AzureRmVirtualNetwork
$AzureRmVirtualNetworkGateway = Get-AzureRmResourceGroup | Get-AzureRmVirtualNetworkGateway
$AzureRmVirtualNetworkGatewayConnection = Get-AzureRmResourceGroup | Get-AzureRmVirtualNetworkGatewayConnection
$AzureRmLocalNetworkGateway = Get-AzureRmResourceGroup | Get-AzureRmLocalNetworkGateway

#Generate VNet HashTable
$AzureRmVirtualNetworkHashTable = @{}
for($i = 0; $i -lt $AzureRmVirtualNetwork.Count; $i++){
    $AzureRmVirtualNetworkHashTable.Add(
    $AzureRmVirtualNetwork[$i].Id, [PSCustomObject]@{
        Property = $AzureRmVirtualNetwork[$i]
        Index = "$i"
        })
}

#Generate VNet Gateway HashTable
$AzureRmVirtualNetworkGatewayHashTable = @{}
for($i = 0; $i -lt $AzureRmVirtualNetworkGateway.Count; $i++){
    $AzureRmVirtualNetworkGatewayHashTable.Add(
    $AzureRmVirtualNetworkGateway[$i].Id, [PSCustomObject]@{
        Property = $AzureRmVirtualNetworkGateway[$i]
        Index = "$i"
        })
}

#Generate Local Gateway HashTable
$AzureRmLocalNetworkGatewayHashTable = @{}
for($i = 0; $i -lt $AzureRmLocalNetworkGateway.Count; $i++){
    $AzureRmLocalNetworkGatewayHashTable.Add(
    $AzureRmLocalNetworkGateway[$i].Id, [PSCustomObject]@{
        Property = $AzureRmLocalNetworkGateway[$i]
        Index = "$i"
        })
}

#Generate SVG
CreateSVG

#Draw VNET
for($i = 0; $i -lt $AzureRmVirtualNetwork.Count;$i++){
    AddText -x 100 -y (($i + 1) * $Distance_y - 5) -Text $($AzureRmVirtualNetwork[$i].Name)
    AddRectangle -x 100 -y (($i + 1) * $Distance_y) -w 200 -h $Vnet_h
}

#Draw LocalGateway
for($i = 0; $i -lt $AzureRmLocalNetworkGateway.Count;$i++){
    AddText -x 500 -y (($i + 1) * $Distance_y - 5) -Text $($AzureRmLocalNetworkGateway[$i].Name)
    AddRectangle -x 500 -y (($i + 1) * $Distance_y) -w 200 -h $Vnet_h
    AddCircle -x 500 -y ((($i + 1) * $Distance_y) + 25) -r 10
}

#Draw Gateway
for($i = 0; $i -lt $AzureRmVirtualNetworkGateway.Count;$i++){
    [int]$index = $AzureRmVirtualNetworkHashTable.$($AzureRmVirtualNetworkGatewayHashTable."$($AzureRmVirtualNetworkGatewayConnection[$i].VirtualNetworkGateway1.Id)".property.ipconfigurations.Subnet.Id.Replace("/subnets/GatewaySubnet","")).Index
    AddCircle -x 300 -y ((($index + 1) * $Distance_y) + $Vnet_h / 2) -r 10
}

#Draw Connection
for($i = 0; $i -lt $AzureRmVirtualNetworkGatewayConnection.Count;$i++){
    [int]$index = $AzureRmVirtualNetworkHashTable.$($AzureRmVirtualNetworkGatewayHashTable."$($AzureRmVirtualNetworkGatewayConnection[$i].VirtualNetworkGateway1.Id)".property.ipconfigurations.Subnet.Id.Replace("/subnets/GatewaySubnet","")).Index
    
    if($AzureRmLocalNetworkGatewayHashTable."$($AzureRmVirtualNetworkGatewayConnection[$i].LocalNetworkGateway2.Id)" -ne $null){
        [int]$index2 =  $AzureRmLocalNetworkGatewayHashTable."$($AzureRmVirtualNetworkGatewayConnection[$i].LocalNetworkGateway2.Id)".Index
        AddLine -x 300 -y (($index + 1) * $Distance_y + $Vnet_h / 2) -x2 500 -y2 ((($index2 + 1) * $Distance_y) + $Vnet_h / 2)
    }else{
        #V2V VPN / ExpressRoute
        #$AzureRmLocalNetworkGatewayHashTable."$($AzureRmVirtualNetworkGatewayConnection[$i].VirtualNetworkGateway2.Id)".property.Id
    }
}

CloseSVG
SaveSVG