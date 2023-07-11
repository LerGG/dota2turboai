sleep(1000)
_chatwheel()

Func _chatWheel()
	Send("{j down}")
	Sleep(100)
	MouseMove(@DeskTopWidth/2,(@DeskTopHeight/2)-(@DeskTopHeight/4))
	Sleep(100)
    Send("{j up}")
EndFunc