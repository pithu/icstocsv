ical = require('ical')

moment = require('moment')
moment.lang('de')

require("../node_modules/globalize/lib/cultures/globalize.cultures.js");
Globalize = require('globalize')
Globalize.culture("de")


filterArg = process.argv[2]
url = process.argv[3]

if filterArg == 'PREV'
    now = moment().subtract('months', 1)
    min = new Date(now.startOf('month'))
    max = new Date(now.endOf('month'))
    doDateFilter = (date) ->
        return !(date >= min && date <= max)
else if filterArg == 'THIS'
    now = moment()
    min = new Date(now.startOf('month'))
    max = new Date(now.endOf('month'))
    doDateFilter = (date) ->
        return !(date >= min && date < max)
else
    doDateFilter = (date) ->
        return  false


sortAndFilterEvents = (events) ->
    eventEntries = []
    for key of events
        event = events[key]
        continue if !event || !event.summary
        continue if doDateFilter(event.start)
        event.description ?= ""
        eventEntries.push(event)
    eventEntries.sort (a, b) ->
        return a.start - b.start
    return eventEntries

cleanCSVString = (value) ->
    return value.replace(/\"/g, "'").replace(/\;/g, ",").replace(/\n/g, " ")

ical.fromURL url, {}, (error, events) ->
    console.log("")
    console.log("date, duration, summary, description")
    eventEntries = sortAndFilterEvents(events)
    for event in eventEntries
        date = moment(event.start).format("ddd DD.MM.YYYY")
        duration = Globalize.format(moment(event.end).diff(moment(event.start), 'hours', true), "n2")
        summary = cleanCSVString(event.summary)
        description = cleanCSVString(event.description)
        console.log("#{date}; #{duration}; \"#{summary}\"; \"#{description}\"")

    undefined


