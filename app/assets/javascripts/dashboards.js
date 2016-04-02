var gridster;

setInterval("updateCharts()", 10000);

function updateCharts() {
  var widgets_times = $('input:hidden[name="refresh-at"]');
  var current = new Date();

  widgets_times.each(function() {
    var next_call = $(this).val();

    if (next_call) {
      if (parseInt(current.getTime()) >= parseInt(next_call)) {
        var widget = $(this).parent().parent().parent();
        var entity_id = $(widget).find('input:hidden[name="widgets[][entity_id]"]');
        var periods = $(widget).find('input:hidden[name="widgets[][refresh_time]"]');
        var period = $(periods[0]).val();

        $(widget).find('input:hidden[name="refresh-at"]').val(parseInt(current.getTime()) + parseInt(period) * 60000);

        var settings = {
          entity_id: $(widget).find("#widgets_entity_id").val(),
          widget_id: $(widget).attr('widget-id'),
          x_axis: $(widget).find("#widgets_x_axis").val(),
          y_axis: $(widget).find("#widgets_y_axis").val(),
          y_axis_as: $(widget).find("#widgets_y_axis_as").val(),
          x_axis_group: $(widget).find("#widgets_x_axis_group").val(),
          limits:  $(widget).find("#widgets_limits").val(),
        };

        renderWidget($(widget), settings);
      }
    }
  });
}

function renderWidget(widget, settings) {
  widget.find('.box-content').html('');
  widget.find('.box-content').prepend('<img class="widget_spinner" src="/assets/spinner-big.gif" />');

  $.ajax({
    url: "/reports/" + settings.entity_id + "/display",
    method: 'post',
    data: {
      widget_id: settings.widget_id,
      columns: {
        x_axis: settings.x_axis,
        y_axis: settings.y_axis,
        y_axis_as: settings.y_axis_as,
        x_axis_group: settings.x_axis_group
      },
      limits: settings.limits
    }
  }).done(function(data) {
    widget.find('.box-content').html(data);
  });
}

function boxContent(type, has_image, name) {
  var has_image = typeof has_image !== 'undefined' ? has_image : true;
  var name = typeof name !== 'undefined' ? name : 'New Widget';

  var box =
    '<div class="box">' +
      '<div class="box-header">' +
        '<h3>' + name + '</h3>' +
        '<div class="box-header-btns pull-right">' +
          '<a href="#" title="Remove Widget" onclick="removeWidget($(this))">' +
            '<i class="pull-right ui-icon ui-icon-closethick"></i>' +
          '</a>' +
          '<a href="#" title="Change Settings" onclick="changeWidgetSettings($(this))">' +
            '<i class="pull-right ui-icon ui-icon-wrench"></i>' +
          '</a>' +
          '<a href="#" title="">' +
            '<i class="pull-right ui-icon ui-icon-refresh"></i>' +
          '</a>' +
        '</div>' +
        '<input type="hidden" name="refresh-at" value="" />' +
      '</div>' +
      '<div class="box-content">';

  if (has_image) {
    box +='<img alt="' + type + '" src="/assets/' + type + '_big.png" class="preview-image">';
  }

  box += '</div>' +
    '</div>';

  return box;
}

function removeWidget(widget) {
  gridster.remove_widget(widget.parent().parent().parent().parent());
}

function loadName(widget) {
  if (widget.find('input#widgets_name').length)
    return widget.find('input#widgets_name').val();
  else
    return "";
}

function loadReport(widget) {
  if (widget.find('input#widgets_entity_id').length)
    return widget.find('input#widgets_entity_id').val();
  else
    return "";
}

function loadRefreshTime(widget) {
  if (widget.find('input#widgets_refresh_time').length)
    return widget.find('input#widgets_refresh_time').val();
  else
    return "";
}

function loadLimits(widget) {
  if (widget.find('input#widgets_limits').length)
    return widget.find('input#widgets_limits').val();
  else
    return "";
}

function loadXAxis(widget) {
  if (widget.find('input#widgets_x_axis').length)
    return widget.find('input#widgets_x_axis').val();
  else
    return "";
}

function loadYAxis(widget) {
  if (widget.find('input#widgets_y_axis').length)
    return widget.find('input#widgets_y_axis').val();
  else
    return "";
}

function loadYAxisAs(widget) {
  if (widget.find('input#widgets_y_axis_as').length)
    return widget.find('input#widgets_y_axis_as').val();
  else
    return "";
}

function loadXAxisGroup(widget) {
  if (widget.find('input#widgets_x_axis_group').length)
    return widget.find('input#widgets_x_axis_group').val();
  else
    return "";
}

function changeWidgetSettings(widget) {
  var obj = widget.parent().parent().parent().parent();

  if (obj.attr('widget-id') > 1) {
    $('#columns-options').show();
  } else {
    $('#columns-options').hide();
  }
  $('#error-message li').remove();

  $.get('/dashboards/widget_settings', function() {
    $('#report_id, #refresh_time, #limits').find('option').remove();
  }).done(function(data) {
    var firstTimeUse = true;

    var has_settings = false;
    if (obj.find('div#settings').length) {
      has_settings = true;
    }

    $.each(data.reports, function(id, report) {
      $('#report_id').append($('<option>', {
        value: report.id,
        text : report.name
      }));

      if (firstTimeUse) {
        loadReportColumns(report.id, loadXAxis(obj), loadYAxis(obj), loadYAxisAs(obj), loadXAxisGroup(obj));
        loadReportLastValues(report.id);
        firstTimeUse = false;

        $('#name').val(report.name);

        if (loadYAxisAs(obj) == "") {
          $("#y_axis_as").val($("#y_axis_as option:first").val());
          $("#x_axis_group").val($("#x_axis_group option:first").val());
          $("#group-options").hide();
        } else {
          $("#group-options").show();
        }
      }
    });

    $.each(data.refresh_time, function(id, time) {
      $('#refresh_time').append($('<option>', {
        value: time,
        text : time
      }));
    });

    $.each(data.limits, function(id, limit) {
      $('#limits').append($('<option>', {
        value: limit,
        text : limit
      }));
    });

    if (has_settings) {
      $("#name").val(loadName(obj));
      $("select#report_id").val(loadReport(obj));
      $("select#refresh_time").val(loadRefreshTime(obj));
      $("select#limits").val(loadLimits(obj));
    }
  }).fail(function() {
  });

  $("#widget-settings").dialog({
    modal: true,
    width: 800,
    height: 500,
    buttons: {
      Ok: function() {
        if (validInputParameters(widget)) {
          appendWidgetParameters(widget);

          $(this).dialog("close");
        }
      },
      Cancel: function() {
        $(this).dialog("close");
      }
    }
  });

  function validInputParameters(widget) {
    var validated = true;
    var msg = '';
    $('#error-message li').remove();
    var obj = widget.parent().parent().parent().parent();

    if (!$('#name').val()) {
      msg = 'Name cannot be blank';
      $('#error-message').append('<li>' + msg + '</li>');
    }

    if (!$('#report_id option:selected').text()) {
      msg = 'Report Name value cannot be blank';
      $('#error-message').append('<li>' + msg + '</li>');
    }

    if (!$('#refresh_time option:selected').text()) {
      msg = 'Refresh Time value cannot be blank';
      $('#error-message').append('<li>' + msg + '</li>');
    }

    if (!$('#limits option:selected').text()) {
      msg = 'Limit value cannot be blank';
      $('#error-message').append('<li>' + msg + '</li>');
    }

    var items = JSON.parse($('#last-values').text());
    var group_visible = $('#x_axis_group').is(':visible');

    if ($('#x_axis').is(':visible')) {
      if (!$('#x_axis option:selected').text()) {
        msg = 'X Axis value cannot be blank';
        $('#error-message').append('<li>' + msg + '</li>');
      }

      if (group_visible) {
        if (defineCast(items[$('#x_axis option:selected').text()]) != 'Timestamp') {
          msg = 'X Axis cast should be Timestamp with active GROUP BY option';
          $('#error-message').append('<li>' + msg + '</li>');
        }
      } else {
        if (obj.attr('widget-id') == 2 || obj.attr('widget-id') == 3) {
          if (defineCast(items[$('#x_axis option:selected').text()]) != 'Timestamp') {
            msg = 'X Axis column cast should be Timestamp';
            $('#error-message').append('<li>' + msg + '</li>');
          }
        }
      }
    }

    if ($('#y_axis').is(':visible')) {
      if (!$('#y_axis option:selected').text()) {
        msg = 'Y Axis value cannot be blank';
        $('#error-message').append('<li>' + msg + '</li>');
      }

      if (group_visible) {
      } else {
        var definedCast = defineCast(items[$('#y_axis option:selected').text()]);
        if (definedCast != 'Integer' && definedCast != 'Float') {
          msg = 'Y Axis column cast should be Integer or Float';
          $('#error-message').append('<li>' + msg + '</li>');
        }
      }
    }

    if ($('#y_axis_as option:selected').text() == 'SUM') {
      var definedCast = defineCast(items[$('#y_axis option:selected').text()]);
      if (definedCast != 'Integer' && definedCast != 'Float') {
        msg = 'Y Axis As value cannot SUM non numeric values';
        $('#error-message').append('<li>' + msg + '</li>');
      }
    }

    if ($('#x_axis_group').is(':visible')) {
      if (!$('#x_axis_group option:selected').text()) {
         msg = 'X Axis Group value cannot be blank';
         $('#error-message').append('<li>' + msg + '</li>');
      }
    }

    if (msg) {
      validated = false;
    }

    return validated;
  }
}

function loadReportColumns(report_id, x_axis_default, y_axis_default, y_axis_as_default, x_axis_group_default) {
  $('#x_axis, #y_axis').find('option').remove();

  $.ajax({
    url: '/reports/' + report_id + '/columns',
    method: 'get'
  }).success(function(data) {
    $.each(data, function(idx, column) {
      $('#x_axis, #y_axis').append($('<option>', {
        value: column,
        text : column
      }));
    });

    x_axis_default = typeof x_axis_default !== 'undefined' ? x_axis_default : false;
    y_axis_default = typeof y_axis_default !== 'undefined' ? y_axis_default : false;
    x_axis_as_default = typeof x_axis_as_default !== 'undefined' ? x_axis_as_default : false;
    y_axis_group_default = typeof y_axis_group_default !== 'undefined' ? y_axis_group_default : false;

    if (x_axis_default)
      $("select#x_axis").val(x_axis_default);
    if (y_axis_default)
      $("select#y_axis").val(y_axis_default);
    if (y_axis_as_default)
      $("select#y_axis_as").val(y_axis_as_default);
    if (x_axis_group_default)
      $("select#x_axis_group").val(x_axis_group_default);
  });
}

function loadReportLastValues(report_id) {
  $('#last-values-structured tr').remove();
  $('#last-values').html();

  $.ajax({
    url: '/reports/' + report_id + '/last_value',
    method: 'get'
  }).success(function(data) {
    $('#last-values').text(JSON.stringify(data));

    $.each(data, function(column, value) {
      $('#last-values-structured').append('<tr><td>&nbsp;' + column + '&nbsp;</td><td>&nbsp;' + value + '&nbsp;</td><td>&nbsp;' + defineCast(value) + '&nbsp;</td></tr>');
    });
  });
}

function defineCast(value) {
  var integer = /^[+-]?\d+$/;
  var float = /^[+-]?\d+\.\d*$/;
  var date = Date.parse(value);

  if (integer.test(value)) {
    return 'Integer';
  } else if (float.test(value)) {
    return 'Float';
  } else {
    var type = 'String';
    if (!isNaN(date)) {
      var num_items = value.split(/[^0-9]/);
      num_items = num_items.filter(function(e){return e});
//      var str_items = value.split(/[^a-zA-Z]/);
//      str_items = str_items.filter(function(e){return e});

      if ($.inArray(new Date(date).getDate(), num_items) && num_items.length >= 2) {
        type = 'Timestamp';
      }
    }

    return type;
  }
}

function appendWidgetParameters(widget) {
  var current = new Date();
  var obj = widget.parent().parent().parent().parent();

  obj.find('#settings').remove();

  obj.append('<div id="settings"></div>');
  var set = obj.find('#settings');

  set.append('<input type="hidden" id="widgets_name" name="widgets[][name]" value="' + $('#name').val() + '" />');
  set.append('<input type="hidden" id="widgets_entity_id" name="widgets[][entity_id]" value="' + $('#report_id').val() + '" />');
  set.append('<input type="hidden" name="widgets[][entity_type]" value="reports" />');
  set.append('<input type="hidden" id="widgets_refresh_time" name="widgets[][refresh_time]" value="' + $('#refresh_time').val() + '" />');
  set.append('<input type="hidden" id="widgets_limits" name="widgets[][limits]" value="' + $('#limits').val() + '" />');
  set.append('<input type="hidden" name="widgets[][widget_id]" value="' + obj.attr('widget-id') + '" />');
  set.append('<input type="hidden" name="widgets[][top]" value="' + obj.attr('data-row') + '" />');
  set.append('<input type="hidden" name="widgets[][left]" value="' + obj.attr('data-col') + '" />');
  set.append('<input type="hidden" name="widgets[][width]" value="' + obj.attr('data-sizex') + '" />');
  set.append('<input type="hidden" name="widgets[][height]" value="' + obj.attr('data-sizey') + '" />');

  set.append('<input type="hidden" id="widgets_x_axis" name="widgets[][x_axis]" value="' + $('#x_axis').val() + '" />');
  set.append('<input type="hidden" id="widgets_y_axis" name="widgets[][y_axis]" value="' + $('#y_axis').val() + '" />');
  set.append('<input type="hidden" id="widgets_y_axis_as" name="widgets[][y_axis_as]" value="' + $('#y_axis_as').val() + '" />');
  set.append('<input type="hidden" id="widgets_x_axis_group" name="widgets[][x_axis_group]" value="' + $('#x_axis_group').val() + '" />');

  if ($('#refresh_time').val() != 'NO') {
    set.parent().find('input:hidden[name="refresh-at"]').val(current.getTime() + $('#refresh_time').val() * 60000);
  }

  obj.find('.preview-image').remove();
  $('#last_call_widget_settings_position_id').val(obj.attr("position-id"));
  obj.find('.box-header h3').text($('#name').val());

  var settings = {
    entity_id: $('#report_id').val(), 
    widget_id: obj.attr('widget-id'), 
    x_axis: $('#x_axis').val(), 
    y_axis: $('#y_axis').val(), 
    y_axis_as: $('#y_axis_as').val(), 
    x_axis_group: $('#x_axis_group').val(), 
    limits:  $('#limits').val()
  };

  renderWidget(obj, settings);
}

function addParameters(obj, widget) {
  var current = new Date();

  obj.append('<div id="settings"></div>');
  var set = obj.find('#settings');

  set.append('<input type="hidden" id="widgets_name" name="widgets[][name]" value="' + widget.name + '" />');
  set.append('<input type="hidden" id="widgets_entity_id" name="widgets[][entity_id]" value="' + widget.entity_id + '" />');
  set.append('<input type="hidden" name="widgets[][entity_type]" value="reports" />');
  if (widget.refresh_time == 0)
    set.append('<input type="hidden" id="widgets_refresh_time" name="widgets[][refresh_time]" value="NO" />');
  else
    set.append('<input type="hidden" id="widgets_refresh_time" name="widgets[][refresh_time]" value="' + widget.refresh_time + '" />');
  if (widget.limits == 0)
    set.append('<input type="hidden" id="widgets_limits" name="widgets[][limits]" value="NO" />');
  else
    set.append('<input type="hidden" id="widgets_limits" name="widgets[][limits]" value="' + widget.limits + '" />');
  set.append('<input type="hidden" name="widgets[][widget_id]" value="' + widget.widget_id + '" />');
  set.append('<input type="hidden" name="widgets[][top]" value="' + widget.top + '" />');
  set.append('<input type="hidden" name="widgets[][left]" value="' + widget.left + '" />');
  set.append('<input type="hidden" name="widgets[][width]" value="' + widget.width + '" />');
  set.append('<input type="hidden" name="widgets[][height]" value="' + widget.height + '" />');

  set.append('<input type="hidden" id="widgets_x_axis" name="widgets[][x_axis]" value="' + widget.x_axis + '" />');
  set.append('<input type="hidden" id="widgets_y_axis" name="widgets[][y_axis]" value="' + widget.y_axis + '" />');
  set.append('<input type="hidden" id="widgets_y_axis_as" name="widgets[][y_axis_as]" value="' + widget.y_axis_as + '" />');
  set.append('<input type="hidden" id="widgets_x_axis_group" name="widgets[][x_axis_group]" value="' + widget.x_axis_group + '" />');

  if (widget.refresh_time != 0) {
    set.parent().find('input:hidden[name="refresh-at"]').val(current.getTime() + widget.refresh_time * 60000);
  }
}

function rerangeWidgetsSizes() {
  $.each($('#dashboard ul li'), function(index, widget) {
    $(widget).find('input[name="widgets[][left]"]').val($(widget).attr('data-col'));
    $(widget).find('input[name="widgets[][top]"]').val($(widget).attr('data-row'));
    $(widget).find('input[name="widgets[][width]"]').val($(widget).attr('data-sizex'));
    $(widget).find('input[name="widgets[][height]"]').val($(widget).attr('data-sizey'));
  });
}

$(function() {
  gridster = $(".gridster ul").gridster({
    min_cols: 2,
    helper: 'clone',
    resize: {
      enabled: true,
      stop: function(e, ui, $widget) {
        rerangeWidgetsSizes();

        if ($widget.attr("widget-type") !== "table" && $widget.find("#settings").length) {
          $widget.find('.box-content').html("");

          var settings = {
            entity_id: $widget.find("#widgets_entity_id").val(),
            widget_id: $widget.attr('widget-id'),
            x_axis: $widget.find("#widgets_x_axis").val(),
            y_axis: $widget.find("#widgets_y_axis").val(),
            y_axis_as: $widget.find("#widgets_y_axis_as").val(),
            x_axis_group: $widget.find("#widgets_x_axis_group").val(),
            limits:  $widget.find("#widgets_limits").val(),
          };

          renderWidget($widget, settings);
        }
      }
    },
    draggable: {
      stop: function() {
        rerangeWidgetsSizes();
      }
    }
  }).data('gridster');

  var $dashboard = $("#dashboard");

  $dashboard.droppable({
    accept: "#widgets > li",
    activeClass: "ui-state-highlight",
    drop: function(event, ui) {
      appendWidget(ui.draggable, ui.draggable.parent().attr("id"));
    }
  });

  $('#report_id').change(function() {
    loadReportColumns($(this).val());
    loadReportLastValues($(this).val());
  });

  function appendWidget($item, $type) {
    var li_count = $("ul li", $dashboard).length;
    var widget_id = $item.attr('widget-id');
    var widget_type = $item.attr('widget-type');

    var box = boxContent(widget_type);

    gridster.add_widget.apply(gridster, ['<li widget-id="' + widget_id + '" position-id="' + li_count + '" widget-type="' + widget_type + '">' + box + '</li>', 1, 1])
  }
});

