{% extends get_template('base.tpl','flexeval') %}

{% block content %}

  <h2 class="bd-content-title"><i class="bi bi-caret-right-fill icon-chevron-title"></i> Admin Panel</h2>

  <form class="row form-example" action="./login" method="post" >
    <div class="col-md-6 offset-md-3">
      <div class="input-group mb-3">
        <input type="password" name="admin_password" id="admin_password" class="form-control" placeholder="Password" required>
        <button class="btn btn-primary" type="submit">Log in</button>
      </div>
    </div>

  </form>

{% endblock %}
