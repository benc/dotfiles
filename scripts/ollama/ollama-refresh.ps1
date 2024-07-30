# List of desired Ollama models
$desiredModels = @(
    "mistral-nemo:latest",
    "mistral:latest",
    "nomic-embed-text:latest"
)

function Install-Model {
    param ([string]$model)
    Write-Output "Installing $model..."
    ollama pull $model
}

foreach ($model in $desiredModels) {
    Install-Model -model $model
}
