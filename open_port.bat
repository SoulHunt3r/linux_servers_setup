

@REM #
netsh firewall add portopening TCP 505 "Port 505"


@REM #
netsh advfirewall firewall add rule name="505" dir=in action=allow protocol=TCP localport=505
