###*
# Timeago is a jQuery plugin that makes it easy to support automatically
# updating fuzzy timestamps (e.g. "4 minutes ago" or "about 1 day ago").
#
# @name timeago
# @version 1.6.5
# @requires jQuery v1.2.3+
# @author Ryan McGeary
# @license MIT License - http://www.opensource.org/licenses/mit-license.php
#
# For usage and examples, visit:
# http://timeago.yarp.com/
#
# Copyright (c) 2008-2017, Ryan McGeary (ryan -[at]- mcgeary [*dot*] org)
###

((factory) ->
  if typeof define == 'function' and define.amd
    # AMD. Register as an anonymous module.
    define [ 'jquery' ], factory
  else if typeof module == 'object' and typeof module.exports == 'object'
    factory require('jquery')
  else
    # Browser globals
    factory jQuery
  return
) ($) ->

  refresh = ->
    $s = $t.settings
    #check if it's still visible
    if $s.autoDispose and !$.contains(document.documentElement, this)
      #stop if it has been removed
      $(this).timeago 'dispose'
      return this
    data = prepareData(this)
    if !isNaN(data.datetime)
      if $s.cutoff == 0 or Math.abs(distance(data.datetime)) < $s.cutoff
        $(this).text inWords(data.datetime)
      else
        if $(this).attr('title').length > 0
          $(this).text $(this).attr('title')
    this

  prepareData = (element) ->
    element = $(element)
    if !element.data('timeago')
      element.data 'timeago', datetime: $t.datetime(element)
      text = $.trim(element.text())
      if $t.settings.localeTitle
        element.attr 'title', element.data('timeago').datetime.toLocaleString()
      else if text.length > 0 and !($t.isTime(element) and element.attr('title'))
        element.attr 'title', text
    element.data 'timeago'

  inWords = (date) ->
    $t.inWords distance(date)

  distance = (date) ->
    (new Date).getTime() - date.getTime()

  $.timeago = (timestamp) ->
    if timestamp instanceof Date
      inWords timestamp
    else if typeof timestamp == 'string'
      inWords $.timeago.parse(timestamp)
    else if typeof timestamp == 'number'
      inWords new Date(timestamp)
    else
      inWords $.timeago.datetime(timestamp)

  $t = $.timeago
  $.extend $.timeago,
    settings:
      refreshMillis: 60000
      allowPast: true
      allowFuture: false
      localeTitle: false
      cutoff: 0
      autoDispose: true
      strings:
        prefixAgo: null
        prefixFromNow: null
        suffixAgo: 'ago'
        suffixFromNow: 'from now'
        inPast: 'any moment now'
        seconds: 'less than a minute'
        minute: 'about a minute'
        minutes: '%d minutes'
        hour: 'about an hour'
        hours: 'about %d hours'
        day: 'a day'
        days: '%d days'
        month: 'about a month'
        months: '%d months'
        year: 'about a year'
        years: '%d years'
        wordSeparator: ' '
        numbers: []
    inWords: (distanceMillis) ->

      substitute = (stringOrFunction, number) ->
        string = if $.isFunction(stringOrFunction) then stringOrFunction(number, distanceMillis) else stringOrFunction
        value = $l.numbers and $l.numbers[number] or number
        string.replace /%d/i, value

      if !@settings.allowPast and !@settings.allowFuture
        throw 'timeago allowPast and allowFuture settings can not both be set to false.'
      $l = @settings.strings
      prefix = $l.prefixAgo
      suffix = $l.suffixAgo
      if @settings.allowFuture
        if distanceMillis < 0
          prefix = $l.prefixFromNow
          suffix = $l.suffixFromNow
      if !@settings.allowPast and distanceMillis >= 0
        return @settings.strings.inPast
      seconds = Math.abs(distanceMillis) / 1000
      minutes = seconds / 60
      hours = minutes / 60
      days = hours / 24
      years = days / 365
      words = seconds < 45 and substitute($l.seconds, Math.round(seconds)) or seconds < 90 and substitute($l.minute, 1) or minutes < 45 and substitute($l.minutes, Math.round(minutes)) or minutes < 90 and substitute($l.hour, 1) or hours < 24 and substitute($l.hours, Math.round(hours)) or hours < 42 and substitute($l.day, 1) or days < 30 and substitute($l.days, Math.round(days)) or days < 45 and substitute($l.month, 1) or days < 365 and substitute($l.months, Math.round(days / 30)) or years < 1.5 and substitute($l.year, 1) or substitute($l.years, Math.round(years))
      separator = $l.wordSeparator or ''
      if $l.wordSeparator == undefined
        separator = ' '
      $.trim [
        prefix
        words
        suffix
      ].join(separator)
    parse: (iso8601) ->
      s = $.trim(iso8601)
      s = s.replace(/\.\d+/, '')
      # remove milliseconds
      s = s.replace(/-/, '/').replace(/-/, '/')
      s = s.replace(/T/, ' ').replace(/Z/, ' UTC')
      s = s.replace(/([\+\-]\d\d)\:?(\d\d)/, ' $1$2')
      # -04:00 -> -0400
      s = s.replace(/([\+\-]\d\d)$/, ' $100')
      # +09 -> +0900
      new Date(s)
    datetime: (elem) ->
      iso8601 = if $t.isTime(elem) then $(elem).attr('datetime') else $(elem).attr('title')
      $t.parse iso8601
    isTime: (elem) ->
      # jQuery's `is()` doesn't play well with HTML5 in IE
      $(elem).get(0).tagName.toLowerCase() == 'time'
      # $(elem).is("time");
  # functions that can be called via $(el).timeago('action')
  # init is default when no action is given
  # functions are called with context of a single element
  functions = 
    init: ->
      functions.dispose.call this
      refresh_el = $.proxy(refresh, this)
      refresh_el()
      $s = $t.settings
      if $s.refreshMillis > 0
        @_timeagoInterval = setInterval(refresh_el, $s.refreshMillis)
      return
    update: (timestamp) ->
      date = if timestamp instanceof Date then timestamp else $t.parse(timestamp)
      $(this).data 'timeago', datetime: date
      if $t.settings.localeTitle
        $(this).attr 'title', date.toLocaleString()
      refresh.apply this
      return
    updateFromDOM: ->
      $(this).data 'timeago', datetime: $t.parse(if $t.isTime(this) then $(this).attr('datetime') else $(this).attr('title'))
      refresh.apply this
      return
    dispose: ->
      if @_timeagoInterval
        window.clearInterval @_timeagoInterval
        @_timeagoInterval = null
      return

  $.fn.timeago = (action, options) ->
    fn = if action then functions[action] else functions.init
    if !fn
      throw new Error('Unknown function name \'' + action + '\' for timeago')
    # each over objects here and call the requested function
    @each ->
      fn.call this, options
      return
    this

  # fix for IE6 suckage
  document.createElement 'abbr'
  document.createElement 'time'
  return