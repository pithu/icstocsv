carrier = require 'carrier'
icalevent = require 'icalevent'
moment = require('moment')
moment.lang('de')

HEADER = """
         BEGIN:VCALENDAR
         PRODID:-//Google Inc//Google Calendar 70.9054//EN
         VERSION:2.0
         CALSCALE:GREGORIAN
         METHOD:PUBLISH
         X-WR-CALNAME: pithu's calendar
         X-WR-TIMEZONE:Europe/Berlin
         X-WR-CALDESC:

         """

icsEvents = []


createICSEvent = (items) ->
    dateInFormat = "ddd. DD.MM.YYYY"
    dateOutFormat = "YYYY-MM-DDTHH:mm:ssZ"
    start = moment(items[0], dateInFormat).hours(10).minutes(0).seconds(0)
    duration = parseFloat(items[2].replace(",", ".")) * 60
    end = moment(start).add('m', duration)
    event = new icalevent()
    event.set 'summary', items[6]
    event.set 'offset', new Date().getTimezoneOffset()
    event.set 'start', start.format(dateOutFormat)
    event.set 'end', end.format(dateOutFormat)
    return event


carrier.carry process.stdin, (line) ->
    #console.log line
    items = line.split(";")
    icsEvent = createICSEvent(items)
    icsEvents.push(icsEvent)



process.stdin.on 'end', ->
    process.stdout.write HEADER
    for icsEvent in icsEvents
        process.stdout.write(icsEvent.toFile())

process.stdin.resume()

