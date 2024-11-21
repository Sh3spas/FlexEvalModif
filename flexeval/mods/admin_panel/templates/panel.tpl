{% extends get_template('base.tpl','flexeval') %}

{% block content %}

  <h2 class="bd-content-title"><i class="bi bi-caret-right-fill icon-chevron-title"></i> {{get_variable("subtitle",default_value="Admin Panel")}}</h2>

  <div class="row d-flex justify-content-center">

    {% for admin_module in get_variable("admin_modules")%}
    
    <div class="col-md-4">
      <div class="card mb-3">
        <div class="card-body">
          <h5 class="card-title">{{admin_module.title}}</h5>
          <p class="card-text">{{admin_module.description}}</p>
          <a href="{{admin_module.url}}" class="btn btn-primary">Access</a>
        </div>
      </div>
    </div>

    {% endfor %}


    </div>


{% endblock %}

