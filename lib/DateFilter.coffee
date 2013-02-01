moment = require('moment')

exports.DateFilter = class DateFilter
    constructor: (type) ->
        defaultFilterFunction = (date) ->
            return !(date >= @min && date <= @max)

        if(type is "PREV")
            now = moment().subtract('months', 1)
            @min = new Date(now.startOf('month'))
            @max = new Date(now.endOf('month'))
            @doFilter = defaultFilterFunction

        else if(type is "THIS")
            now = moment()
            @min = new Date(now.startOf('month'))
            @max = new Date(now.endOf('month'))
            @doFilter = defaultFilterFunction

        else
            @doFilter = () ->
                return false

    filter:(date) ->
        return @doFilter(date)

