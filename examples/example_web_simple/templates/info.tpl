{% extends get_template('base.tpl','flexeval') %}

{% block content %}

<h2 class="bd-content-title"> <i class="bi bi-caret-right-fill icon-chevron-title"></i> Who are you ?</h2>
<form action="./save" method="post" class="form-example">

<div class="form-group">
    <label for="name">Enter your Name: </label>
    <input type="text" name="name" id="name" class="form-control" required>
</div>

<div class="form-group">
    <label for="tel">Enter your telephone number: </label>
    <input type="number" name="tel" id="tel" class="form-control" required>
</div>

<button type="submit" class="btn btn-primary">Submit</button>

</form>

{% endblock %}