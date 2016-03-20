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

        renderWidget(
          $(widget).find("#widgets_entity_id").val(),
          $(widget).attr('widget-id'),
          $(widget).find("#widgets_x_axis").val(),
          $(widget).find("#widgets_y_axis").val(),
          $(widget).find("#widgets_y_axis_as").val(),
          $(widget).find("#widgets_x_axis_group").val(),
          $(widget).find("#widgets_limits").val(),
          $(widget)
        );
      }
    }
  });
}

function renderWidget(report_id, widget_id, x, y, y_as, x_group, limit, widget) {
  widget.find('.box-content').prepend('<img src="/assets/spinner-big.gif" />');

  $.ajax({
    url: "/reports/" + report_id + "/display",
    method: 'post',
    data: {
      widget_id: widget_id,
      columns: {
        x_axis: x,
        y_axis: y,
        y_axis_as: y_as,
        x_axis_group: x_group
      },
      limit: limit
    }
  }).done(function(data) {
    widget.find('.box-content').html(data);
  });
}

function boxContent(type, has_image = true) {
  var box =
    '<div class="box">' +
      '<div class="box-header">' +
        '<h3>New Widget</h3>' +
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

function changeWidgetSettings(widget) {
  var w = widget.parent().parent().parent().parent();

  if (w.attr('widget-id') > 1) {
    $('#columns-options').show();
  } else {
    $('#columns-options').hide();
  }

  $.get('/dashboards/widget_settings', function() {
    $('#report_id, #refresh_time, #limits').find('option').remove();
  }).done(function(data) {
    var first_report_id = 0;

    $.each(data.reports, function(id, report) {
      $('#report_id').append($('<option>', {
        value: report.id,
        text : report.name
      }));

      if (first_report_id === 0) {
        loadReportColumns(report.id);
        loadReportLastValues(report.id);
        first_report_id = report.id;

        $('#name').val(report.name);
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
  }).fail(function() {
  });

  $("#widget-settings").dialog({
    modal: true,
    width: 800,
    height: 500,
    buttons: {
      Ok: function() {
        appendWidgetParameters(widget);

        $(this).dialog("close");
      },
      Cancel: function() {
        $(this).dialog("close");
      }
    }
  });
}

function loadReportColumns(report_id) {
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
  });
}

function loadReportLastValues(report_id) {
  $('#last-values').html();

  $.ajax({
    url: '/reports/' + report_id + '/last_value',
    method: 'get'
  }).success(function(data) {
    $('#last-values').text(data);
  });
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
  set.append('<input type="hidden" name="widgets[][refresh_time]" value="' + $('#refresh_time').val() + '" />');
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

  renderWidget(
    $('#report_id').val(),
    obj.attr('widget-id'),
    $('#x_axis').val(),
    $('#y_axis').val(),
    $('#y_axis_as').val(),
    $('#x_axis_group').val(),
    $('#limits').val(),
    obj
  );
}

$(function() {
  gridster = $(".gridster ul").gridster({
    min_cols: 2,
    helper: 'clone',
    resize: {
      enabled: true,
      stop: function(e, ui, $widget) {
        if ($widget.attr("widget-type") !== "table" && $widget.find("#settings").length) {
          $widget.find('.box-content').html("");

          renderWidget(
            $widget.find("#widgets_entity_id").val(),
            $widget.attr('widget-id'),
            $widget.find("#widgets_x_axis").val(),
            $widget.find("#widgets_y_axis").val(),
            $widget.find("#widgets_y_axis_as").val(),
            $widget.find("#widgets_x_axis_group").val(),
            $widget.find("#widgets_limits").val(),
            $widget
          );
        }
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
