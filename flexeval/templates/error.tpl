{% extends get_template('base.tpl','flexeval') %}

{% block content %}

  {% if get_variable("code") == 401%}
  <h2 class="bd-content-title"><i class="bi bi-caret-right-fill icon-chevron-title"></i> 401 Unauthorized  </h2>
  <p>Authentication is required and has failed or has not yet been provided.</p>
  {%elif get_variable("code") == 404%}
  <h2 class="bd-content-title"><i class="bi bi-caret-right-fill icon-chevron-title"></i> 404 Not Found  </h2>
  <p>The requested resource could not be found but may be available in the future.</p>
  {% elif get_variable("code") == 403%}
  <h2 class="bd-content-title"><i class="bi bi-caret-right-fill icon-chevron-title"></i> 403 Forbidden  </h2>
  <p>You don't have the permission to access the requested resource. It is either read-protected or not readable by the server.</p>
  {%elif get_variable("code") == 408%}
  <h2 class="bd-content-title"><i class="bi bi-caret-right-fill icon-chevron-title"></i> 408 Request Timeout  </h2>
  <p>The server timed out waiting for the request.</p>
  {% elif get_variable("code") == 410%}
  <h2 class="bd-content-title"><i class="bi bi-caret-right-fill icon-chevron-title"></i>  410 Gone </h2>
  <p>The resource requested is no longer available and will not be available again.</p>
  {% elif get_variable("code") == 418%}
  <h2 class="bd-content-title"><i class="bi bi-caret-right-fill icon-chevron-title"></i>  418 I'm a teapot </h2>
  <p>I cannot brew coffee.</p>
  {%else%}
  <h2 class="bd-content-title"><i class="bi bi-caret-right-fill icon-chevron-title"></i> HTTP status code: {{get_variable("code")}}  </h2>
  <p>Something wrong happened ...</p>
  {% endif %}

  <a href="{{homepage}}"> Back </a>
{% endblock %}
