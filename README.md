# jQuery.bank [![Build Status](https://travis-ci.org/gumroad/jquery.bank.png)](https://travis-ci.org/gumroad/jquery.bank)

A library for building bank account forms, formatting and validating inputs.

## Installation

If you use bower:
```
bower install jquery.bank
```

Otherwise, you can download it from [here](https://github.com/gumroad/jquery.bank/blob/master/lib/jquery.bank.js).

## API

### $.fn.bank(field, countryCode)

Formats input value as a bank account field `field` in country `countryCode`.

[ISO 3166-1 alpha-2](https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2) is used for `countryCode`.

### $.bank.validate(field, countryCode, number)

Validates a given number as a bank account field `field` in country `countryCode`. It returns if it is valid and false if it is invalid.

Note that validation is designed to detect accidental errors. In other word, if the validation test says the number is invalid, it is 100% incorrect. However, if the test says the number is valid, there is a chance that the number is incorrect.

## Formats and Validations

### Japan (JP)

#### Bank Number

```javascript
$input.bank('BankNumber', 'JP');
```

* Restricts input to numbers
* Limits to 4 numbers

```javascript
$.bank.validate('BankNumber', 'JP', number);
```

* Validates numbers
* Validates length to 4

#### Branch Number

```javascript
$input.bank('BranchNumber', 'JP');
```

* Restricts input to numbers
* Limits to 3 numbers

```javascript
$.bank.validate('BranchNumber', 'JP', number);
```

* Validates numbers
* Validates length to 3

### United States (US)

#### Routing Transit Number

```javascript
$input.bank('RoutingTransitNumber', 'US');
```

* Restricts input to numbers
* Limits to 9 numbers

```javascript
$.bank.validate('RoutingTransitNumber', 'US', number);
```

* Validates numbers
* Validates length to 9
* Validates first two digits
* Validates check (last) digit

## Example

[http://gumroad.github.io/jquery.bank/](http://gumroad.github.io/jquery.bank/)

## Contribute

Install development dependencies
```
npm install
```

We follow [polarmobile/coffeescript-style-guide](https://github.com/polarmobile/coffeescript-style-guide).

### Test

```
npm test
```

### Build

```
cake build
```

## References

* [Routing Transit Number Wiki](http://en.wikipedia.org/wiki/Routing_transit_number)
* [jQuery.payment](https://github.com/stripe/jquery.payment)
