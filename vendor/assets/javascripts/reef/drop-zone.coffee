return {
  template: """
      <div class="dropzone-area p1" drag-over="handleDragOver" @dragenter="hovering = true" @dragleave="hovering = false" :class="{'hovered': hovering}">
          <div class="dropzone-text">
              <span class="dropzone-title">+</span>
              <span class="dropzone-info" v-if="help">{{ help }}</span>
          </div>
          <input type="file" :multiple="collection" @change="onFileChange">
      </div>
  """

  props:
    files:
      required: true
    collection:
      default: true

  data: ->
    image: '',
    hovering:false

  methods:
    onFileChange: (e) ->
      files = e.target.files || e.dataTransfer.files;
      if (files.length > 0 )
        console.log( files)
        if @files == undefined
          console.warn 'dropzone: files array is not defined'
        for file in files
          @files.push(file)
}