{% extends get_template('base.tpl','flexeval') %}

{% block head %}
<!-- Table -->
<script type="text/javascript" src="{{get_asset('/js/bootstrap-table-1.22.6/bootstrap-table.min.js','flexeval')}}"></script>
<script type="text/javascript" src="{{get_asset('/js/bootstrap-table-1.22.6/bootstrap-table-filter-control.min.js','flexeval')}}"></script>
<script type="text/javascript" src="{{get_asset('/js/bootstrap-table-1.22.6/bootstrap-table-export.min.js','flexeval')}}"></script>
<script type="text/javascript" src="{{get_asset('/js/bootstrap-table-1.22.6/bootstrap-table-mobile.min.js','flexeval')}}"></script>

<!-- Table export -->
<script type="text/javascript" src="{{get_asset('/js/tableexport-jquery-plugin-1.30.0/tableExport.min.js','flexeval')}}"></script>
<script type="text/javascript" src="{{get_asset('/js/FileSaver/FileSaver.min.js','flexeval')}}"></script>
<script type="text/javascript" src="{{get_asset('/js/html2canvas/html2canvas.min.js','flexeval')}}"></script>
<script type="text/javascript" src="{{get_asset('/js/js-xlsx/xlsx.core.min.js','flexeval')}}"></script>
<script type="text/javascript" src="{{get_asset('/js/jsPDF/jspdf.umd.min.js','flexeval')}}"></script>
<script type="text/javascript" src="{{get_asset('/js/pdfmake/pdfmake.min.js','flexeval')}}"></script>

<!-- JSZip -->
<script type="text/javascript" src="{{get_asset('/js/jszip-3.10.1/jszip.min.js','flexeval')}}"></script>

<!-- Style -->
<link rel="stylesheet" href="{{get_asset('/css/flexeval/results_panel.css','flexeval')}}">
{% endblock %}

{% block content %}
<!-- if ?error=... -->
{% if get_variable("error") %}
<div class="alert alert-danger alert-dismissible fade show" role="alert">
  <h2><i class="bi bi-exclamation-triangle-fill"></i>&nbsp;ERROR</h2>
  <p>{{get_variable("error")}}</p>
  <hr>
  <p>If this error persists, please contact the administrator.</p>
  <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
</div>
{% endif %}

<h2 class="bd-content-title"><i class="bi bi-caret-right-fill icon-chevron-title"></i> {{get_variable("subtitle",default_value="Results panel")}}</h2>
<div class="card">
  <div class="card-body">
    <h3 id="card-title" class="card-title"></h3>
    <!-- CSV Tables -->
    <div class="row">
      <div class="col-12">
        <!-- TOOLBAR TEST -->
        <div id="toolbar">
          <!-- Export button -->
          <select id="export-select" class="form-control form-select">
            <option value="all">Export all</option>
            <option value="selected">Export selected</option>
          </select>

          <!-- File select -->
          <select id="file-select" class="form-control form-select">
            <!-- Loop through the (name,json) in jsons variable -->
            {% for name, json in get_variable("jsons").items() %}
              <option value="{{json}}">{{name}}</option>
            {% endfor %}
          </select>       
        </div>

        <!-- TABLE TEST -->
        <table id="table" class="table table-bordered table-hover table-condensed">
          <thead class="table-dark"></thead>
        </table>
      </div>
    </div>
    <hr>

    <!-- CHARTS -->
    <div id="charts-row" class="row">
      <!-- Chart form -->
      <div class="col-md-auto" id="chart-form">
        <form id="gen-charts-form" action="./generate_charts" method="post" enctype="multipart/form-data">
          <div class="mb-3">
            <h4>Chart generation</h4>
            <i class="bi bi-info-circle-fill" data-bs-toggle="tooltip" data-bs-placement="top">
              Default values will be used if fields are left empty.
            </i>
          </div>

          <hr>
          <h5>Filters</h5>
          <!-- Use already existing table filters checkbox -->
          <div class="form-group mb-3">
            <div class="form-check">
              <input class="form-check-input" type="checkbox" id="use-existing-table-filters" name="use-existing-table-filters">
              <label class="form-check-label" for="use-existing-table-filters">Use existing table filters</label><br>
              <small id="use-existing-table-filters-help" class="form-text text-muted">This will override the filters below</small>
            </div>
          </div>

          <!-- Include intro step checkbox -->
          <div class="form-group mb-3" id="include-intro-step-form-group">
            <div class="form-check">
              <input class="form-check-input" type="checkbox" id="include-intro-step" name="include-intro-step">
              <label class="form-check-label" for="include-intro-step">Include intro step</label>
            </div>
          </div>

          <!-- User multi select -->
          <div class="form-group mb-3" id="user-select-form-group">
            <label for="user-select">Users</label>
            <select class="form-select" multiple aria-label="multiple select example" id="user-select" name="user-select">
              
            </select>
          </div>

          <hr>
          <h5>Customisation</h5>

          <!-- AB Format choice : Pie or Bar radio buttons -->
          <div class="form-group mb-3" id="ab-format-choice">
            <span>Chart format</span>
            <div class="form-check">
              <input class="form-check-input" type="radio" name="ab-format" id="ab-format-pie" value="pie" checked>
              <label class="form-check-label" for="ab-format-pie">Pie chart</label>
            </div>
            <div class="form-check">
              <input class="form-check-input" type="radio" name="ab-format" id="ab-format-bar" value="bar">
              <label class="form-check-label" for="ab-format-bar">Bar chart</label>
            </div>
          </div>

          <!-- Chart title -->
          <div class="form-group mb-3">
            <div class="input-group">
              <input type="text" class="form-control" id="chart-title" name="chart-title" placeholder="Title">
            </div>
          </div>

          <!-- Chart style -->
          <div class="form-group mb-3">
            <div class="input-group">
              <label class="input-group-text" for="chart-style">Style</label>
              <select id="chart-style" class="form-control form-select" name="chart-style">
                <option value="default">Default</option>
                {% for style, name in get_variable("styles").items() %}
                  <option value="{{style}}">{{name}}</option>
                {% endfor %}
              </select>
            </div>
            <small id="chart-style-help" class="form-text text-muted mb-3"><a target="_blank" href="https://matplotlib.org/stable/gallery/style_sheets/style_sheets_reference.html">See on matplotlib.org</a></small>
          </div>

          <!-- Dot plot specific: Marker type -->
          <div class="form-group mb-3" id="marker-type-form-group">
            <div class="input-group">
              <label class="input-group-text" for="marker-select">Marker type</label>
              <select id="marker-select" class="form-control form-select" name="marker-select">
                {% for marker, name in get_variable("markers").items() %}
                  <option value="{{marker}}">{{name}}</option>
                {% endfor %}
              </select>
            </div>
          </div>

          <!-- X and Y axis labels -->
          <div class="form-group mb-3" id="x-axis-form-group">
            <div class="input-group">
              <div class="input-group-text">
                <input class="form-check-input mt-0" type="checkbox" id="x-axis-check" name="x-axis-check" checked>
              </div>
              <span class="input-group-text">X axis label</span>
              <input type="text" class="form-control" id="x-label" name="x-label" placeholder="Auto">
            </div>
          </div>

          <div class="form-group mb-3" id="y-axis-form-group">
            <div class="input-group">
              <div class="input-group-text">
                <input class="form-check-input mt-0" type="checkbox" id="y-axis-check" name="y-axis-check" checked>
              </div>
              <span class="input-group-text">Y axis label</span>
              <input type="text" class="form-control" id="y-label" name="y-label" placeholder="Auto">
            </div>
          </div>
          
          <!-- X axis display -->
          <div class="form-group mb-3" id="x-axis-display">
            <span>Display system names on</span>
            <div class="form-check">
              <input class="form-check-input" type="radio" name="x-axis-display" id="x-axis-display-x" value="x-axis">
              <label class="form-check-label" for="x-axis-display-x">X axis</label>
            </div>
            <div class="form-check">
              <input class="form-check-input" type="radio" name="x-axis-display" id="x-axis-display-legend" value="legend" checked>
              <label class="form-check-label" for="x-axis-display-legend">Legend</label>
            </div>
          </div>

          <!-- Bar/Dot plot specific: Display gridlines and rotate x labels -->
          <div class="form-group mb-3" id="display-gridlines-form-group">
            <div class="form-check">
              <input class="form-check-input" type="checkbox" id="display-gridlines" name="display-gridlines" checked>
              <label class="form-check-label" for="display-gridlines">Display gridlines</label>
            </div>
          </div>

          <div class="form-group mb-3" id="rotate-x-labels-form-group">
            <div class="form-check">
              <input class="form-check-input" type="checkbox" id="rotate-x-labels" name="rotate-x-labels">
              <label class="form-check-label" for="rotate-x-labels">Rotate X axis labels</label>
            </div>
          </div>

          <!-- Bar chart specific: Display values above bars -->
          <div class="form-group mb-3" id="display-values-above-bars-form-group">
            <div class="form-check">
              <input class="form-check-input" type="checkbox" id="display-values" name="display-values">
              <label class="form-check-label" for="display-values">Display values above bars</label>
            </div>
          </div>

          <!-- Pie chart specific: Display percentages on sectors -->
          <div class="form-group mb-3" id="display-percentages-on-sectors-form-group">
            <div class="form-check">
              <input class="form-check-input" type="checkbox" id="display-percentages" name="display-percentages">
              <label class="form-check-label" for="display-percentages">Display percentages on sectors</label>
            </div>
          </div>

          <!-- Hidden fields -->
          <input type="hidden" id="table-data" name="table-data">
          <input type="hidden" id="systems-data" name="systems-data" value="{{get_variable('jsons')['Systems']}}">
          <input type="hidden" id="test-name" name="test-name">       

          <button type="submit" class="btn btn-primary">Generate charts</button>

        </form>
      </div>

      <div class="col-1 vr"></div>

      <!-- Charts -->
      <div class="col-md">
        <!-- Gallery toolbar -->
        <form>
          <div class="row">

            <!-- Sort by -->
            <div class="col-auto">
              <div class="input-group">
                <label class="input-group-text" for="sort-by">Sort by</label>
                <select class="form-select" id="sort-by" name="sort-by">
                  <option value="date">Last added</option>
                  <option value="test-type">Test type</option>
                  <option value="chart-type">Chart type</option>
                </select>
                <select class="form-select" id="sort-order" name="sort-order">
                  <option value="ascending">Ascending</option>
                  <option value="descending">Descending</option>
                </select>
              </div>
            </div>


            <!-- Test filter -->
            <div class="col-auto">
              <div class="input-group">
                <label class="input-group-text" for="test-name-filter">Test name</label>
                <select class="form-select" id="test-name-filter" name="test-name-filter">
                  <option value="all">Any</option>
                  {% for name in get_variable("jsons").keys() %}
                    {% if name != "Users"  %}
                      <option value="{{name}}">{{name}}</option>
                    {% endif %}
                  {% endfor %}
                </select>
              </div>
            </div>

            <!-- Download current charts -->
            <div class="col-auto">
              <button class="btn btn-primary" id="download-all-button">Download charts (.zip)</button>
            </div>  

            <!-- Delete all charts (spawns a confirmation modal)-->
            <div class="col-auto">
              <button class="btn btn-danger" id="delete-all-button">Delete all charts</button>
            </div>

          </div>
        </form>

        <div id="image-gallery" class="row">

        </div>
      </div>

      <!-- Image modal -->
      <div class="modal fade" id="image-modal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document">
          <div class="modal-content">
            <div class="modal-body align-center">
              <img src="" class="img-fluid w-100">
            </div>
          </div>
        </div>
      </div>

      <!-- Delete all charts modal -->
      <div class="modal fade" id="delete-all-modal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title" id="exampleModalLabel">Delete all charts</h5>
              <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
              Are you sure you want to delete all charts?<br>This action cannot be undone.
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
              <button type="button" class="btn btn-danger" id="delete-all-confirm" onclick="deleteAllCharts()">Proceed</button>
            </div>
          </div>
        </div>
      </div>

    </div>

  </div>  
</div>

<script>
/*
Generates a table from the data in the selected file,
and allows the user to generate charts from the table data and manage those charts.

This script uses server-side generated data to create a table and charts. and can therefore not be separated into another file.
*/

/*** TABLE GENERATION ***/ 
function changeFile() {
  /*
  Change the file displayed in the table
  parameters: none
  returns: none
  */

  // Get the table data from the selected file
  // TODO: Change this to a serverside gen of a list of jsons in here rather than putting the whole json in the <option> 
  var table_data = $('#file-select').val()
  // var table_data = `{{get_variable("jsons")["AB Test"]}}`

  // Change the content of #card-title and the hidden form element test_name
  test_name=$('#file-select option:selected').text()
  
  $('#card-title').text(test_name)
  $('#test-name').val(test_name)

  createTable(table_data)
  
  // Hide/Show Chart generation form if Users or Systems is selected*
  if (test_name === 'Users' || test_name === 'Systems') {
  $('#chart-form').hide()
  $('#charts-row .vr').hide()
  } else {
  $('#chart-form').show()
  $('#charts-row .vr').show()
  updateChartForm()
  }
}

function parse_raw_table(raw_data) {
    /*
    Parses a json string of a SQLAlchemy table into a json object
    parameters: raw_data: string
    returns: data: json object
    */

    data = JSON.parse(raw_data.replaceAll("'",'"'));
    first_element = Object.keys(data)[0]
    return data[first_element]
}

function getColumns(data) {
    /*
    Get the columns from the data and format them for bootstrap-table
    parameters: data: json object
    returns: columns: list of columns in the format needed by bootstrap-table
    */

    columns = Object.keys(data[0])  // Get the columns from the first element of the data

    // Change the columns to the format needed by bootstrap-table
    columns = columns.map(column => {      
    if (column === "intro") {       return {field: column, title: column, sortable: true, filterControl: 'select', filterControlPlaceholder: 'Any'}}
    if (column.includes("user")) {  return {field: column, title: column, sortable: true, filterControl: 'select', filterControlPlaceholder: 'Any'}}
    // if (column.includes("date")) {  return {field: column, title: column, sortable: true, filterControl: 'datepicker', filterDatepickerOptions: {autoclose: true, todayHighlight: true, format: 'yyyy-mm-dd'}}}
    if (column.includes("date")) {  return {field: column, title: column, sortable: true, filterControl: 'input', filterControlPlaceholder: 'yyyy-mm-dd hh:mm:ss'}}
    return {field: column, title: column, sortable: true}
    })

    // Add the state column at the beginning and render it if the export type is selected
    columns.unshift({field: 'state', title: 'state', checkbox: true, visible: getExportType() === 'selected'})

    return columns
}

function getExportType() {
    /*
    Get the export type selected by the user (selected or all)
    parameters: none
    returns: exportType: string
    */

    exportType = $('#toolbar').find('#export-select').val()
    return exportType
}

function createTable(table_data) {
    /*
    Creates a bootstrap-table from a json object and adds it to the table element 
    Reset the table before creating a new one
    parameters: table_data: json object
    returns: none
    */

    data = parse_raw_table(table_data)
    table.bootstrapTable('destroy')
    table.bootstrapTable({
    data:                 data,             // Data source
    columns:              getColumns(data), // Columns
    toolbar:              '#toolbar',       // Toolbar

    // Select
    clickToSelect:        true, // Click to select
    multipleSelectRow:    true, // Select multiple rows

    // Filter & Search & Sort
    filterControl:        true, // Filters on top of the table
    search:               true, // Search bar
    showMultiSort:        true, // Multi-sort

    // Columns dropdown
    showColumns:          true, // Show the columns dropdown button (allows to hide/show columns)
    showColumnsToggleAll: true, // Show a toggle all option in the columns dropdown

    // Card view
    mobileResponsive:     true, // Enable card view for mobile users

    /* Pagination
    TODO: USE height once fixed


    As of now, 2024-06-05, height & filterControl do NOT work together.
    This is a known issue that is being worked on.
    GIT ISSUE: https://github.com/wenzhixin/bootstrap-table/issues/7171
    I will use pagination instead of height for now.*/

    pagination:             true,     // Enable pagination
    paginationVAlign:       'top', // Vertical alignment of the pagination
    paginationHAlign:       'left',   // Horizontal alignment of the pagination
    paginationDetailHAlign: 'right',  // Horizontal alignment of the pagination detail      
    showPaginationSwitch:   true,     // Show the pagination switch
    
    // Export 
    showExport:             true,             // Show the export button
    exportDataType:         getExportType(),  // Export selected or all
    exportTypes: [                            // Export types
        'csv',
        'json',
        'excel',
        'xlsx',
        'doc',
        'pdf',
        'png',
        'sql',
        'txt',
        'xml'
    ],
        
    exportOptions: {                          // Export options           
        fileName: 'results',                    // File name
        htmlContent: true,                      // Export the table as html         
        onCellData: cleanHeaderSelect}          // Clean the header select options for export
    })



    function cleanHeaderSelect(cell, row, col, data) { 
    /*
    Removes the select options from the header title when exporting

    This is done because the select options are not removed when exporting the table.
    Looking like this: "introTrueFalse" instead of just "intro"
    GIT ISSUE: https://github.com/wenzhixin/bootstrap-table/issues/1971

    I applied YousraElh's solution https://jsfiddle.net/YousraElh/b3u7vpsy/
    */
    return row === 0 ? $(cell).attr("data-field") : data; 
    }
}

/*** CHART GENERATION FORM ***/
function updateChartForm() {
    /*
    Update the chart generation form based on the selected test name
    parameters: none
    returns: none              
    */

    updateUserMultiSelect()

    // Hide all form groups
    $('#include-intro-step-form-group').hide()
    $('#user-select-form-group').hide()

    $('#ab-format-choice').hide()
    
    $('#marker-type-form-group').hide()
    $('#x-axis-form-group').hide()
    $('#y-axis-form-group').hide()
    $('#display-gridlines-form-group').hide()
    $('#rotate-x-labels-form-group').hide()
    $('#display-values-above-bars-form-group').hide()
    $('#display-percentages-on-sectors-form-group').hide()

    // Use existing table filters 
    if (!$('#use-existing-table-filters').is(':checked')) { 
    $('#include-intro-step-form-group').show()
    $('#user-select-form-group').show()
    }

    // AB Test type
    if (test_name.includes('AB')) {
    $('#ab-format-choice').show()
    }

    // Dot Plot Chart type
    if (test_name.includes('MOS') || test_name.includes('MUSHRA')) {
    $('#marker-type-form-group').show()
    $('#x-axis-form-group').show()
    $('#y-axis-form-group').show()
    $('#display-gridlines-form-group').show()
    
    // Dot Plot Chart type + x-axis-display-x checked 
    if ($('#x-axis-display-x').is(':checked')) {
        $('#rotate-x-labels-form-group').show()
    }
    }

    // Bar Chart Chart type
    if (test_name.includes('AB') && $('#ab-format-bar').is(':checked')) {
      $('#x-axis-form-group').show()
      $('#y-axis-form-group').show()
      $('#display-gridlines-form-group').show()
      $('#display-values-above-bars-form-group').show()
    }

    // Pie Chart Chart type
    if (test_name.includes('AB') && $('#ab-format-pie').is(':checked')) {
    $('#display-percentages-on-sectors-form-group').show()
    }
}

function submitChartForm() {
  /*
  Submit the chart form
  parameters: none
  returns: none
  */

  if (!$('#use-existing-table-filters').is(':checked')) {
    var tableData = $('#table').bootstrapTable('getData');
    
    intro_step = $('#include-intro-step').is(':checked');
    users = $('#user-select').val();

    if (!intro_step) {
        tableData = tableData.filter(function(row) {
        return row.intro == 'False';
        });
    }

    if (users.length > 0) {
        tableData = tableData.filter(function(row) {
        return users.includes(row.user_id) || users.includes(row.user_pseudo);
        });
    }
  } else {
    // If there is a selection, get the selections rather than the whole table
    var tableData = $('#table').bootstrapTable('getSelections');
    if (tableData.length === 0) {
        tableData = $('#table').bootstrapTable('getData');
        console.log('No selection, using all data');
    }
  }
  data = JSON.stringify(tableData);
  $('#table-data').val(data);
}

function updateUserMultiSelect() {
    /*
    Add the users to the multi select element
    parameters: none
    returns: none
    */

    var users = [];
    users = [...new Set($('#table').bootstrapTable('getData').map(function(row) {
    // Check if user_id or user_pseudo is used (is a column in the table)
    return row.user_id ? row.user_id : row.user_pseudo;
    }))];

    $('#user-select').empty();

    users.forEach(function(user) {
    $('#user-select').append('<option value="' + user + '" selected>' + user + '</option>');
    });
}

/*** IMAGE GALLERY ***/
function downloadCharts() {
    /*
    Download all the charts as a zip file
    parameters: none
    returns: none
    */
    event.preventDefault();
    var zip = new JSZip();
    var images = document.querySelectorAll('.chart-img');
    var fetchPromises = Array.from(images).map(function(image) {
    var src = image.src;
    var filename = src.split('/').pop();
    return fetch(src).then(function(response) {
        return response.blob().then(function(blob) {
        zip.file(filename, blob);
        });
    });
    });
    Promise.all(fetchPromises).then(function() {
    zip.generateAsync({type: 'blob'}).then(function(content) {
        saveAs(content, 'charts.zip');
    });
    });
}

function deleteAllCharts() {
    /*
    Delete all the charts
    parameters: none
    returns: none
    */

    $.post('./delete_all_charts', function() {
    $('#image-gallery').empty();
    });
    // Close modal
    $('#delete-all-modal').modal('hide');
}

function deleteImage(src) {
    /*
    Delete an image
    parameters: src: string
    returns: function (event) 
    */

    return function(event) {
    /*
    Delete the image from the server and remove the card from the gallery
    parameters: event: event
    returns: none
    */
    event.preventDefault();
    $.post('./delete_image', {src: src}, function() {
        // Remove the card from the gallery
        var card = event.target.closest('.container');
        card.remove();
    });
    }
}

function createCard(src, image) {
    /*
    Create a card element for an image
    parameters: src: string, image: json object
    returns: card: html element
    */
    
    var card = document.createElement('div');
    card.className = 'container';

    var cardInner = document.createElement('div');
    cardInner.className = 'card';

    var img = document.createElement('img');
    img.src = '{{get_asset("'+src+'")}}';
    img.className = 'card-img-top chart-img';
    img.alt = 'chart';

    var cardBody = document.createElement('div');
    cardBody.className = 'card-body';

    var table = document.createElement('table');
    table.className = 'card-text table table-sm';

    var tbody = document.createElement('tbody');

    // Date
    var dateRow = document.createElement('tr');
    var dateTh = document.createElement('th');
    dateTh.scope = 'row';
    dateTh.textContent = 'Date';
    var dateTd = document.createElement('td');
    dateTd.textContent = image.date;
    dateRow.appendChild(dateTh);
    dateRow.appendChild(dateTd);

    // Time
    var timeRow = document.createElement('tr');
    var timeTh = document.createElement('th');
    timeTh.scope = 'row';
    timeTh.textContent = 'Time';
    var timeTd = document.createElement('td');
    timeTd.textContent = image.time;
    timeRow.appendChild(timeTh);
    timeRow.appendChild(timeTd);

    // Test type
    var testTypeRow = document.createElement('tr');
    var testTypeTh = document.createElement('th');
    testTypeTh.scope = 'row';
    testTypeTh.textContent = 'Test type';
    var testTypeTd = document.createElement('td');
    testTypeTd.textContent = image.test_type;
    testTypeRow.appendChild(testTypeTh);
    testTypeRow.appendChild(testTypeTd);

    // Chart type
    var chartTypeRow = document.createElement('tr');
    var chartTypeTh = document.createElement('th');
    chartTypeTh.scope = 'row';
    chartTypeTh.textContent = 'Chart type';
    var chartTypeTd = document.createElement('td');
    chartTypeTd.textContent = image.chart_type;
    chartTypeRow.appendChild(chartTypeTh);
    chartTypeRow.appendChild(chartTypeTd);

    // Test name
    var testNameRow = document.createElement('tr');
    var testNameTh = document.createElement('th');
    testNameTh.scope = 'row';
    testNameTh.textContent = 'Test name';
    var testNameTd = document.createElement('td');
    testNameTd.textContent = image.test_name;
    testNameRow.appendChild(testNameTh);
    testNameRow.appendChild(testNameTd);
    
    // Add the rows to the table
    tbody.appendChild(testNameRow);
    tbody.appendChild(testTypeRow);
    tbody.appendChild(dateRow);
    tbody.appendChild(timeRow);
    tbody.appendChild(chartTypeRow);
    table.appendChild(tbody);

    var downloadLink = document.createElement('a');
    downloadLink.href = img.src;
    downloadLink.className = 'btn btn-primary btn-download';
    downloadLink.download = '';

    var downloadImg = document.createElement('i');
    downloadImg.className = 'bi bi-download';

    downloadLink.appendChild(downloadImg);

    var deleteLink = document.createElement('a');
    deleteLink.href = '';
    deleteLink.className = 'btn btn-danger delete-image';
    // Add an event listener to the delete link
    deleteLink.addEventListener('click', deleteImage(src));

    var deleteImg = document.createElement('i');
    deleteImg.className = 'bi bi-trash';

    deleteLink.appendChild(deleteImg);

    cardBody.appendChild(table);
    cardBody.appendChild(downloadLink);
    cardBody.appendChild(deleteLink);

    cardInner.appendChild(img);
    cardInner.appendChild(cardBody);

    card.appendChild(cardInner);
    return card;
}

function updateGallery() {
    // Get the current values of the form elements
    var sortByValue = sortBy.val();
    var sortOrderValue = sortOrder.val()
    var testNameValue = testName.val();

    // Filter the images based on the form values
    var filteredImages = Object.entries(images).filter(function([key, image]) {
        return image.test_name === testNameValue || testNameValue === 'all';
    }).reduce(function(obj, [key, value]) {
        obj[key] = value;
        return obj;
    }, {});

    // Sort the images based on the form values
    // If the sort order is descending, reverse the order of the sorted images
    // when the sort by value is date, sort by the date and time
    var sortedImages = Object.entries(filteredImages).sort(function([aSrc, aImage], [bSrc, bImage]) {
        if (sortByValue === 'date') {
        var aDate = new Date(aImage.date + ' ' + aImage.time);
        var bDate = new Date(bImage.date + ' ' + bImage.time);
        return sortOrderValue === 'ascending' ? bDate - aDate : aDate - bDate;
        } else if (sortByValue === 'test-type') {
        return sortOrderValue === 'ascending' ? aImage.test_type.localeCompare(bImage.test_type) : bImage.test_type.localeCompare(aImage.test_type);
        } else if (sortByValue === 'chart-type') {
        return sortOrderValue === 'ascending' ? aImage.chart_type.localeCompare(bImage.chart_type) : bImage.chart_type.localeCompare(aImage.chart_type);
        }
    }).reduce(function(obj, [key, value]) {
        obj[key] = value;
        return obj;
    }, {});

    // Clear the current gallery
    $('#image-gallery').empty();

    // Create and append new cards for the filtered and sorted images
    Object.entries(sortedImages).forEach(function([src, image]) {
        var card = createCard(src, image);
        $('#image-gallery').append(card);
    });

    // If there are no images, disable the download button
    if (Object.keys(sortedImages).length === 0) {
        $('#image-gallery').append('<p>No charts found</p>');
        $('#download-all-button').prop('disabled', true);
        $('#delete-all-button').prop('disabled', true);
    } else {
        $('#download-all-button').prop('disabled', false);
        $('#delete-all-button').prop('disabled', false);
    }

    // Open image in modal
    $('.chart-img').click(function() {
        var src = $(this).attr('src');
        $('#image-modal img').attr('src', src);
        $('#image-modal').modal('show');
    });

    // Add an event listener to the delete all button to spawn the delete all modal
    $('#delete-all-button').on('click', function() {
        event.preventDefault();
        $('#delete-all-modal').modal('show');
    });
}

/*** Event listeners ***/
var table = $('#table')
var sortBy    = $('#sort-by');
var sortOrder = $('#sort-order');
var testName  = $('#test-name-filter');

// Get the images from the server as a json object and parse it
images = JSON.parse('{{get_variable("images_dict")}}')

// Add an event listener to the form elements
sortBy.on('change', updateGallery);
sortOrder.on('change', updateGallery);
testName.on('change', updateGallery);

$('#gen-charts-form').on('submit',  submitChartForm);
$('#use-existing-table-filters').on('change', updateUserMultiSelect);
    
// Export select & file select event listeners
$('#export-select').on('change', changeFile);
$('#file-select').on('change', changeFile);

// Add event listeners to the form elements
$('#ab-format-choice input').on('change', updateChartForm);
$('#x-axis-display').on('change', updateChartForm);
$('#use-existing-table-filters').on('change', updateChartForm);

// Add an event listener to the checkbox to enable/disable the x and y axis inputs
$('#x-axis-check').on('change', function() {
    $('#x-label').prop('disabled', !this.checked);
    if (!this.checked) {
    $('#x-label').attr('placeholder', 'None');
    } else {
    $('#x-label').attr('placeholder', 'Auto');
    }
});

$('#y-axis-check').on('change', function() {
    $('#y-label').prop('disabled', !this.checked);
    if (!this.checked) {
    $('#y-label').attr('placeholder', 'None');
    } else {
    $('#y-label').attr('placeholder', 'Auto');
    }
});

// Add an event listener to the user select to disable the submit button if no users are selected and the select form group is visible
$('#user-select, #use-existing-table-filters').on('change', function() {
    var submitButton = $('#gen-charts-form button[type="submit"]');
    if ($('#user-select-form-group').is(':visible')) {
    submitButton.prop('disabled', $('#user-select').val().length === 0);
    } else {
    submitButton.prop('disabled', false);
    }
});

// Download all charts button
$('#download-all-button').on('click', downloadCharts);

/*** Initialisation ***/
changeFile()
updateGallery();

</script>

{% endblock %}
