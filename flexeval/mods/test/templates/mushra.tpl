{% extends get_template('base.tpl','flexeval') %}

{% block head %}
<script src="{{get_asset('/js/flexeval/mushra_range.js','flexeval')}}"></script>
{% endblock %}

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


<h2 class="bd-content-title"><i class="bi bi-caret-right-fill icon-chevron-title"></i>{{get_variable("subtitle","Test")}} - step {{get_variable("step")}} over {{get_variable("max_steps")}}</h2>

<form action="./save" method="post" enctype="multipart/form-data" class="form-example">

  <fieldset class="form-group">
    <legend class="mb-3"><strong>Question:</strong> How do you judge the quality of the following candidates against the reference?</legend>
    <fieldset class="form-group mb-3">
      <legend><strong>Reference</strong></legend>
      <div class="row reference-row">
        <div class="col-auto">
          <div class="reference-container">
            {% set _sysref = get_variable("syssamples",get_variable("sysref"))[0] %}
            {% set content,mimetype = _sysref.get(num=0)  %}

            {% if mimetype == "text" %}
              {{content}}
            {% elif mimetype == "image" %}
            <div class="img-container"><img src="{{content}}"/></div>
            {% elif mimetype == "audio" %}
              <audio controls readall><source src="{{content}}">Your browser does not support the <code>audio</code> element.</audio>
            {% elif mimetype == "video" %}
              <video controls readall><source src="{{content}}">Your browser does not support the <code>video</code> element.</video>
            {% else %}
                {{content}}
            {% endif %}
          </div>
        </div>
      </div>
    </fieldset>
    
    <hr class="my-1">
    <fieldset class="form-group mb-3">
      <legend><strong>Candidates</strong></legend>
      <div class="row content-row">
      {% for syssample in get_variable("syssamples") %}

        {% if not(syssample.system_name == get_variable("sysref")) %}

          {% set name_field = get_variable("field_name",name="MUSHRA_score",syssamples=[syssample]) %}
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
              <div class="range-container mb-3">
                <span class="range-label-min m-1">0</span>
                <input name="{{ name_field }}" class="form-range" data-trigger="hover" data-toggle="popover" data-content="Fair (50)" data-placement="right" id="score@{{syssample.ID}}" type="range" data-slider-min="0" data-slider-max="100" data-slider-step="1" data-slider-value="50" required />
                <span class="range-label-max m-1">100</span>
              </div>
              <output name="{{ name_field }}" for="score@{{syssample.ID}}" class="range-output" id="score@{{syssample.ID}}_output">Fair (50)</output>
            </div>
          </div>
        {% endif %}
      {% endfor %}
    </fieldset>

  </fieldset>

  <button type="submit" class="btn btn-primary">Submit</button>

</form>
{% endblock %}
