DateFilter = require('./DateFilter')
ical = require('ical')

moment = require('moment')
moment.lang('de')

require("../node_modules/globalize/lib/cultures/globalize.cultures.js");
Globalize = require('globalize')
Globalize.culture("de")


dateFilter = new DateFilter.DateFilter(process.argv[2])
url = process.argv[3]

sortAndFilterEvents = (events) ->
    eventEntries = []
    for key of events
        event = events[key]
        continue if !event || !event.summary
        continue if dateFilter.filter(event.start)
        event.description ?= ""
        eventEntries.push(event)
    eventEntries.sort (a, b) ->
        return a.start - b.start
    return eventEntries

cleanCSVString = (value) ->
    return value.replace(/\"/g, "'").replace(/\;/g, ",").replace(/\n/g, " ")

ical.fromURL url, {}, (error, events) ->
    console.log("")
    console.log("date;client;duration;project;type;billable;description")
    eventEntries = sortAndFilterEvents(events)
    for event in eventEntries
        date = moment(event.start).format("ddd DD.MM.YYYY")
        duration = Globalize.format(moment(event.end).diff(moment(event.start), 'hours', true), "n2")
        summary = cleanCSVString(event.summary)
        description = cleanCSVString(event.description)
        console.log("#{date};gcs;#{duration};actano;consult;yes;\"#{summary}: #{description}\"")

    undefined


