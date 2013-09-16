$         = jQuery
$.bank    = {}

# Position weights used to compute check some for check digit.
CHECK_DIGIT_POSITION_WEIGHTS = [3, 7, 1]

# ISO 3166-1 alpha-2 is used for country code.
formattingRules =
  US:
    RoutingTransitNumber:
      length: 9
      charPattern: /\d/
  JP:
    BankNumber:
      length: 4
      charPattern: /\d/
    BranchNumber:
      length: 3
      charPattern: /\d/

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
  @on('keypress', restrictCharPattern format.charPattern) if format.charPattern?

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
    $target = $(e.currentTarget)
    return if hasTextSelected($target)

    unless $target.val().length < length
      e.preventDefault()

restrictCharPattern = (charPattern) ->
  (e) ->
    # Key event is for a browser shortcut
    return true if e.metaKey or e.ctrlKey

    # If keycode is a special char (WebKit)
    return true if e.which is 0

    # If char is a special char (Firefox)
    return true if e.which < 33

    char = String.fromCharCode(e.which)
    unless charPattern.test(char)
      e.preventDefault()

hasTextSelected = ($target) ->
  return true if $target.prop('selectionStart')? and $target.prop('selectionStart') isnt $target.prop('selectionEnd')

  # Checking for IE.
  return true if document?.selection?.createRange?().text

  false

## Validation

validate = (validation, number) ->
  number = (number + '').replace(/\s+/g, '')
  return false unless validation.pattern.test(number)
  if validation.other?
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
