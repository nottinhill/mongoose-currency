(function() {
  var Currency, isType, mongoose, util;

  Currency = function(path, options) {
    mongoose.SchemaTypes.Number.call(this, path, options);
  };


  /**
   * isType(type, obj)
   * Supported types: 'Function', 'String', 'Number', 'Date', 'RegExp',
   * 'Arguments'
   * source: https://github.com/jashkenas/underscore/blob/1.5.2/underscore.js#L996
   */

  isType = function(type, obj) {
    return Object.prototype.toString.call(obj) === '[object ' + type + ']';
  };

  'use strict';

  mongoose = require('mongoose');

  util = require('util');

  module.exports.loadType = function(mongoose) {
    mongoose.Types.Currency = mongoose.SchemaTypes.Currency = Currency;
    return Currency;
  };


  /*!
   * inherits
   */

  util.inherits(Currency, mongoose.SchemaTypes.Number);

  Currency.prototype.cast = function(val) {
    var currency, currencyAsString, findDigitsAndDotRegex, findLettersAndCommasRegex, findNegativeRegex;
    if (isType('String', val)) {
      currencyAsString = val.toString();
      findDigitsAndDotRegex = /\d*\.\d{1,2}/;
      findLettersAndCommasRegex = /\,|[a-zA-Z]+/g;
      findNegativeRegex = /^-/;
      currency = void 0;
      currencyAsString = currencyAsString.replace(findLettersAndCommasRegex, '');
      currency = findDigitsAndDotRegex.exec(currencyAsString + '.0')[0];
      if (findNegativeRegex.test(currencyAsString)) {
        return (currency * -100).toFixed(0) * 1;
      } else {
        return (currency * 100).toFixed(0) * 1;
      }
    } else if (isType('Number', val)) {
      return val.toFixed(0) * 1;
    } else {
      return new Error('Should pass in a number or string');
    }
  };

}).call(this);
