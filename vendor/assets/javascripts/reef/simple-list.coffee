return {
  props:
    list:
      required: true

  template: """
   <div class="col-16" v-for="item in list">
    {{item}}
    </div>
  """
}