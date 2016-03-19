module ReefHelper
  define_method(:vue_with) do |data: [], debug: false, el: "#app", on_ready: false|
    output = ""
    if on_ready
      return "
        <script>
        $( document ).ready(function() {
          Vue.use(VueResource);
          Vue.config.debug = #{debug};
          Vue.http.headers.common['X-CSRF-Token'] = $('meta[name=\"csrf-token\"]').attr('content')
          var v = new Vue({
            el: '#{el}',
            data: #{data.to_json}
          });
        });
        </script>
      ".html_safe
    else
      return "
        <script>
        Vue.use(VueResource);
        Vue.config.debug = #{debug};
        Vue.http.headers.common['X-CSRF-Token'] = $('meta[name=\"csrf-token\"]').attr('content')
          var v = new Vue({
            el: '#{el}',
            data: #{data.to_json}
          });

        </script>
      ".html_safe
    end
  end
end
