class IDatabaseStrategy {
    [string] Get_ArtifactsFolder(){ return ""}
    [string] Get_SchemaScript([string]$history){ return "" }
    [string] Get_HistoryTableScript(){ return "" }
    [string] Get_HistoryInsertScript($ScriptName){ return "" }
}
