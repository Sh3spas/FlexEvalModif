{% extends get_template('base.tpl','flexeval') %}

{% block content %}

<h2 class="bd-content-title"> <i class="bi bi-caret-right-fill icon-chevron-title"></i> Choose our next step.</h2>

<a class="btn btn-primary" href="{{url_next['testAB']}}"> Test AB </a>
<a class="btn btn-primary" href="{{url_next['testMOS']}}"> Test MOS </a>
<a class="btn btn-primary" href="{{url_next['testMUSHRA']}}"> Test MUSHRA </a>


{% endblock %}
