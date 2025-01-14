
[void][System.Reflection.Assembly]::LoadWithPartialName("MySql.Data")
#$MySQLAssemblyPath = "C:\Program Files (x86)\MySQL\MySQL Connector NET 9.1\MySql.Data.dll"
$sql_cred       = Import-Csv -Delimiter "," -Path .\PS_version\csv_sql.csv

$MySQLServer    = $sql_cred.server
$MySQLDatabase  = $sql_cred.db
$MySQLUsername  = $sql_cred.username
$MySQLPassword  = $sql_cred.pw
$TableName      = "Raiders"

$NewColumns = @(
    "CHAR_NAME VARCHAR(255)",
    "REALM VARCHAR(255)",
    "RACE VARCHAR(255)",
    "CLASS VARCHAR(255)",
    "SPEC VARCHAR(255)",
    "ROLE VARCHAR(255)",
    "TIER_TOK VARCHAR(255)",
    "FACTION VARCHAR(255)",
    "ILVL INT",
    "ARMOR_TYPE VARCHAR(255)",

    "HELMET VARCHAR(255)",
    "HELMET_TIER INT",
    "HELMET_SOCKET INT",
    "HELMET_GEM_NAME VARCHAR(255)",

    "NECK VARCHAR(255)",
    "NECK_SOCKETS INT",
    "NECK_GEM_1 VARCHAR(255)",
    "NECK_GEM_2 VARCHAR(255)",

    "SHOULDERS VARCHAR(255)",
    "SHOULDERS_TIER INT",
    "SHOULDERS_SOCKET INT",
    "SHOULDERS_GEM_NAME VARCHAR(255)",

    "CHEST VARCHAR(255)",
    "CHEST_TIER INT",
    "CHEST_SOCKET INT",
    "CHEST_GEM_NAME VARCHAR(255)",
    "CHEST_ENCHANT INT",

    "WAIST VARCHAR(255)",
    "WAIST_SOCKET INT",
    "WAIST_GEM_NAME VARCHAR(255)",

    "LEGS VARCHAR(255)",
    "LEGS_TIER INT",
    "LEGS_SOCKET INT",
    "LEGS_GEM_NAME VARCHAR(255)",
    "LEGS_ENCHANT INT",

    "FEET VARCHAR(255)",
    "FEET_SOCKET INT",
    "FEET_GEM_NAME VARCHAR(255)",
    "FEET_ENCHANT INT",

    "GLOVES VARCHAR(255)",
    "GLOVES_TIER INT",
    "GLOVES_SOCKET INT",
    "GLOVES_GEM_NAME VARCHAR(255)",
    "GLOVES_ENCHANT INT",

    "BRACERS VARCHAR(255)",
    "BRACERS_SOCKET INT",
    "BRACERS_GEM_NAME VARCHAR(255)",
    "BRACERS_ENCHANT INT",

    "RING1 VARCHAR(255)",
    "RING1_SOCKETS INT",
    "RING1_GEM_1 VARCHAR(255)",
    "RING1_GEM_2 VARCHAR(255)",
    "RING1_ENCHANT INT",

    "RING2 VARCHAR(255)",
    "RING2_SOCKETS INT",
    "RING2_GEM_1 VARCHAR(255)",
    "RING2_GEM_2 VARCHAR(255)",
    "RING2_ENCHANT INT",

    "TRINKET1 VARCHAR(255)",
    "TRINKET2 VARCHAR(255)",

    "BACK VARCHAR(255)",
    "BACK_SOCKET INT",
    "BACK_GEM_NAME VARCHAR(255)",
    "BACK_ENCHANT INT",

    "MAIN_HAND VARCHAR(255)",
    "MAIN_HAND_ENCHANT INT",

    "OFF_HAND VARCHAR(255)",
    "OFF_HAND_ENCHANT INT",

    "EMBELLISHMENTS INT",
    "TIER_PIECES INT",

    "RATING INT",
    "VALOR INT",

    "Weathered_Crests INT",
    "Carved_Crests INT",
    "Runed_Crests INT",
    "Gilded_Crests INT",

    "UPDATED DATETIME DEFAULT CURRENT_TIMESTAMP"
)

try {
    $ConnectionString   = "Server=$MySQLServer;Database=$MySQLDatabase;Uid=$MySQLUsername;Pwd=$MySQLPassword;"
    $Connection         = New-Object MySql.Data.MySqlClient.MySqlConnection($ConnectionString)
    $Connection.Open()

    foreach ($Column in $NewColumns) {
        $ColumnName = $Column.Split(' ')[0]
        $CheckCommand = New-Object MySql.Data.MySqlClient.MySqlCommand
        $CheckCommand.Connection = $Connection
        $CheckCommand.CommandText = "SELECT COUNT(*) FROM information_schema.columns 
                                   WHERE table_schema = '$MySQLDatabase' 
                                   AND table_name = '$TableName' 
                                   AND column_name = '$ColumnName'"
        
        $ColumnExists = [int]$CheckCommand.ExecuteScalar()
        
        if ($ColumnExists -eq 0) {
            $AlterCommand = New-Object MySql.Data.MySqlClient.MySqlCommand
            $AlterCommand.Connection = $Connection
            $AlterCommand.CommandText = "ALTER TABLE $TableName ADD COLUMN $Column"
            
            $AlterCommand.ExecuteNonQuery()
            Write-Host "Added column: $Column"
        } else {
            Write-Host "Column '$ColumnName' already exists. Skipping..."
        }
    }

} catch {
    Write-Host "An error occurred: $($_.Exception.Message)"
} finally {
    if ($Connection.State -eq 'Open') { 
        $Connection.Close() 
        Write-Host "Connection closed."
    }
}