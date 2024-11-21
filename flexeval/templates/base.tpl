<html>

<head>

  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta lang="en">
  <link rel="icon" href="{{get_asset('/img/favicon.ico','flexeval')}}" />

  <title> {{ get_variable("title",default_value="flexeval")}} </title>

  <!-- JQuery -->
  <script type="text/javascript" src="{{get_asset('/js/jquery-3.7.1/jquery-3.7.1.min.js','flexeval')}}"></script>
  <script type="text/javascript" src="{{get_asset('/js/jquery-ui-1.12.1/jquery-ui.min.js','flexeval')}}"></script>
  <link href="{{get_asset('/css/jquery-ui-1.12.1/jquery-ui.min.css','flexeval') }}" rel="stylesheet">

  <!-- Bootstrap Core CSS -->
  <script type="text/javascript" src="{{get_asset('/js/popper/popper.min.js','flexeval')}}"></script>
  <link rel="stylesheet" href="{{get_asset('/css/bootstrap-5.3.3/bootstrap.min.css','flexeval')}}">
  <link rel="stylesheet" href="{{get_asset('/css/bootstrap-icons-1.11.3/bootstrap-icons.css','flexeval')}}">
  <link rel="stylesheet" href="{{get_asset('/css/bootstrap-table-1.22.6/bootstrap-table.min.css','flexeval')}}">
  <script type="text/javascript" src="{{get_asset('/js/bootstrap-5.3.3/bootstrap.bundle.min.js','flexeval')}}"></script>
  
  <!-- Additional libraries -->
  <script type="text/javascript" src="{{get_asset('/js/flexeval/flexeval.js','flexeval')}}"></script>
  <link href="{{get_asset('/css/flexeval/flexeval.css','flexeval')}}" rel="stylesheet">

  {% block head %}
  {% endblock %}

</head>

<body>

  {% block header %}
  <header class="container-fluid border-bottom box-shadow bg-white">
    <div class="container-fluid">
      <nav class="navbar navbar-expand-md w-100 box-shadow">
        <a class="navbar-brand" href="{{make_url('/')}}">{{ get_variable("title",default_value="FlexEval")}} </a>

        <!-- Collapsable nav bar -->
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">
          <ul class="navbar-nav">
            <li class="nav-item"><a class="nav-link" href="{{make_url('/')}}">Home</a></li>
            <li class="nav-item"><a class="nav-link" href="{{make_url('/admin/')}}">Admin panel</a></li>
          </ul>

          {% if get_variable("description") is not none %}
          <!-- Description -->
          <ul id="description" class="navbar-nav ms-auto">
            <li>{{get_variable("description")}}</li>
          </ul>
          {% endif %}

          {%block userintel%}{% if auth.is_connected %}
          <!-- User info -->
          <ul class="navbar-nav ms-auto">
              <li class="text-muted">Logged in as {{ auth.user.pseudo}} <a class="px-2" href="{{ auth.url_deco  }} "> Log out </a></li>
          </ul>
          {% endif %}{%endblock%}

        </div>
      </nav>
    </div>
  </header>
  {% endblock %}


  <!-- BLOCK CONTENT -->
  <main class="container-fluid text-dark">
    <section id="main-section" class="col-10 offset-1">
      <div class="container-fluid">
        {% block content %}

        {% endblock %}
      </div>
    </section>
  </main>

  
  <!-- FOOTER -->
  {% block footer %}
  <footer class="fixed-bottom bg-white text-dark border-top">

    <div class="row">

      <!-- IRISA logo -->
      <div class="col-md-2 text-center offset-md-3">
        <a href="http://www.irisa.fr" target="_blank" >
          <img src="{{get_asset('/img/logo/irisa.png','flexeval')}}" class="img-responsive center-block" alt="IRISA lab">
        </a>
      </div>

      <!-- Footer bottom text -->
      <div class="col-md-2 text-center">
        <!-- Credits -->
        <span class="text-muted"> {% if get_variable("authors") is not none %} Made by {{get_variable("authors")}}. {% endif %} </span><br>
        <span class="text-muted"> Powered by <a href="https://gitlab.inria.fr/expression/tools/FlexEval"><i class="bi bi-gitlab"></i>FlexEval</a>.</span>
      </div>
      
      <!-- EXPRESSION logo -->
      <div class="col-md-2 text-center">
        <a href="http://www-expression.irisa.fr" target="_blank">
          <img src="{{get_asset('/img/logo/expression.png','flexeval')}}" class="img-responsive center-block" alt="Expression team">
        </a>
      </div>

    </div>

  </footer>
  {% endblock %}
</body>
</html>
