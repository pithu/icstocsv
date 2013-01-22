http = require('http')

convertIcsDateToJsDate = (icsDateTimeStr) ->
  strYear = icsDateTimeStr.substr(0,4);
  strMonth = icsDateTimeStr.substr(4,2);
  strDay = icsDateTimeStr.substr(6,2);
  strHour = icsDateTimeStr.substr(9,2);
  strMin = icsDateTimeStr.substr(11,2);
  strSec = icsDateTimeStr.substr(13,2);
  new Date(strYear, strMonth-1, strDay, strHour, strMin, strSec)


exports.parseChunk = (data, callback) ->
  startsWith = (value, pattern) ->
    value.indexOf(pattern) is 0

  pattern = /(.+):(.+)/g
  events = new Array()

  while (result = pattern.exec(data))  isnt null
    if startsWith(result[1],'BEGIN') and startsWith(result[2],'VEVENT')
      event = start:'', end:'',summary:'',description:''
    else if startsWith(result[1],'END') and startsWith(result[2],'VEVENT')
      events.push(event)
    else if startsWith(result[1],'DTSTART')
      event.start = convertIcsDateToJsDate(result[2])
    else if startsWith(result[1],'DTEND')
      event.end = convertIcsDateToJsDate(result[2])
    else if startsWith(result[1],'SUMMARY')
      event.summary = result[2]
    else if startsWith(result[1],'DESCRIPTION')
      event.description = result[2]

  events.sort((a,b) ->
    a.start - b.start
  )
  callback(events)


exports.loadChunkFromUrl = (host, path, callback) ->
  loaderCallback = (response) ->
    data = ''
    response.on('data', (chunk) ->
      data += chunk
    )
    response.on('end', (chunk) ->
      callback(data)
    )

  options = {host: host, path: path }
  http.request(options, loaderCallback).end();

#options =
#  host: 'www.google.com'
#  path: '/calendar/ical/jeg3eae4ugbk1qg0sijb76n1t8%40group.calendar.google.com/private-739881a45cdf32cd3fde5421f7f92b29/basic.ics'
