class_name SunRiseSet

var HH = 0
var MM = 1

var SUN_DIAMETER = 0.53
var AIR_REF = (34.0/60.0)

func is_leap_year(year):
	if year % 4 == 0 and year % 100 == 0 and year % 400 != 0:
		return false
	elif year % 4 == 0 and year % 100 != 0:
		return true
	elif year % 4 == 0 and year % 100 == 0 and year % 400 == 0:
		return true
	else:
		return false

func get_julian_day(year, month, day):
	var tmp = -7.0 * (float(year) + (float(month) + 9.0) / 12.0) / \
		4.0 + 275.0 * float(month) / 9.0 + float(day)
	tmp += float(year * 367)
	return (tmp - 730531.5 + 12.0 / 24.0)

func get_range_radian(x):
	var b = float(x / (2*PI))
	var a = float((2*PI) * (b - int(b)))
	if a < 0:
		a = (2*PI) + a
	return a

func get_ha(lat, decl):
	var dfo = PI/180.0 * (0.5 * SUN_DIAMETER + AIR_REF)
	if lat < 0.0:
		dfo = -dfo
	var fo = tan(decl + dfo) * tan(lat * PI / 180.0)
	if fo > 1.0:
		fo = 1.0
	fo = asin(fo) + PI / 2.0
	return fo

func get_sun_longitude(days):
	var longitude = get_range_radian(
		280.461 * PI / 180.0 + 0.9856474 * PI/180.0 * days)
	var g = get_range_radian(357.528 * PI/180.0 + 0.9856003 * PI/180.0 * days)
	return [get_range_radian(longitude + 1.915 * PI/180.0 * sin(g) + 0.02 * PI/180.0 * sin(2*g)), longitude]

func convert_dtime_to_rtime(dhour):
	var hour = int(dhour)
	var minute = int((dhour - hour) * 60)
	return [hour, minute]

func calculate_sunset_sunrise(latitude, longitude, timezone):
	#var today = datetime.today()
	var today = Time.get_datetime_dict_from_system()
	var days = get_julian_day(today.year, today.month, today.day)
	
	var tmp = get_sun_longitude(days)
	var gamma = tmp[0]
	var mean_longitude = tmp[1] 
	var obliq = 23.439 * PI/180.0 - 0.0000004 * PI/180.0 * days

	var alpha = atan2(cos(obliq)*sin(gamma), cos(gamma))
	var delta = asin(sin(obliq)*sin(gamma))

	var ll = mean_longitude - alpha

	if mean_longitude < PI:
		ll += (2*PI)
	var eq = 1440.0 * (1.0 - ll / (2*PI))

	var ha = get_ha(latitude, delta)

	var sunrise = 12.0 - 12.0 * ha/PI + timezone - longitude/15.0 + eq/60.0
	var sunset = 12.0 + 12.0 * ha/PI + timezone - longitude/15.0 + eq/60.0

	if sunrise > 24.0:
		sunrise -= 24.0
	if sunset > 24.0:
		sunset -= 24.0

	var sunrise_time = [0, 0]
	var sunset_time = [0, 0]

	tmp = convert_dtime_to_rtime(sunrise)
	sunrise_time[HH] = tmp[0]
	sunrise_time[MM] = tmp[1]
	tmp = convert_dtime_to_rtime(sunset)
	sunset_time[HH] = tmp[0]
	sunset_time[MM] = tmp[1]

	var ret_sunrise = ""
	var ret_sunset = ""

	if sunrise_time[HH] < 10:
		ret_sunrise += "0"
	ret_sunrise += str(sunrise_time[HH])
	ret_sunrise += ":"
	if sunrise_time[MM] < 10:
		ret_sunrise += "0"
	ret_sunrise += str(sunrise_time[MM]-1)

	if sunset_time[HH] < 10:
		ret_sunset += "0"
	ret_sunset += str(sunset_time[HH])
	ret_sunset += ":"
	if sunset_time[MM] < 10:
		ret_sunset += "0"
	ret_sunset += str(sunset_time[MM]+1)

	return [ret_sunrise, ret_sunset]

func test():
	var s = Time.get_unix_time_from_system()
	var tmp = calculate_sunset_sunrise(37.5642135, 127.0016985, 9)
	var sunrise = tmp[0]
	var sunset = tmp[1]
	# sunrise, sunset = calculate_sunset_sunrise(-33.8674769, 151.2069776, 11)
	print("Sunrise:", sunrise)
	print("Sunset:", sunset)
	var e = Time.get_unix_time_from_system()
	print("time:", (e-s)*1000, "ms")
