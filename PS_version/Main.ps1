
function Get-BattleNetAccessToken {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ClientId,
        
        [Parameter(Mandatory=$true)]
        [string]$ClientSecret,
        
        [Parameter(Mandatory=$true)]
        [string]$Region
    )

    $authUrl        = "https://$Region.battle.net/oauth/token"
    $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("$ClientId`:$ClientSecret")))
    $headers        = @{Authorization = "Basic $base64AuthInfo"}
    $body           = @{grant_type = 'client_credentials'}

    try {
        $response   = Invoke-RestMethod -Uri $authUrl -Method Post -Headers $headers -Body $body -ContentType 'application/x-www-form-urlencoded'
        Write-Host "✓ Token obtained successfully" -ForegroundColor Green
        return $response.access_token
    }
    catch {
        Write-Host "✗ Error getting access token: $_" -ForegroundColor Red
        return $null
    }
}
function Get-WoWCharacter {
    param(
        [Parameter(Mandatory=$true)]
        [string]$AccessToken,
        
        [Parameter(Mandatory=$true)]
        [string]$Realm,
        
        [Parameter(Mandatory=$true)]
        [string]$CharacterName,
        
        [Parameter(Mandatory=$false)]
        [string]$Region = 'eu'
    )

    $Realm          = $Realm.ToLower()
    $CharacterName  = $CharacterName.ToLower()
    
    $profileUrl     = "https://$Region.api.blizzard.com/profile/wow/character/$Realm/$CharacterName"
    
    $headers = @{
        'Authorization' = "Bearer $AccessToken"
        'Battlenet-Namespace' = "profile-$Region"
    }
    
    $queryParams = @{
        'namespace' = "profile-$Region"
        'locale' = 'en_GB'
    }

    try {
        $queryString = [System.Web.HttpUtility]::ParseQueryString('')
        foreach ($param in $queryParams.GetEnumerator()) {
            $queryString[$param.Key] = $param.Value
        }
        
        $uriBuilder = [System.UriBuilder]$profileUrl
        $uriBuilder.Query = $queryString.ToString()
        
        $response = Invoke-RestMethod -Uri $uriBuilder.Uri.ToString() -Headers $headers -Method Get
        return $response
    }
    catch {
        Write-Host "✗ Request Error: $_" -ForegroundColor Red
        return $null
    }
}
function Get-WoWCharacterEquipement {
    param(
        [Parameter(Mandatory=$true)]
        [string]$AccessToken,
        
        [Parameter(Mandatory=$true)]
        [string]$Realm,
        
        [Parameter(Mandatory=$true)]
        [string]$CharacterName,
        
        [Parameter(Mandatory=$false)]
        [string]$Region = 'eu'
    )

    $Realm = $Realm.ToLower()
    $CharacterName = $CharacterName.ToLower()
    
    $profileUrl = "https://$Region.api.blizzard.com/profile/wow/character/$Realm/$CharacterName/equipment"
    
    $headers = @{
        'Authorization' = "Bearer $AccessToken"
        'Battlenet-Namespace' = "profile-$Region"
    }
    
    $queryParams = @{
        'namespace' = "profile-$Region"
        'locale' = 'en_GB'
    }

    try {
        $queryString = [System.Web.HttpUtility]::ParseQueryString('')
        foreach ($param in $queryParams.GetEnumerator()) {
            $queryString[$param.Key] = $param.Value
        }
        
        $uriBuilder = [System.UriBuilder]$profileUrl
        $uriBuilder.Query = $queryString.ToString()
        
        $response = Invoke-RestMethod -Uri $uriBuilder.Uri.ToString() -Headers $headers -Method Get
        return $response
    }
    catch {
        Write-Host "✗ Request Error: $_" -ForegroundColor Red
        return $null
    }
}
function Get-WoWCharacterCurrency {
    param(
        [Parameter(Mandatory=$true)]
        [string]$AccessToken,
        
        [Parameter(Mandatory=$true)]
        [string]$Realm,
        
        [Parameter(Mandatory=$true)]
        [string]$CharacterName,
        
        [Parameter(Mandatory=$false)]
        [string]$Region = 'eu'
    )

    $Realm = $Realm.ToLower()
    $CharacterName = $CharacterName.ToLower()
    
    $profileUrl = "https://$Region.api.blizzard.com/profile/wow/character/$Realm/$CharacterName/achievements/statistics"
    
    $headers = @{
        'Authorization' = "Bearer $AccessToken"
        'Battlenet-Namespace' = "profile-$Region"
    }
    
    $queryParams = @{
        'namespace' = "profile-$Region"
        'locale' = 'en_GB'
    }

    try {
        $queryString = [System.Web.HttpUtility]::ParseQueryString('')
        foreach ($param in $queryParams.GetEnumerator()) {
            $queryString[$param.Key] = $param.Value
        }
        
        $uriBuilder = [System.UriBuilder]$profileUrl
        $uriBuilder.Query = $queryString.ToString()
        
        $response = Invoke-RestMethod -Uri $uriBuilder.Uri.ToString() -Headers $headers -Method Get
        return $response
    }
    catch {
        Write-Host "✗ Request Error: $_" -ForegroundColor Red
        return $null
    }
}
function Get-WoWCharacterMythicProfile {
    param(
        [Parameter(Mandatory=$true)]
        [string]$AccessToken,
        
        [Parameter(Mandatory=$true)]
        [string]$Realm,
        
        [Parameter(Mandatory=$true)]
        [string]$CharacterName,
        
        [Parameter(Mandatory=$false)]
        [string]$Region = 'eu'
    )

    $Realm = $Realm.ToLower()
    $CharacterName = $CharacterName.ToLower()
    
    $profileUrl = "https://$Region.api.blizzard.com/profile/wow/character/$Realm/$CharacterName/mythic-keystone-profile?namespace=profile-eu"
    
    $headers = @{
        'Authorization' = "Bearer $AccessToken"
        'Battlenet-Namespace' = "profile-$Region"
    }
    
    $queryParams = @{
        'namespace' = "profile-$Region"
        'locale' = 'en_GB'
    }

    try {
        $queryString = [System.Web.HttpUtility]::ParseQueryString('')
        foreach ($param in $queryParams.GetEnumerator()) {
            $queryString[$param.Key] = $param.Value
        }
        
        $uriBuilder = [System.UriBuilder]$profileUrl
        $uriBuilder.Query = $queryString.ToString()
        
        $response = Invoke-RestMethod -Uri $uriBuilder.Uri.ToString() -Headers $headers -Method Get
        return $response
    }
    catch {
        Write-Host "✗ Request Error: $_" -ForegroundColor Red
        return $null
    }
}
function Get-CharacterTierToken {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Class
    )
    
    $tierTokens = @{
        'Mystic' = @('Monk', 'Rogue', 'Demon Hunter')
        'Venerated' = @('Priest', 'Mage', 'Warlock')
        'Zenith' = @('Warrior', 'Paladin', 'Death Knight')
        'Dreadful' = @('Hunter', 'Shaman', 'Druid', 'Evoker')
    }
    
    foreach ($token in $tierTokens.Keys) {
        if ($tierTokens[$token] -contains $Class) {
            return $token
        }
    }
    
    return "Unknown"
}
function Get-CharacterRole {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Class,
        
        [Parameter(Mandatory=$true)]
        [string]$Spec
    )
    
    $roleMapping = @{
        'Death Knight' = @{
            'Blood' = 'Tank'
            'Frost' = 'Melee DPS'
            'Unholy' = 'Melee DPS'
        }
        'Demon Hunter' = @{
            'Vengeance' = 'Tank'
            'Havoc' = 'Melee DPS'
        }
        'Druid' = @{
            'Guardian' = 'Tank'
            'Restoration' = 'Healer'
            'Balance' = 'Ranged DPS'
            'Feral' = 'Melee DPS'
        }
        'Evoker' = @{
            'Preservation' = 'Healer'
            'Devastation' = 'Ranged DPS'
            'Augmentation' = 'Ranged DPS'
        }
        'Hunter' = @{
            'Beast Mastery' = 'Ranged DPS'
            'Marksmanship' = 'Ranged DPS'
            'Survival' = 'Melee DPS'
        }
        'Mage' = @{
            'Arcane' = 'Ranged DPS'
            'Fire' = 'Ranged DPS'
            'Frost' = 'Ranged DPS'
        }
        'Monk' = @{
            'Brewmaster' = 'Tank'
            'Mistweaver' = 'Healer'
            'Windwalker' = 'Melee DPS'
        }
        'Paladin' = @{
            'Protection' = 'Tank'
            'Holy' = 'Healer'
            'Retribution' = 'Melee DPS'
        }
        'Priest' = @{
            'Discipline' = 'Healer'
            'Holy' = 'Healer'
            'Shadow' = 'Ranged DPS'
        }
        'Rogue' = @{
            'Assassination' = 'Melee DPS'
            'Outlaw' = 'Melee DPS'
            'Subtlety' = 'Melee DPS'
        }
        'Shaman' = @{
            'Restoration' = 'Healer'
            'Elemental' = 'Ranged DPS'
            'Enhancement' = 'Melee DPS'
        }
        'Warlock' = @{
            'Affliction' = 'Ranged DPS'
            'Demonology' = 'Ranged DPS'
            'Destruction' = 'Ranged DPS'
        }
        'Warrior' = @{
            'Protection' = 'Tank'
            'Arms' = 'Melee DPS'
            'Fury' = 'Melee DPS'
        }
    }
    
    if ($roleMapping.ContainsKey($Class) -and $roleMapping[$Class].ContainsKey($Spec)) {
        return $roleMapping[$Class][$Spec]
    }
    
    return "Unknown"
}
function Update-RaiderData {
    param (
        [Parameter(Mandatory=$true)]
        [hashtable]$RaiderData
    )

    try {
        $ConnectionString   = "Server=$MySQLServer;Database=$MySQLDatabase;Uid=$MySQLUsername;Pwd=$MySQLPassword;"
        $Connection         = New-Object MySql.Data.MySqlClient.MySqlConnection($ConnectionString)
        $Connection.Open()
        $ColumnNames = @($RaiderData.Keys)
        Write-Host "Processing data for character: $($RaiderData.CHAR_NAME) on realm: $($RaiderData.REALM)"
        Write-Host "Columns to update: $($ColumnNames -join ', ')"
        $CheckCommand = New-Object MySql.Data.MySqlClient.MySqlCommand
        $CheckCommand.Connection = $Connection
        $CheckCommand.CommandText = "SELECT COUNT(*) FROM $TableName WHERE CHAR_NAME = @CharName AND REALM = @Realm"
        $CharNameParam = New-Object MySql.Data.MySqlClient.MySqlParameter("@CharName", $RaiderData.CHAR_NAME)
        $RealmParam = New-Object MySql.Data.MySqlClient.MySqlParameter("@Realm", $RaiderData.REALM)
        $CheckCommand.Parameters.Add($CharNameParam)
        $CheckCommand.Parameters.Add($RealmParam)
        Write-Host "Executing check query: $($CheckCommand.CommandText)"
        $Exists = [int]$CheckCommand.ExecuteScalar()
        Write-Host "Record exists: $Exists"

        $Command = New-Object MySql.Data.MySqlClient.MySqlCommand
        $Command.Connection = $Connection

        if ($Exists -eq 0) {
            # INSERT 
            $Columns = $ColumnNames -join ","
            $Params = ($ColumnNames | ForEach-Object { "@$_" }) -join ","
            $Command.CommandText = "INSERT INTO $TableName ($Columns) VALUES ($Params)"
            Write-Host "Inserting new record..."
        } else {
            # UPDATE 
            $UpdateSet = ($ColumnNames | Where-Object { $_ -notin @('CHAR_NAME', 'REALM') } | 
                         ForEach-Object { "$_ = @$_" }) -join ","
            $Command.CommandText = "UPDATE $TableName SET $UpdateSet WHERE CHAR_NAME = @CHAR_NAME AND REALM = @REALM"
            Write-Host "Updating existing record..."
        }

        Write-Host "SQL Command: $($Command.CommandText)"

     
        foreach ($Column in $ColumnNames) {
            $Value = $RaiderData[$Column]
            $Param = New-Object MySql.Data.MySqlClient.MySqlParameter("@$Column", $Value)
            if ($null -eq $Value) {
                $Param.Value = [DBNull]::Value
            }
            $Command.Parameters.Add($Param)
            Write-Host "Added parameter @$Column = $Value"
        }

      
        Write-Host "Executing command..."
        $Result = $Command.ExecuteNonQuery()
        Write-Host "Operation completed successfully. Affected rows: $Result"

    } catch {
        Write-Host "An error occurred: $($_.Exception.Message)" -ForegroundColor Red
        if ($_.Exception.InnerException) {
            Write-Host "Inner Exception: $($_.Exception.InnerException.Message)" -ForegroundColor Red
        }

        if ($Command -and $Command.LastInsertedId) {
            Write-Host "Last Inserted ID: $($Command.LastInsertedId)"
        }
        Write-Host "Full Exception Details: $($_.Exception)" -ForegroundColor Red
    } finally {
        if ($Connection -and $Connection.State -eq 'Open') {
            $Connection.Close()
            Write-Host "Connection closed."
        }
    }
}

$api_cred       = Import-Csv -Delimiter "," -Path .\PS_version\csv_api.csv
$raiders        = Import-Csv -Delimiter "," -Path .\PS_version\csv_raiders.csv
$sql_cred       = Import-Csv -Delimiter "," -Path .\PS_version\csv_sql.csv
$token          = Get-BattleNetAccessToken -ClientId $api_cred.client -ClientSecret $api_cred.secret -Region "eu"

$Array          =@()
foreach($raider in $raiders){


$character      = Get-WoWCharacter -AccessToken $token -Realm $raider.realm -CharacterName $raider.name
$characterEq    = Get-WoWCharacterEquipement -AccessToken $token -Realm $raider.realm -CharacterName $raider.name
$characterCur   = Get-WoWCharacterCurrency -AccessToken $token -Realm $raider.realm -CharacterName $raider.name
$charactermplus = Get-WoWCharacterMythicProfile -AccessToken $token -Realm $raider.realm -CharacterName $raider.name

$realm          = $character.realm              | Select-Object name
$race           = $character.race               | Select-Object name
$class          = $character.character_class    | Select-Object name
$faction        = $character.faction            | Select-Object name
$spec           = $character.active_spec        | Select-Object name

$tierToken      = Get-CharacterTierToken -Class $class.name
$role           = Get-CharacterRole -Class $class.name -Spec $spec.name

$Dung           = $characterCur.categories | Where-Object id -EQ 130
$valor          = $dung.statistics | Where-Object id -EQ 20488 | Select-Object name, quantity
$Wcrest         = $dung.statistics | Where-Object id -EQ 20489 | Select-Object name, quantity
$Ccrest         = $dung.statistics | Where-Object id -EQ 20490 | Select-Object name, quantity
$Rcrest         = $dung.statistics | Where-Object id -EQ 20491 | Select-Object name, quantity
$Gcrest         = $dung.statistics | Where-Object id -EQ 20492 | Select-Object name, quantity

#$mythic         = $characterCur.categories | Where-Object id -EQ 14807 
#$tww            = $mythic.sub_categories | Where-Object id -EQ 15520

$gear           = $characterEq.equipped_items | Select-Object slot,name,level,sockets,enchantments,spells,set,item_subclass

$embel          = $gear | Where-Object spells -Like '*embellis*'  
$set            = $gear | Where-Object set -like '*/5*'
$helmet         = $gear | Where-Object slot -like '*Head*'
$Neck           = $gear | Where-Object slot -like '*Neck*'
$Shoulders      = $gear | Where-Object slot -like '*Shoulders*'
$Chest          = $gear | Where-Object slot -like '*Chest*'
$Waist          = $gear | Where-Object slot -like '*Waist*'
$Legs           = $gear | Where-Object slot -like '*Legs*'
$Feet           = $gear | Where-Object slot -like '*Feet*'
$Wrist          = $gear | Where-Object slot -like '*Wrist*'
$Hands          = $gear | Where-Object slot -like '*Hands*'
$FINGER_1       = $gear | Where-Object slot -like '*FINGER_1*'
$FINGER_2       = $gear | Where-Object slot -like '*FINGER_2*'
$TRINKET_1      = $gear | Where-Object slot -like '*TRINKET_1*'
$TRINKET_2      = $gear | Where-Object slot -like '*TRINKET_2*'
$Back           = $gear | Where-Object slot -like '*Back*'
$MAIN_HAND      = $gear | Where-Object slot -like '*MAIN_HAND*'
$OFF_HAND       = $gear | Where-Object slot -like '*OFF_HAND*'

$sockethelmet   = $helmet.sockets       | Select-Object item
$socketsneck    = $neck.sockets         | Select-Object item
$socketsshould  = $Shoulders.sockets    | Select-Object item
$socketschest   = $chest.sockets        | Select-Object item
$socketsWaist   = $Waist.sockets        | Select-Object item
$socketsLegs    = $Legs.sockets         | Select-Object item
$socketsFeet    = $Feet.sockets         | Select-Object item
$socketsWrist   = $Wrist.sockets        | Select-Object item
$socketsHands   = $Hands.sockets        | Select-Object item
$socketsfin1    = $FINGER_1.sockets     | Select-Object item
$socketsfin2    = $FINGER_2.sockets     | Select-Object item
$socketsBack    = $Back.sockets         | Select-Object item
$tierslots      = $set                  | Select-Object slot


$table  = [ordered]@{}

$table.add('Helmet_is_tier',0)
$table.add('Shoulder_is_tier',0)
$table.add('Chest_is_tier',0)
$table.add('Legs_is_tier',0)
$table.add('Hands_is_tier',0)

foreach($tier in $tierslots){

    if($tier.slot.name -like 'Head'){$table['Helmet_is_tier']=1}
    elseif($tier.slot.name -like 'Shoulders'){$table['Shoulder_is_tier']=1}
    elseif($tier.slot.name -like 'Chest'){$table['Chest_is_tier']=1}
    elseif($tier.slot.name -like 'Legs'){$table['Legs_is_tier']=1}
    elseif($tier.slot.name -like 'Hands'){$table['Hands_is_tier']=1}
}


$Array += @(
    [pscustomobject]@{  
                        ## main information about character
                        Charname            =   $character.name;
                        Realm               =   $realm.name;
                        Race                =   $race.name;
                        Class               =   $class.name;
                        Spec                =   $Spec.name;
                        Role                =   $Role;
                        Tier_Token          =   $tierToken;
                        Faction             =   $Faction.name;
                        ilvl                =   $character.equipped_item_level;
                        Armor_type          =   $helmet.item_subclass.name;

                        ## Character's gear (items, ilvl, gems, enchants)
                        Helmet              =   $helmet.name +" ("+ $helmet.level.value +")";
                        Helmet_tier         =   if($null -eq $helmet.set){0}else{1};
                        helmet_socket       =   if($helmet.sockets.count -eq 0){0}elseif($helmet.sockets.count -eq 1){1};
                        helmet_socket_name  =   if($helmet.sockets.count -eq 0){'-'}elseif($helmet.sockets.count -eq 1){$sockethelmet[0].item.name};
                            
                        Neck                =   $Neck.name +" ("+ $Neck.level.value +")";
                        neck_sockets        =   if($Neck.sockets.count -eq 0){0}elseif($Neck.sockets.count -eq 1){1}elseif($Neck.sockets.count -eq 2){2};
                        neck_gem1           =   if($Neck.sockets.count -eq 0){'-'}elseif($Neck.sockets.count -eq 1){$socketsneck[0].item.name}elseif($Neck.sockets.count -eq 2){$socketsneck[0].item.name};
                        neck_gem2           =   if($Neck.sockets.count -eq 0){'-'}elseif($Neck.sockets.count -eq 1){'-'}elseif($Neck.sockets.count -eq 2){$socketsneck[1].item.name};
                        
                        Shoulder		    =	$Shoulders.name +" ("+ $Shoulders.level.value +")";
                        Shoulder_tier	    =	if($null -eq $Shoulders.set){0}else{1};
                        Shoulders_sock	    =	if($Shoulders.sockets.count -eq 0){0}elseif($Shoulders.sockets.count -eq 1){1};
                        Shoulder_gem	    =	if($Shoulders.sockets.count -eq 0){'-'}elseif($Shoulders.sockets.count -eq 1){$socketsshould[0].item.name};

                        chest	            =	$chest.name +" ("+ $chest.level.value +")";
                        Chest_tier	        =	if($null -eq $chest.set){0}else{1};
                        chest_sock	        =	if($chest.sockets.count -eq 0){0}elseif($chest.sockets.count -eq 1){1};
                        chest_gem	        =	if($chest.sockets.count -eq 0){'-'}elseif($chest.sockets.count -eq 1){$socketschest[0].item.name};
                        chest_enchant	    =	if($Chest.enchantments.Count -eq 0){0}else{1};

                        Waist	            =	$Waist.name +" ("+ $Waist.level.value +")";
                        Waist_sock	        =	if($Waist.sockets.count -eq 0){0}elseif($Waist.sockets.count -eq 1){1};
                        Waist_gem	        =	if($Waist.sockets.count -eq 0){'-'}elseif($Waist.sockets.count -eq 1){$socketsWaist[0].item.name};

                        Legs	            =	$Legs.name +" ("+ $Legs.level.value +")";
                        Legs_tier	        =	if($null -eq $legs.set){0}else{1};
                        Legs_sock	        =	if($Legs.sockets.count -eq 0){0}elseif($Legs.sockets.count -eq 1){1};
                        Legs_gem	        =	if($Legs.sockets.count -eq 0){'-'}elseif($Legs.sockets.count -eq 1){$socketsLegs[0].item.name};
                        Legs_enchant	    =	if($Legs.enchantments.Count -eq 0){0}else{1};

                        Feet	            =	$Feet.name +" ("+ $Feet.level.value +")";
                        Feet_sock	        =	if($Feet.sockets.count -eq 0){0}elseif($Feet.sockets.count -eq 1){1};
                        Feet_gem	        =	if($Feet.sockets.count -eq 0){'-'}elseif($Feet.sockets.count -eq 1){$socketsFeet[0].item.name};
                        Feet_enchant	    =	if($Feet.enchantments.Count -eq 0){0}else{1};

                        Wrist	            =	$Wrist.name +" ("+ $Wrist.level.value +")";
                        Wrist_sock	        =	if($Wrist.sockets.count -eq 0){0}elseif($Wrist.sockets.count -eq 1){1};
                        Wrist_gem	        =	if($Wrist.sockets.count -eq 0){'-'}elseif($Wrist.sockets.count -eq 1){$socketsWrist[0].item.name};
                        Wrist_enchant	    =	if($Wrist.enchantments.Count -eq 0){0}else{1};

                        Hands	            =	$Hands.name +" ("+ $Hands.level.value +")";
                        Hands_tier	        =	if($null -eq $hands.set){0}else{1};
                        Hands_sock	        =	if($Hands.sockets.count -eq 0){0}elseif($Hands.sockets.count -eq 1){1};
                        Hands_gem	        =	if($Hands.sockets.count -eq 0){'-'}elseif($Hands.sockets.count -eq 1){$socketsHands[0].item.name};
                        Hands_enchant	    =	if($Hands.enchantments.Count -eq 0){0}else{1};

                        FINGER_1	        =	$FINGER_1.name +" ("+ $FINGER_1.level.value +")";
                        FINGER_1_sockets	=	if($FINGER_1.sockets.count -eq 0){0}elseif($FINGER_1.sockets.count -eq 1){1}elseif($FINGER_1.sockets.count -eq 2){2}elseif($FINGER_1.sockets.count -eq 3){3};
                        FINGER_1_gem1	    =	if($FINGER_1.sockets.count -eq 0){'-'}elseif($FINGER_1.sockets.count -eq 1){$socketsFINGER_1[0].item.name}elseif($FINGER_1.sockets.count -eq 2){$socketsfin1[0].item.name};
                        FINGER_1_gem2	    =	if($FINGER_1.sockets.count -eq 0){'-'}elseif($FINGER_1.sockets.count -eq 1){'-'}elseif($FINGER_1.sockets.count -eq 2){$socketsfin1[1].item.name};
                        FINGER_1_enchant	=	if($FINGER_1.enchantments.Count -eq 0){0}else{1};

                        FINGER_2	        =	$FINGER_2.name +" ("+ $FINGER_2.level.value +")";
                        FINGER_2_sockets	=	if($FINGER_2.sockets.count -eq 0){0}elseif($FINGER_2.sockets.count -eq 1){1}elseif($FINGER_2.sockets.count -eq 2){2}elseif($FINGER_2.sockets.count -eq 3){3};
                        FINGER_2_gem1	    =	if($FINGER_2.sockets.count -eq 0){'-'}elseif($FINGER_2.sockets.count -eq 1){$socketsFINGER_2[0].item.name}elseif($FINGER_2.sockets.count -eq 2){$socketsfin2[0].item.name};
                        FINGER_2_gem2	    =	if($FINGER_2.sockets.count -eq 0){'-'}elseif($FINGER_2.sockets.count -eq 1){'-'}elseif($FINGER_2.sockets.count -eq 2){$socketsfin2[1].item.name};
                        FINGER_2_enchant	=	if($FINGER_2.enchantments.Count -eq 0){0}else{1}

                        TRINKET_1	        =	$TRINKET_1.name +" ("+ $TRINKET_1.level.value +")";
                        TRINKET_2	        =	$TRINKET_2.name +" ("+ $TRINKET_2.level.value +")";

                        Back	            =	$Back.name +" ("+ $Back.level.value +")";
                        Back_sock	        =	if($Back.sockets.count -eq 0){0}elseif($Back.sockets.count -eq 1){1};
                        Back_gem	        =	if($Back.sockets.count -eq 0){'-'}elseif($Back.sockets.count -eq 1){$socketsBack[0].item.name};
                        Back_enchant	    =	if($Back.enchantments.Count -eq 0){0}else{1};

                        MAIN_HAND	        =	$MAIN_HAND.name +" ("+ $MAIN_HAND.level.value +")";
                        MAIN_HAND_ench	    =	if($MAIN_HAND.enchantments.Count -eq 0){0}else{1};

                        OFF_HAND	        =	if($null -ne $OFF_HAND){$OFF_HAND.name +" ("+ $OFF_HAND.level.value +")"}; 
                        OFF_HAND_ench	    =	if($OFF_HAND.enchantments.Count -eq 0){0}else{1};

                        embellishments	    =	$embel.count;
                        Tier_Pieces	        =	$set.count;



                        ## Currencies & Rating
                        Rating              =   $charactermplus.current_mythic_rating.rating;
                        Valor               =   $valor.quantity;
                        'Weathered Harbinger Crests'=$Wcrest.quantity;
                        'Carved Harbinger Crests' =$Ccrest.quantity;
                        'Runed Harbinger Crests'=$Rcrest.quantity;
                        'Gilded Harbinger Crests'=$Gcrest.quantity;

                    }
)




}

# MySQL Assembly Loading
try {
    [System.Reflection.Assembly]::LoadFrom("C:\Program Files (x86)\MySQL\MySQL Connector NET 9.1\MySql.Data.dll")
} catch {
    Write-Host "Failed to load MySQL assembly. Error: $($_.Exception.Message)"
    Write-Host "Please verify the path to MySql.Data.dll is correct and the connector is installed."
    exit
}



$MySQLServer    = $sql_cred.server
$MySQLDatabase  = $sql_cred.db
$MySQLUsername  = $sql_cred.username
$MySQLPassword  = $sql_cred.pw
$TableName      = "Raiders"

Write-Host "Starting data update process..."
foreach($row in $Array){

$RaiderData = @{

    CHAR_NAME			=	$row.charname
    REALM				=	$row.realm
    RACE				=	$row.race
    CLASS				=	$row.class
    SPEC				=	$row.spec
    ROLE				=	$row.role
    TIER_TOK			=	$row.Tier_Token
    FACTION				=	$row.Faction
    ILVL				=	$row.ilvl
    ARMOR_TYPE			=	$row.Armor_type

    HELMET				=	$row.Helmet
    HELMET_TIER			=	$row.Helmet_tier
    HELMET_SOCKET		=	$row.helmet_socket
    HELMET_GEM_NAME		=	$row.helmet_socket_name

    NECK				=	$row.Neck
    NECK_SOCKETS		=	$row.neck_sockets
    NECK_GEM_1			=	$row.neck_gem1
    NECK_GEM_2			=	$row.neck_gem2

    SHOULDERS			=	$row.Shoulder
    SHOULDERS_TIER		=	$row.Shoulder_tier
    SHOULDERS_SOCKET	=	$row.Shoulders_sock
    SHOULDERS_GEM_NAME	=	$row.Shoulder_gem

    CHEST				=	$row.chest
    CHEST_TIER			=	$row.Chest_tier
    CHEST_SOCKET		=	$row.chest_sock
    CHEST_GEM_NAME		=	$row.chest_gem
    CHEST_ENCHANT		=	$row.chest_enchant

    WAIST				=	$row.Waist
    WAIST_SOCKET		=	$row.Waist_sock
    WAIST_GEM_NAME		=	$row.Waist_gem

    LEGS				=	$row.Legs
    LEGS_TIER			=	$row.Legs_tier
    LEGS_SOCKET			=	$row.Legs_sock
    LEGS_GEM_NAME		=	$row.Legs_gem
    LEGS_ENCHANT		=	$row.Legs_enchant

    FEET				=	$row.Feet
    FEET_SOCKET			=	$row.Feet_sock
    FEET_GEM_NAME		=	$row.Feet_gem
    FEET_ENCHANT		=	$row.Feet_enchant

    GLOVES				=	$row.Hands
    GLOVES_TIER			=	$row.Hands_tier
    GLOVES_SOCKET		=	$row.Hands_sock
    GLOVES_GEM_NAME		=	$row.Hands_gem
    GLOVES_ENCHANT		=	$row.Hands_enchant

    BRACERS				=	$row.Wrist
    BRACERS_SOCKET		=	$row.Wrist_sock
    BRACERS_GEM_NAME	=	$row.Wrist_gem
    BRACERS_ENCHANT		=	$row.Wrist_enchant

    RING1				=	$row.FINGER_1
    RING1_SOCKETS		=	$row.FINGER_1_sockets
    RING1_GEM_1			=	$row.FINGER_1_gem1
    RING1_GEM_2			=	$row.FINGER_1_gem2
    RING1_ENCHANT		=	$row.FINGER_1_enchant

    RING2				=	$row.FINGER_2
    RING2_SOCKETS		=	$row.FINGER_2_sockets
    RING2_GEM_1			=	$row.FINGER_2_gem1
    RING2_GEM_2			=	$row.FINGER_2_gem2
    RING2_ENCHANT		=	$row.FINGER_2_enchant

    TRINKET1			=	$row.TRINKET_1
    TRINKET2			=	$row.TRINKET_2

    BACK				=	$row.Back
    BACK_SOCKET			=	$row.Back_sock
    BACK_GEM_NAME		=	$row.Back_gem
    BACK_ENCHANT		=	$row.Back_enchant

    MAIN_HAND			=	$row.MAIN_HAND
    MAIN_HAND_ENCHANT	=	$row.MAIN_HAND_ench

    OFF_HAND			=	$row.OFF_HAND
    OFF_HAND_ENCHANT	=	$row.OFF_HAND_ench

    EMBELLISHMENTS		=	$row.embellishments
    TIER_PIECES			=	$row.Tier_Pieces

    RATING				=	$row.Rating
    VALOR				=	$row.Valor

    Weathered_Crests	=	$row.'Weathered Harbinger Crests'
    Carved_Crests		=	$row.'Carved Harbinger Crests'
    Runed_Crests		=	$row.'Runed Harbinger Crests'
    Gilded_Crests		=	$row.'Gilded Harbinger Crests'

   
}
Update-RaiderData -RaiderData $RaiderData
}


