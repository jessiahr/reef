Vue.mixin
  methods:
    kachingCreateCardToken: ->
      @$broadcast('Kaching::create-card-token')
    kachingResetForm: ->
      @$broadcast('Kaching::reset-form')
return {
# Kaching is mainly responsible for using the entered
# credit card info to fetch the stripe token required
# for the actual payment processing to take place
  props:
    callback:
      required: false
    showLabels:
      default: false
    devMode:
      default: false
    shopUri:
      required: false
    card:
      required: true
      twoWay: true
    stripeKey:
      required: true
    stripeError: null
  ready: ->
    @ensureStripe()
    if @devMode
      @number = "4242424242424242"
      @cvc = "123"
      @expYear = "19"
      @expMonth = '1'

  data: ->
    number: ""
    cvc: ""
    expYear: ""
    expMonth: ""
    monthList: [1..12]
    placeholders:
      year: 'Year'
      month: 'Month'
      cvc: 'CVC'
      number: "Card Number"
    validationErrors:
      number: ""
      cvc: ""
      expYear: ""
      expMonth: ""

  computed:
    yearIsPlaceholder: ->
      @expYear.length == 0
    monthIsPlaceholder: ->
      @expMonth.length == 0
    yearList: ->
      today = new Date
      yyyy = today.getFullYear()
      years = for num in [yyyy.. (yyyy + 10)]
        num.toString().substr(2,2)
      return years

    cardParams: ->
      number: @number
      expMonth: @expMonth
      expYear: @expYear
      cvc: @cvc

  events:
    'Kaching::create-card-token': ->
      @createToken()
    'Kaching::reset-form': ->
      @resetKaching()
    'Kaching::process-error': (error) ->
      @stripeError = error

  methods:
    ensureStripe: (e)->
      if !Stripe?
        head = document.getElementsByTagName("head")[0]
        newScript = document.createElement("script")
        newScript.type = "text/javascript"
        newScript.async = !0
        newScript.onload = e
        newScript.src = "https://js.stripe.com/v2/"
        head.appendChild(newScript)
    resetKaching: ->
      console.log "resetting "
      @expMonth = ""
      @cvc = ""
      @expYear = ""
      @number = ""
      @card = null

    formatCard: (event) ->
      console.log "formatting"
      output = @number.split("-").join("")
      if (output.length > 0)
        output = output.replace(/[^\d]+/g,'')
        output = output.match(new RegExp('.{1,4}', 'g'))
        if output
          @number = output.join("-")
        else
          @number = ""

    createToken: ->
      Stripe.setPublishableKey(@stripeKey)
      Stripe.card.createToken @cardParams, @createTokenCallback

    createTokenCallback: (status, resp) ->
      @validationErrors =
        number: ""
        cvc: ""
        expYear: ""
        expMonth: ""
      @stripeError = resp.error
      if @stripeError
        @validationErrors.number = "error" if @stripeError.param == "number"
        @validationErrors.expYear = "error" if @stripeError.param == "exp_year"
        @validationErrors.expMonth = "error" if @stripeError.param == "exp_month"
        @validationErrors.cvc = "error" if @stripeError.param == "cvc"

      if (status == 200)
        @card = resp
        @callback(resp)
        if @shopUri
          uploadReq = $.ajax
            method: 'post'
            url: @shopUri
            contentType: 'application/json; charset=utf-8'
            dataType: "json"
            data:
              JSON.stringify({card: @resp})

  template: """
  <slot>
    <form class="kaching">
      <div class="form-row">
        <div class="field">
          <span for="creditCardNumber" v-if="showLabels" class="hidden">Card Number</span>
          <input maxlength="19" type="text" name="creditCardNumber" id="creditCardNumber" @keyup="formatCard($event)" v-model="number" size="20" v-bind:class="[validationErrors.number]" class="card-number" placeholder="{{placeholders.number}}"/>
        </div>
      </div>

      <div class="form-row">
        <div class="field inline">
          <span v-if="showLabels" class="hidden">Expiration (MM/YYYY)</span>
          <div class="styled-select" v-bind:class="[validationErrors.expMonth]">
            <select v-model="expMonth" v-bind:class="[monthIsPlaceholder ? 'placeholder' : '']" class="expiration-month">
              <option disabled selected value="">{{placeholders.month}}</option>
              <option v-for="month in monthList">{{ month }}</option>
            </select>
          </div>
        </div>

        <div class="field inline">
          <label for="expirationYear"  v-if="showLabels" class="hidden">Expiration year</label>
          <div class="styled-select" v-bind:class="[validationErrors.expYear]">
            <select v-model="expYear" name="expirationYear" id="expirationYear" v-bind:class="[yearIsPlaceholder ? 'placeholder' : '']" class="expiration-year">
              <option disabled selected value="">{{placeholders.year}}</option>
              <option v-for="year in yearList">{{ year }}</option>
            </select>
          </div>
        </div>

        <div class="field inline">
          <span v-if="showLabels" for="cvc" class="hidden">CVC</span>
          <input type="text" v-bind:class="[validationErrors.cvc]" name="cvc" id="cvc" v-model="cvc" size="4" class="cvc" placeholder="{{placeholders.cvc}}"/>
        </div>
      </div>

      <span transition="expand" v-if="stripeError" class="error-text">{{stripeError.message}}</span>
    </form>
    </slot>
  """
}