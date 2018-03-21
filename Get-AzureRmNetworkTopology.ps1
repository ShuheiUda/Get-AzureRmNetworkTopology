function CreateSVG{
$script:SVG = @"
<svg width="5000" height="5000" xmlns="http://www.w3.org/2000/svg">
<title>topology</title>

"@
}

function AddCircle{
param([int]$x, [int]$y, [int]$w, [int]$h)
$script:SVG += @"
<svg version="1.1" id="Layer_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="$($x - $w / 2)" y="$($y - $h / 2)"
	 width="$w" height="$h" viewBox="0 0 20 20" enable-background="new 0 0 20 20" xml:space="preserve">
<g>
	<path fill="#A0A1A2" d="M16.84,7.4L16.84,7.4V6.52c0-1.76-0.64-3.4-1.76-4.56C14.04,0.76,11.721,0,10,0C8.28,0,5.96,0.76,4.92,1.96
		C3.841,3.12,3.16,4.76,3.16,6.52V7.4l0,0l3.16,0.36v-0.8c0-1.041,0.36-2.36,0.96-3.041c0.601-0.681,1.88-1,2.72-1.04
		c0.84,0,2.12,0.359,2.721,1.04c0.6,0.681,0.96,1.56,0.96,2.56v1.28L16.84,7.4z"/>
	<path fill="#59B4D9" d="M3.16,7.4L3.16,7.4C1.6,7.4,1.04,8.32,1.04,9.52v8.36c0,1.04,0.64,2.12,1.84,2.12h14.239
		c1.36,0,1.841-1.08,1.841-2.12V9.52c0-1.08-0.44-2.12-2.12-2.12l0,0H3.16z"/>
	<path opacity="0.15" fill="#FFFFFF" enable-background="new    " d="M13.64,7.4L13.64,7.4H3.16l0,0C1.6,7.4,1.04,8.32,1.04,9.52
		v8.36c0,1.04,0.64,2.12,1.84,2.12h2.68L13.64,7.4z"/>
	<path fill="#FFFFFF" d="M7.6,10.84l2.32-2.32l2.32,2.32H10.6v1.68H9.2v-1.68H7.6z M3.32,14.36V13H5.72v-1.6l2.24,2.239l-2.24,2.241
		V14.32H3.32V14.36z M9.92,18.88l-2.36-2.36H9.2v-1.64H10.6v1.64h1.68L9.92,18.88z M16.52,14.36h-2.4v1.6l-2.279-2.28l2.279-2.279
		V13h2.4V14.36z"/>
</g>
</svg>

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
$AzureRmExpressRouteCircuit = Get-AzureRmExpressRouteCircuit

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

#Generate ExpressRoute Circuit HashTable
$AzureRmExpressRouteCircuitHashTable = @{}
for($i = 0; $i -lt $AzureRmExpressRouteCircuit.Count; $i++){
    $AzureRmExpressRouteCircuitHashTable.Add(
    $AzureRmExpressRouteCircuit[$i].Id, [PSCustomObject]@{
        Property = $AzureRmExpressRouteCircuit[$i]
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
for($i = 0; $i -lt $AzureRmVirtualNetwork.Count; $i++){
    AddText -x 100 -y (($i + 1) * $Distance_y - 5) -Text $($AzureRmVirtualNetwork[$i].Name)
    AddRectangle -x 100 -y (($i + 1) * $Distance_y) -w 200 -h $Vnet_h
}

#Draw Connection
for($i = 0; $i -lt $AzureRmVirtualNetworkGatewayConnection.Count; $i++){
    [int]$VirtualNetworkGateway1Index = $AzureRmVirtualNetworkHashTable.$($AzureRmVirtualNetworkGatewayHashTable."$($AzureRmVirtualNetworkGatewayConnection[$i].VirtualNetworkGateway1.Id)".property.ipconfigurations.Subnet.Id.Replace("/subnets/GatewaySubnet","")).Index
    
    if($AzureRmLocalNetworkGatewayHashTable."$($AzureRmVirtualNetworkGatewayConnection[$i].LocalNetworkGateway2.Id)" -ne $null){ #S2S VPN
        [int]$LocalNetworkGateway2Index =  $AzureRmLocalNetworkGatewayHashTable."$($AzureRmVirtualNetworkGatewayConnection[$i].LocalNetworkGateway2.Id)".Index
        AddLine -x 300 -y (($VirtualNetworkGateway1Index + 1) * $Distance_y + $Vnet_h / 2 - 15) -x2 900 -y2 ((($LocalNetworkGateway2Index + 1) * $Distance_y) + $Vnet_h / 2)
    }elseif($AzureRmVirtualNetworkGatewayHashTable."$($AzureRmVirtualNetworkGatewayConnection[$i].VirtualNetworkGateway2.Id)" -ne $null){ #V2V VPN
        [int]$VirtualNetworkGateway2Index =  $AzureRmVirtualNetworkHashTable.$($AzureRmVirtualNetworkGatewayHashTable."$($AzureRmVirtualNetworkGatewayConnection[$i].VirtualNetworkGateway2.Id)".property.ipconfigurations.Subnet.Id.Replace("/subnets/GatewaySubnet","")).Index
        AddLine -x 300 *  -y (($VirtualNetworkGateway1Index + 1) * $Distance_y + $Vnet_h / 2 - 15) -x2 (300 + 20) -y2 (($VirtualNetworkGateway1Index + 1) * $Distance_y + $Vnet_h / 2 - 15)
        AddLine -x (300 + 20) *  -y (($VirtualNetworkGateway1Index + 1) * $Distance_y + $Vnet_h / 2 - 15) -x2 (300 + 20) -y2 ((($VirtualNetworkGateway2Index + 1) * $Distance_y) + $Vnet_h / 2 - 15)
        AddLine -x 300 *  -y ((($VirtualNetworkGateway2Index + 1) * $Distance_y) + $Vnet_h / 2 - 15) -x2 (300 + 20) -y2 ((($VirtualNetworkGateway2Index + 1) * $Distance_y) + $Vnet_h / 2 - 15)
    }elseif($AzureRmExpressRouteCircuitHashTable."$($AzureRmVirtualNetworkGatewayConnection[$i].Peer.Id)" -ne $null){ #ExpressRoute
        [int]$ExpressRouteCircuitIndex = $AzureRmExpressRouteCircuitHashTable."$($AzureRmVirtualNetworkGatewayConnection[$i].Peer.Id)".Index
        AddLine -x 300 -y (($VirtualNetworkGateway1Index + 1) * $Distance_y + $Vnet_h / 2 + 15) -x2 500 -y2 ((($ExpressRouteCircuitIndex + 1) * $Distance_y) + $Vnet_h / 2)
    }
}

#Draw LocalGateway
for($i = 0; $i -lt $AzureRmLocalNetworkGateway.Count; $i++){
    AddText -x 900 -y (($i + 1) * $Distance_y - 5) -Text $($AzureRmLocalNetworkGateway[$i].Name)
    AddRectangle -x 900 -y (($i + 1) * $Distance_y) -w 200 -h $Vnet_h
    AddCircle -x 900 -y ((($i + 1) * $Distance_y) + 25) -w 20 -h 20
}

#Draw Gateway
for($i = 0; $i -lt $AzureRmVirtualNetworkGateway.Count; $i++){
    [int]$index = $AzureRmVirtualNetworkHashTable.$($AzureRmVirtualNetworkGateway[$i].ipconfigurations.Subnet.Id.Replace("/subnets/GatewaySubnet","")).Index
    if($AzureRmVirtualNetworkGateway[$i].GatewayType -eq "Vpn"){
        $GatewayType = -15 #VPN Gateway
    }else{
        $GatewayType = 15 #ExpressRoute Gateway
    }
    AddCircle -x 300 -y ((($index + 1) * $Distance_y) + $Vnet_h / 2 + $GatewayType) -w 20 -h 20
}

#Draw Circuit
for($i = 0; $i -lt $AzureRmExpressRouteCircuit.Count; $i++){
    [int]$index = $AzureRmExpressRouteCircuitHashTable[$i].Index
    AddText -x 500 -y (($i + 1) * $Distance_y - 5) -Text $($AzureRmExpressRouteCircuit[$i].Name)
    AddCircle -x 500 -y ((($i + 1) * $Distance_y) + 25) -w 20 -h 20
}

CloseSVG
SaveSVG