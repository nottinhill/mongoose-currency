should = require('should')
mongoose = require('mongoose')
Currency = require('../index.js').loadType(mongoose)
Schema = mongoose.Schema
ProductSchema = Schema(price: type: Currency)
Product = mongoose.model('Product', ProductSchema)

describe 'Currency Type', ->
  describe 'the returned object from requiring mongoose-currency', ->
    it 'should have a loadType method', ->
      currencyModule = require('../index.js')
      currencyModule.should.have.ownProperty 'loadType'
      currencyModule.loadType.should.be.a 'function'
      return
    return
  describe 'mongoose.Schema.Types.Currency', ->
    before ->
      currencyModule = require('../index.js').loadType(mongoose)
      return
    it 'mongoose.Schema.Types should have a type called Currency', ->
      mongoose.Schema.Types.should.have.ownProperty 'Currency'
      return
    it 'mongoose.Types should have a type called Currency', ->
      mongoose.Types.should.have.ownProperty 'Currency'
      return
    it 'should be a function', ->
      mongoose.Schema.Types.Currency.should.be.a 'function'
      return
    it 'should have a method called cast', ->
      mongoose.Schema.Types.Currency::cast.should.be.a 'function'
      return
    return
  describe 'setting a currency field and not saving the record', ->
    it 'should store positive as an integer by multiplying by 100', ->
      product = new Product(price: '$9.95')
      product.price.should.equal 995
      return
    it 'should store negative as an integer by multiplying by -100', ->
      product = new Product(price: '-$9.95')
      product.price.should.equal -995
      return
    it 'should strip out \'$\' and \',\'', ->
      product = new Product(price: '$1,000.55')
      product.price.should.equal 100055
      return
    it 'should strip out letters and return correct money value', ->
      product = new Product(price: 'HF1sdf0.55')
      product.price.should.equal 1055
      return
    it 'should work as a string when there are no cents', ->
      product = new Product(price: '500')
      product.price.should.equal 50000
      return
    it 'should work as a string when there are cents', ->
      product = new Product(price: '500.67')
      product.price.should.equal 50067
      return
    it 'should work with whole number', ->
      product = new Product(price: 500)
      product.price.should.equal 500
      return
    it 'should round passed in number if they are floating point nums', ->
      product = new Product(price: 500.55)
      product.price.should.equal 501
      return
    it 'should round when there are > two digits past decimal point', ->
      product = new Product(price: 500.5588)
      product.price.should.equal 501
      product.price = '$500.41999'
      product.price.should.equal 50041
      return
    it 'should not round when adding', ->
      product = new Product(price: 119)
      product2 = new Product(price: 103)
      sum = product.price + product2.price
      sum.should.equal 222
      return
    it 'should accept negative currency as a String', ->
      product = new Product(price: '-$5,000.55')
      product.price.should.equal -500055
      return
    it 'should accept negative currency as a Number', ->
      product = new Product(price: -5000)
      product.price.should.equal -5000
      return
    return
  describe 'setting a currency field and saving the record', ->
    before ->
      mongoose.connect 'localhost', 'mongoose_currency_test'
      return
    after ->
      mongoose.connection.db.dropDatabase()
      return
    it 'should not round up and should return the correct value', (done) ->
      product = new Product(price: '$9.95')
      product.save (err, new_product) ->
        new_product.price.should.equal 995
        Product.findById new_product.id, (err, product) ->
          product.price.should.equal 995
          done()
          return
        return
      return
    it 'should not round down and should return the correct value', (done) ->
      product = new Product(price: '$1,000.19')
      product.save (err, new_product) ->
        new_product.price.should.equal 100019
        Product.findById new_product.id, (err, product) ->
          product.price.should.equal 100019
          done()
          return
        return
      return
    it 'should be able to store values and adding them together returns the correct value', (done) ->
      product1 = new Product(price: 103)
      product2 = new Product(price: 103)
      product1.save (err, product) ->
        product2.save (err, product2) ->
          sum = product1.price + product2.price
          sum.should.equal 206
          done()
          return
        return
      return
    return
  describe 'using a schema with advanced options (required, min, max)', ->
    before ->
      advancedSchema = Schema(price:
        type: Currency
        required: true
        min: 0
        max: 200)
      mongoose.model 'AdvancedModel', advancedSchema
      return
    it 'should pass validation when a price is set and field is required', (done) ->
      advancedModel = mongoose.model('AdvancedModel')
      record = new advancedModel
      record.price = 100.00
      record.validate (err) ->
        should.not.exist err
        done()
        return
      return
    it 'should fail validation when a price is NOT set and field is required', (done) ->
      advancedModel = mongoose.model('AdvancedModel')
      record = new advancedModel
      record.validate (err) ->
        should.exist err
        err.errors.should.have.property 'price'
        err.errors.price.type.should.equal 'required'
        done()
        return
      return
    it 'should pass validation when value is in between min and max values', (done) ->
      advancedModel = mongoose.model('AdvancedModel')
      record = new advancedModel
      record.price = 100
      record.validate (err) ->
        should.not.exist err
        done()
        return
      return
    it 'should fail validation when value is below min', (done) ->
      advancedModel = mongoose.model('AdvancedModel')
      record = new advancedModel
      record.price = -100
      record.validate (err) ->
        should.exist err
        err.errors.should.have.property 'price'
        err.errors.price.type.should.equal 'min'
        done()
        return
      return
    it 'should fail validation when value is higher than max', (done) ->
      advancedModel = mongoose.model('AdvancedModel')
      record = new advancedModel
      record.price = 500
      record.validate (err) ->
        should.exist err
        err.errors.should.have.property 'price'
        err.errors.price.type.should.equal 'max'
        done()
        return
      return
    return
  return
