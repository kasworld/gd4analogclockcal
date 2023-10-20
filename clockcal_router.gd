extends HttpRouter
class_name ClockCalRouter

signal helloed()

func handle_get(request, response):
	response.send(200, "Hello!")
	helloed.emit()
