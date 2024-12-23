{% extends get_template('base.tpl','flexeval') %}

{% block content %}

{% set form_json = get_variable("form_json_data")%}

<h2 class="bd-content-title"> <i class="bi bi-caret-right-fill icon-chevron-title"></i> {{form_json["title"]}}</h2>


<form action="./save" method="post" class="form-example">

  {% for component in form_json["components"] %}
    <div class="form-group">
      <label for="name">{{component["label"]}}</label>
      <input type="{{component['input']['type']}}" name="{{component['id']}}" id="{{component['id']}}" class="form-control" required>
    </div>
  {% endfor %}

  <button type="submit" class="btn btn-primary">Submit</button>

</form>


{% endblock %}
