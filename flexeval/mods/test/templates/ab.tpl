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
    <legend class="mb-3"><strong>Question:</strong> Between the following samples, which sample do you prefer in terms of quality?</legend>
    <div class="form-group">
      <div class="row content-row">
        {%
            set field_name = get_variable("field_name",name="ChoiceBetween")
        %}

        {% for syssample in get_variable("syssamples") %}
          {%
            set content,mimetype = syssample.get(num=1)
          %}

          <div class="form-check col-auto mb-3 test-content-col">
            <input class="form-check-input" type="radio" name="{{field_name}}" id="ID@{{syssample.ID}}" value="{{syssample.ID}}" required>
            <label class="form-check-label" for="ID@{{syssample.ID}}">
              {% if mimetype == "text" %}
                {{content}}
              {% elif mimetype == "image" %}
                <div class="img-container"><img src="{{content}}"/></div>
              {% elif mimetype == "audio" %}
                <audio controls readall>
                  <source src="{{content}}">
                  Your browser does not support the <code>audio</code> element.
                </audio>
              {% elif mimetype == "video" %}
                <video controls readall>
                  <source src="{{content}}">
                  Your browser does not support the <code>video</code> element.
                </video>
              {% else %}
                <p class="text-muted">Content type not supported</p>
              {% endif %}
            </label>
          </div>
        {% endfor %}
      </div>
    </div>
  </fieldset>


  <button type="submit" class="btn btn-primary">Submit</button>

</form>



{% endblock %}
