{% extends get_template('base.tpl','flexeval') %}

{% block content %}

{% if get_variable("intro_step",False) %}
<div class="alert alert-warning alert-dismissible fade show" role="alert">
  <h4 class="alert-heading">This is the <strong>introduction</strong>.</h4>
  <p>Your answers will <strong>not</strong> be recorded as correct answer.</p>
  <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
</div>
{% endif %}

{% if not(get_variable("intro_step",False)) and (get_variable("step") == 1) %}
  <div class="alert alert-danger alert-dismissible fade show" role="alert">
    <h4 class="alert-heading">This is now the <strong>real</strong> test, not an introduction step.</h4>
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
  </div>
{% endif %}


<h2 class="bd-content-title"> <i class="bi bi-caret-right-fill icon-chevron-title"></i> {{get_variable("subtitle","Test")}} - step {{get_variable("step")}} over {{get_variable("max_steps")}}</h2>

<form action="./save" method="post" enctype="multipart/form-data" class="form-example">

  <fieldset class="form-group mb-3">
    <legend class="mb-3"><strong>Question:</strong> How do you judge the <strong>quality</strong> of the following sample?</legend>
    <div class="row content-row">
      {% for syssample in get_variable("syssamples") %}
        {% set field_name = get_variable("field_name",name="MOS_score",syssamples=[syssample]) %}
        {% set content,mimetype = syssample.get(num=0)  %}
        <div class="col-auto">
          <div class="input-group test-content-col">
            <label for="score@{{syssample.ID}}">
              {% if mimetype == "text" %}
                {{content}}
              {% elif mimetype == "image" %}
                <div class="img-container"><img src="{{content}}"/></div>
              {% elif mimetype == "audio" %}
                <audio controls readall><source src="{{content}}">Your browser does not support the <code>audio</code> element.</audio>
              {% elif mimetype == "video" %}
                <video controls readall><source src="{{content}}">Your browser does not support the <code>video</code> element.</video>
              {% else %}
                <p class="text-muted">Content type not supported</p>
              {% endif %}
            </label>
            <select id="score@{{syssample.ID}}" name="{{ field_name }}" class="form-select mb-3" required>
              <option value="" selected disabled hidden>Choose here</option>
              <option value="5">Excellent</option>
              <option value="4">Good</option>
              <option value="3">Fair</option>
              <option value="2"> Poor </option>
              <option value="1"> Bad </option>
            </select>
          </div>
        </div>
      {% endfor %}
    </div>

  </fieldset>

  <button type="submit" class="btn btn-primary">Submit</button>

</form>
{% endblock %}
