{% extends get_template('base.tpl','flexeval') %}

{% block content %}

<h2 class="bd-content-title"> <i class="bi bi-caret-right-fill icon-chevron-title"></i> Who are you ?</h2>
<form action="./save" method="post" class="form-example" enctype="multipart/form-data">

<div class="form-group">
    <label for="avatar">Avatar: </label>
    <input type="file" name="avatar" id="avatar" class="form-control" required>
</div>

<button type="submit" class="btn btn-primary">Submit</button>

</form>

{% endblock %}