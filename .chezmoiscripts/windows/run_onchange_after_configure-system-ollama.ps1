Write-Output "🔧 Configuring Ollama..."

gsudo {
    Write-Output "Allow Ollama to run on all interfaces..."
    setx OLLAMA_HOST "0.0.0.0" /M
    
    Write-Output "Configuring Windows Firewall for Ollama..."
    $ports = @{
        11434 = 'Ollama'
    }
    
    foreach ($port in $ports.Keys) {
        $displayName = $ports[$port]

        foreach ($port in $ports.Keys) {
            $displayName = $ports[$port]
        
            if (!(Get-NetFirewallRule -DisplayName $displayName -ErrorAction SilentlyContinue | Select-Object Name, Enabled)) {
                New-NetFireWallRule -DisplayName $displayName -Direction Outbound -LocalPort $port -Action Allow -Protocol TCP
                New-NetFireWallRule -DisplayName $displayName -Direction Inbound -LocalPort $port -Action Allow -Protocol TCP
            } else {
                Write-Output "$displayName firewall rule is already configured"
            }
        }
    }
}
