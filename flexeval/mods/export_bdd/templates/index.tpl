{% extends get_template('base.tpl','flexeval') %}

{% block content %}

  <h2 class="bd-content-title"> <i class="bi bi-caret-right-fill icon-chevron-title"></i> {{get_variable("subtitle",default_value="Download BDD")}}</h2>

  <div class="row d-flex justify-content-center">

    <div class="col-md-4">
      <div class="card mb-3">
        <div class="card-body">
          <h5 class="card-title">CSV</h5>
          <p class="card-text">Download a zip repository containing the database dumped in csv files and <a href="https://developer.mozilla.org/fr/docs/Web/API/Blob">blob files.</p>
          <a href="flexeval.zip" class="btn btn-primary">Download</a>
        </div>
      </div>
    </div>

    <div class="col-md-4">
      <div class="card mb-3">
        <div class="card-body">
          <h5 class="card-title">SQLite</h5>
          <p class="card-text">Download the sqlite base.</p>
          <a href="flexeval.db" class="btn btn-primary">Download</a>
        </div>
      </div>
    </div>

  </div>


{% endblock %}
