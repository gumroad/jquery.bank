$         = jQuery
$.bank    = {}

# Position weights used to compute check some for check digit.
CHECK_DIGIT_POSITION_WEIGHTS = [3, 7, 1]

# ISO 3166-1 alpha-2 is used for country code.
formattingRules =
  US:
    RoutingTransitNumber:
      length: 9
      pattern: /\d/
  JP:
    BankNumber:
      length: 4
      pattern: /\d/
    BranchNumber:
      length: 3
      pattern: /\d/

validationRules =
  US:
    RoutingTransitNumber:
      pattern: /^(0[0-9]|1[0-2]|2[1-9]|3[0-2]|6[1-9]|7[0-2]|80)\d{7}$/
      other: ['validateCheckDigit']
  JP:
    BankNumber:
      pattern: /^\d{4}$/
    BranchNumber:
      pattern: /^\d{3}$/

# Public

$.fn.bank = (field, country) ->
  unless formattingRules[country]?
    throw new Error(country + 'is not supported.')
  unless formattingRules[country][field]?
    throw new Error('A format of ' + field + ' for ' + country + 'is not supported.')

  format = formattingRules[country][field]
  @on('keypress', restrictLength format.length) if format.length?
  @on('keypress', restrictPattern format.pattern) if format.pattern?

$.bank.validate = (field, country, number) ->
  unless validationRules[country]?
    throw new Error(country + 'is not supported.')
  unless validationRules[country][field]?
    throw new Error('A validation of ' + field + ' for ' + country + 'is not supported.')
  validate(validationRules[country][field], number)

# Private

## Formatting

restrictLength = (length) ->
  (e) ->
    unless $(e.currentTarget).val().length < length
      e.preventDefault()

restrictPattern = (pattern) ->
  (e) ->
    char = String.fromCharCode(e.which)
    unless pattern.test(char)
      e.preventDefault()

## Validation

validate = (validation, number) ->
  number = (number + '').replace(/\s+/g, '')
  return false unless validation.pattern.test(number)
  for name in validation.other
    return false unless validations[name](number)
  return true

validations =
  validateCheckDigit: (number) ->
    digits = number.split('')
    sum = 0
    for digit, i in digits
      sum += (parseInt(digit) * CHECK_DIGIT_POSITION_WEIGHTS[i % 3])
    sum != 0 and sum % 10 == 0
