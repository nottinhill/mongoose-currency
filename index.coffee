Currency = (path, options) ->
  mongoose.SchemaTypes.Number.call this, path, options
  return

###*
# isType(type, obj)
# Supported types: 'Function', 'String', 'Number', 'Date', 'RegExp',
# 'Arguments'
# source: https://github.com/jashkenas/underscore/blob/1.5.2/underscore.js#L996
###

isType = (type, obj) ->
  Object::toString.call(obj) == '[object ' + type + ']'

'use strict'
mongoose = require('mongoose')
util = require('util')

module.exports.loadType = (mongoose) ->
  mongoose.Types.Currency = mongoose.SchemaTypes.Currency = Currency
  Currency

###!
# inherits
###

util.inherits Currency, mongoose.SchemaTypes.Number

Currency::cast = (val) ->
  if isType('String', val)
    currencyAsString = val.toString()
    findDigitsAndDotRegex = /\d*\.\d{1,2}/
    findLettersAndCommasRegex = /\,|[a-zA-Z]+/g
    findNegativeRegex = /^-/
    currency = undefined
    currencyAsString = currencyAsString.replace(findLettersAndCommasRegex, '')
    currency = findDigitsAndDotRegex.exec(currencyAsString + '.0')[0]
    # Adds .0 so it works with whole numbers
    if findNegativeRegex.test(currencyAsString)
      (currency * -100).toFixed(0) * 1
    else
      (currency * 100).toFixed(0) * 1
  else if isType('Number', val)
    val.toFixed(0) * 1
  else
    new Error('Should pass in a number or string')