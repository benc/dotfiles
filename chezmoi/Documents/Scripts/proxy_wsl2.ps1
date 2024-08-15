$Port = 2222

$wsl_ip = (wsl hostname -I).trim()
netsh interface portproxy delete v4tov4 listenaddress=0.0.0.0 listenport=$Port
netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=$Port connectaddress=$wsl_ip connectport=2222
netsh interface portproxy show v4tov4
