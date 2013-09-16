sinon = require('sinon')
assert = require('assert')
$      = require('jquery')
global.jQuery = $

require('../src/jquery.bank')

describe 'jquery.bank', ->
  describe '$.fn.bank', ->
    describe 'Argument validation', ->
      it 'throws an error if a given country is not supported', ->
        assert.throws ->
          $('<input type=text>').bank('RoutingTransitNumber', 'Invalid')

      it 'throws an error if a given field is not supported in a given country', ->
        assert.throws ->
          $('<input type=text>').bank('Invalid', 'US')

    describe 'Format bank number of Japanese Bank', ->
      it 'should allow numeric characters', ->
        $rtn = $('<input type=text>').bank('BankNumber', 'JP')
        $rtn.val('012')

        e = $.Event('keyup')
        e.which = 51 # '3'
        sinon.stub(e, 'preventDefault')
        $rtn.trigger(e)

        assert(e.preventDefault.notCalled)

      it 'should not allow non-numeric characters', ->
        $rtn = $('<input type=text>').bank('BankNumber', 'JP')
        $rtn.val('0123')

        e = $.Event('keypress')
        e.which = 97 # 'a'
        sinon.stub(e, 'preventDefault')
        $rtn.trigger(e)

        assert(e.preventDefault.called)

      it 'should limit to 4 numbers', ->
        $rtn = $('<input type=text>').bank('BankNumber', 'JP')
        $rtn.val('0123')

        e = $.Event('keypress')
        e.which = 57 # '9'
        sinon.stub(e, 'preventDefault')
        $rtn.trigger(e)

        assert(e.preventDefault.called)

    describe 'Format bank number of Japanese Branch', ->
      it 'should allow numeric characters', ->
        $rtn = $('<input type=text>').bank('BranchNumber', 'JP')
        $rtn.val('012')

        e = $.Event('keyup')
        e.which = 51 # '3'
        sinon.stub(e, 'preventDefault')
        $rtn.trigger(e)

        assert(e.preventDefault.notCalled)

      it 'should not allow non-numeric characters', ->
        $rtn = $('<input type=text>').bank('BranchNumber', 'JP')
        $rtn.val('0123')

        e = $.Event('keypress')
        e.which = 97 # 'a'
        sinon.stub(e, 'preventDefault')
        $rtn.trigger(e)

        assert(e.preventDefault.called)

      it 'should limit to 3 numbers', ->
        $rtn = $('<input type=text>').bank('BranchNumber', 'JP')
        $rtn.val('012')

        e = $.Event('keypress')
        e.which = 57 # '9'
        sinon.stub(e, 'preventDefault')
        $rtn.trigger(e)

        assert(e.preventDefault.called)

    describe 'Format routing transit number of American Bank', ->
      it 'should allow numeric characters', ->
        $rtn = $('<input type=text>').bank('RoutingTransitNumber', 'US')
        $rtn.val('012')

        e = $.Event('keyup')
        e.which = 51 # '3'
        sinon.stub(e, 'preventDefault')
        $rtn.trigger(e)

        assert(e.preventDefault.notCalled)

      it 'should not allow non-numeric characters', ->
        $rtn = $('<input type=text>').bank('RoutingTransitNumber', 'US')
        $rtn.val('0123')

        e = $.Event('keypress')
        e.which = 97 # 'a'
        sinon.stub(e, 'preventDefault')
        $rtn.trigger(e)

        assert(e.preventDefault.called)

      it 'should limit to 9 numbers', ->
        $rtn = $('<input type=text>').bank('RoutingTransitNumber', 'US')
        $rtn.val('012345678')

        e = $.Event('keypress')
        e.which = 57 # '9'
        sinon.stub(e, 'preventDefault')
        $rtn.trigger(e)

        assert(e.preventDefault.called)

  describe '$.bank.validate', ->
    describe 'Argument validation', ->
      it 'throws an error if a given country is not supported', ->
        assert.throws ->
          $.bank.validate('RoutingTransitNumber', 'Invalid', '123456789')

      it 'throws an error if a given field is not supported in a given country', ->
        assert.throws ->
          $.bank.validate('Invalid', 'US', '123456789')

    describe 'Validating a bank number of Japanese Bank', ->
      it 'should fail if it is empty', ->
        isValid = $.bank.validate 'BankNumber', 'JP', ''
        assert.equal isValid, false

      it 'should fail if it is a bunch of spaces', ->
        isValid = $.bank.validate 'BankNumber', 'JP', '       '
        assert.equal isValid, false

      it 'should fail if it is less than 4 numbers', ->
        isValid = $.bank.validate 'BankNumber', 'JP', '012'
        assert.equal isValid, false

      it 'should fail if it is more than 4 numbers', ->
        isValid = $.bank.validate 'BankNumber', 'JP', '01234'
        assert.equal isValid, false

      it 'should fail if it has a non-numeric character', ->
        isValid = $.bank.validate 'BankNumber', 'JP', '012a'
        assert.equal isValid, false

      it 'should succeed if it is 4 numeric characters', ->
        isValid = $.bank.validate 'BankNumber', 'JP', '0123'
        assert.equal isValid, true

    describe 'Validating a branch number of Japanese Bank', ->
      it 'should fail if it is empty', ->
        isValid = $.bank.validate 'BranchNumber', 'JP', ''
        assert.equal isValid, false

      it 'should fail if it is a bunch of spaces', ->
        isValid = $.bank.validate 'BranchNumber', 'JP', '       '
        assert.equal isValid, false

      it 'should fail if it is less than 3 numbers', ->
        isValid = $.bank.validate 'BranchNumber', 'JP', '01'
        assert.equal isValid, false

      it 'should fail if it is more than 3 numbers', ->
        isValid = $.bank.validate 'BranchNumber', 'JP', '0123'
        assert.equal isValid, false

      it 'should fail if it has a non-numeric character', ->
        isValid = $.bank.validate 'BranchNumber', 'JP', '01a'
        assert.equal isValid, false

      it 'should succeed if it is 3 numeric character', ->
        isValid = $.bank.validate 'BranchNumber', 'JP', '012'
        assert.equal isValid, true

    describe 'Validating a routing transit number of American Bank', ->
      it 'should fail if it is empty', ->
        isValid = $.bank.validate 'RoutingTransitNumber', 'US', ''
        assert.equal isValid, false

      it 'should fail if it is a bunch of spaces', ->
        isValid = $.bank.validate 'RoutingTransitNumber', 'US', '       '
        assert.equal isValid, false

      it 'should fail if it is less than 9 numbers', ->
        isValid = $.bank.validate 'RoutingTransitNumber', 'US', '00123456'
        assert.equal isValid, false

      it 'should fail if it is more than 9 numbers', ->
        isValid = $.bank.validate 'RoutingTransitNumber', 'US', '0012345678'
        assert.equal isValid, false

      it 'should fail if it has a non-numeric character', ->
        isValid = $.bank.validate 'RoutingTransitNumber', 'US', '00123456a'
        assert.equal isValid, false

      it 'should fail if it has all zeroes', ->
        isValid = $.bank.validate 'RoutingTransitNumber', 'US', '000000000'
        assert.equal isValid, false

      it 'should fail if checksum is not multiple of 10', ->
        isValid = $.bank.validate 'RoutingTransitNumber', 'US',  '001234562'
        assert.equal isValid, false

      it 'should fail if the first digits are out of range 00-12, 21-32, 61-72, 80', ->
        isValid = $.bank.validate 'RoutingTransitNumber', 'US', '130000006'
        assert.equal isValid, false
        isValid = $.bank.validate 'RoutingTransitNumber', 'US', '200000004'
        assert.equal isValid, false
        isValid = $.bank.validate 'RoutingTransitNumber', 'US', '330000000'
        assert.equal isValid, false
        isValid = $.bank.validate 'RoutingTransitNumber', 'US', '600000002'
        assert.equal isValid, false
        isValid = $.bank.validate 'RoutingTransitNumber', 'US', '730000008'
        assert.equal isValid, false
        isValid = $.bank.validate 'RoutingTransitNumber', 'US', '790000006'
        assert.equal isValid, false
        isValid = $.bank.validate 'RoutingTransitNumber', 'US', '810000009'
        assert.equal isValid, false
      
      it 'should succeed if it is valid', ->
        isValid = $.bank.validate 'RoutingTransitNumber', 'US', '001234561'
        assert.equal isValid, true
        isValid = $.bank.validate 'RoutingTransitNumber', 'US', '120000003'
        assert.equal isValid, true
        isValid = $.bank.validate 'RoutingTransitNumber', 'US', '210000007'
        assert.equal isValid, true
        isValid = $.bank.validate 'RoutingTransitNumber', 'US', '320000007'
        assert.equal isValid, true
        isValid = $.bank.validate 'RoutingTransitNumber', 'US', '610000005'
        assert.equal isValid, true
        isValid = $.bank.validate 'RoutingTransitNumber', 'US', '720000005'
        assert.equal isValid, true
        isValid = $.bank.validate 'RoutingTransitNumber', 'US', '800000006'
        assert.equal isValid, true
