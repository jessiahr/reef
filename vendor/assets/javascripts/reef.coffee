class @Reef
  @COMPONENT_URL: 'http://localhost:3000'
@Reef.ensureVue = ->
  if !Vue?
   compLoad = $.ajax
      method: 'get'
      url: "/assets/reef/vue.js"
    compLoad.done (res) =>
      console.log 'Vue.js loaded by reef'
      eval(res)
      @loadComponentList()
    compLoad.fail (jqXhr, textStatus, err) ->
      console.log jqXhr, textStatus, err
  else 
    @loadComponentList()
   
@Reef.remoteLoadComponent = (name) ->
  foo = 1
  Vue.component name,(resolve, reject) =>
    compLoad = $.ajax
      method: 'get'
      url: "#{@COMPONENT_URL}/assets/reef/#{name}.js"
    compLoad.done (res) ->
      resolve(
        eval(res)
      )
    compLoad.fail (jqXhr, textStatus, err) ->
      console.log jqXhr, textStatus, err
      reject()
@Reef.loadComponentList = ->
  for component in @.COMPONENT_LIST
    console.log "Loading #{component}"
    @.remoteLoadComponent(component)

@Reef.start = (componentList) ->
  @.COMPONENT_LIST = componentList
  @loadComponentList()
  

Reef.start(['simple-list'])