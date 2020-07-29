import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class WorldTime {
	String location;
	String time;
	String flag;
	String url;
	bool isDaytime; //true or false depending on time of the day

	WorldTime( {
		this.location,
		this.flag,
		this.url,
	});
	Future<void> getTime()  async {

		try{
			Response response = await get('http://worldtimeapi.org/api/timezone/$url');
			Map data = jsonDecode(response.body);
			//print(data);

			//get properties from data
			String datetime = data['datetime'];
			String offsetHour = data['utc_offset'].substring(1,3);
			String offsetMin = data['utc_offset'].substring(4,6);
			String sign = data['utc_offset'].substring(0,1);
			print(sign);
            print(datetime);
			print(offsetHour);

			//create a datetime object
			DateTime now = DateTime.parse(datetime);
			if(sign == '-') {
				now = now.subtract(Duration(hours: int.parse(offsetHour)));
				now = now.subtract(Duration(minutes: int.parse(offsetMin)));
			}
			else {
				now = now.add(Duration(hours: int.parse(offsetHour)));
				now = now.add(Duration(minutes: int.parse(offsetMin)));
			}
			//print(now);

			//set the time property
			time = DateFormat.jm().format(now);

			//set the daytime value
			isDaytime = now.hour > 6 && now.hour < 20 ? true : false;
		}
		catch(e) {
			print('CAUGHT ERROR:$e');
			time = 'Could not get time data';
		}



	}
}

