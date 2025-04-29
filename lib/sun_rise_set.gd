class_name SunRiseSet



func is_leap_year(year :int) -> bool:
	if year % 4 == 0 and year % 100 == 0 and year % 400 != 0:
		return false
	elif year % 4 == 0 and year % 100 != 0:
		return true
	elif year % 4 == 0 and year % 100 == 0 and year % 400 == 0:
		return true
	else:
		return false

func get_julian_day(year :int, month :int, day :int) -> float:
	var tmp = -7.0 * ( year + (month + 9.0) / 12.0) / 4.0 + 275.0 * month / 9.0 + day
	tmp += year * 367.0
	return tmp - 730531.5 + 12.0 / 24.0

func get_range_radian(x :float) -> float:
	var b = x / (2*PI)
	var a = 2*PI * (b - int(b))
	if a < 0:
		a = 2*PI + a
	return a

const SUN_DIAMETER = 0.53
const AIR_REF = (34.0/60.0)
func get_ha(lat :float, decl :float) -> float:
	var dfo = PI/180.0 * (0.5 * SUN_DIAMETER + AIR_REF)
	if lat < 0.0:
		dfo = -dfo
	var fo = tan(decl + dfo) * tan(lat * PI / 180.0)
	if fo > 1.0:
		fo = 1.0
	fo = asin(fo) + PI / 2.0
	return fo

func get_sun_longitude(days :float) -> Dictionary:
	var longitude = get_range_radian(280.461 * PI / 180.0 + 0.9856474 * PI/180.0 * days)
	var g = get_range_radian(357.528 * PI/180.0 + 0.9856003 * PI/180.0 * days)
	return {
		"gamma" :get_range_radian(longitude + 1.915 * PI/180.0 * sin(g) + 0.02 * PI/180.0 * sin(2*g)), 
		"mean_longitude" : longitude,
		}

func convert_dtime_to_rtime(dhour :float) -> Dictionary:
	var hour = int(dhour)
	var minute = int((dhour - hour) * 60)
	return {
		"hour" : hour, 
		"minute" : minute,
		}

func calculate_sunset_sunrise(latitude :float, longitude :float, timezone :float):
	var today = Time.get_datetime_dict_from_system()
	var days = get_julian_day(today.year, today.month, today.day)
	
	var tmp = get_sun_longitude(days)
	var gamma = tmp.gamma
	var mean_longitude = tmp.mean_longitude
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

	var sunrise_time = convert_dtime_to_rtime(sunrise)
	var sunset_time = convert_dtime_to_rtime(sunset)

	var ret_sunrise = ""
	var ret_sunset = ""

	if sunrise_time.hour < 10:
		ret_sunrise += "0"
	ret_sunrise += str(sunrise_time.hour)
	ret_sunrise += ":"
	if sunrise_time.minute < 10:
		ret_sunrise += "0"
	ret_sunrise += str(sunrise_time.minute-1)

	if sunset_time.hour < 10:
		ret_sunset += "0"
	ret_sunset += str(sunset_time.hour)
	ret_sunset += ":"
	if sunset_time.minute < 10:
		ret_sunset += "0"
	ret_sunset += str(sunset_time.minute+1)

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
