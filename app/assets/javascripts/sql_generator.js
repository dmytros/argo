function generateSQL() {
  var tables = [];
  var columns = [];
  var conditions = [];
  var groups = [];
  var orders = [];
  
  $("tr.field").each(function() {
    // table names
    var table = $(this).find("input[name='field_table']").val();
    tables.push(table);
    
    // column names
    var column = $(this).find("input[name='field_column']").val();
    var full_name = table + '.' + column;
    
    if ($(this).find("input[name='field_select']").is(':checked')) {
      var as = $(this).find("input[name='field_as']").val();
      
      var full_name_as = full_name;
      if (!empty(as))
        full_name_as = full_name + ' AS ' + as;
      
      columns.push(full_name_as);
    }
    
    // conditions
    var condition = $(this).find("select[name='field_condition'] option:selected").val();
    if (!empty(condition)) {
      var value = $(this).find("input[name='field_condition_values']").val();
      if ($(this).find("input[name='field_use_in_range']").is(':checked') && condition === "date_between") {
        value = [value, $(this).find("input[name='field_condition_values_range']").val()];
      }

      conditions.push([full_name, condition, value]);
    }

    // in group by
    if ($(this).find("input[name='field_group']").is(':checked'))
      groups.push(full_name);
    
    // in order by
    if ($(this).find("input[name='field_order']").is(':checked')) {
      var order = $(this).find("select[name='field_order_values'] option:selected").val();
      var full_name_order = [full_name, order.toUpperCase()].join(' ');
      
      orders.push(full_name_order);
    }
  });
  
  var timestamp = $('#ranges_column option:selected').val();
  var timestamp_condition = $('#ranges option:selected').val();
  
  tables = tables.filter(unique);
  
  var SQL = '';
  if (columns.length > 0 && tables.length > 0) {
    SQL += generateSelect(columns);
    SQL += generateFrom(tables);
    
    if (conditions.length > 0 || '0' !== timestamp_condition)
      SQL += generateWhere(conditions, [timestamp, timestamp_condition]);
    if (groups.length > 0)
      SQL += generateGroup(groups);
    if (orders.length > 0)
      SQL += generateOrder(orders);
    
    SQL += generateLimit();
  }
  
  $('#preview_sql').val(SQL);
}

function updateTimestamps() {
  var timestamps = [];

  $('#ranges_column').find('option').remove();

  $("tr.field").each(function() {
    var table = $(this).find("input[name='field_table']").val();
    var column = $(this).find("input[name='field_column']").val();

    var full_name = table + '.' + column;
    
    var type = $(this).find("input[name='field_type']").val();
    if ('timestamp' === type) {
      timestamps.push(full_name);
      
      $('#ranges_column').append($("<option></option>").attr("value", full_name).text(full_name));
    }
  });
}

function generateLimit() {
  var limit = $('#limits option:selected').val();

  var str = '';
  if ('NO' !== limit)
    str = ' LIMIT ' + limit;

  return str;
}

function generateSelect(columns) {
  var str = 'SELECT ';

  str += columns.join(', ');

  return str;
}

function generateFrom(tables) {
  var str = ' FROM ';

  str += tables.join(', ');

  return str;
}

function generateGroup(groups) {
  var str = ' GROUP BY ';

  str += groups.join(', ');

  return str;
}

function generateOrder(orders) {
  var str = ' ORDER BY ';

  str += orders.join(', ');

  return str;
}

function generateWhere(conditions, timestamp) {
  var str = ' WHERE ';

  var replaced = [];
  for (i = 0; i < conditions.length; i++) {
    replaced.push(replaceCondition(conditions[i]));
  }
  
  if (timestamp[1] !== "0")
    replaced.push(replaceTimestamp(timestamp));
  
  str += replaced.join(' AND ');

  return str;
}

function replaceTimestamp(condition) {
  var str = "";

  if ('1' === condition[1]) {
    str = condition[0] + " >= CONCAT(DATE_FORMAT(CURRENT_DATE, '%Y'), '-01-01 00:00:00')";
  } else if ('2' === condition[1]) {
    str = condition[0] + " >= CONCAT(DATE_FORMAT(CURRENT_DATE, '%Y-%m'), '-01 00:00:00')";
  } else if ('3' === condition[1]) {
    str = condition[0] + " >= CONCAT(ADDDATE(CURRENT_DATE, INTERVAL 1 - DAYOFWEEK(CURRENT_DATE) DAY), ' 00:00:00')";
  } else if ('4' === condition[1]) {
    str = condition[0] + " >= CONCAT(DATE_FORMAT(CURRENT_DATE, '%Y-%m-%d'), ' 00:00:00')";
  } else if ('5' === condition[1]) {
    str = condition[0] + " >= CONCAT(DATE_FORMAT(CURRENT_TIMESTAMP, '%Y-%m-%d %H'), ':00:00')";
  }
  return str;
}

function replaceCondition(condition_items) {
  var column = condition_items[0];
  var condition = condition_items[1];
  var value = condition_items[2];
  
  var replaced = "";
  // string 
  if ('str_like' === condition)
    replaced = column + " LIKE '%" + value + "%'";
  else if ('str_not_like' === condition)
    replaced = column + " NOT LIKE '%" + value + "%'";
  else if ('str_begins' === condition)
    replaced = column + " LIKE '" + value + "%'";
  else if ('str_not_begins' === condition)
    replaced = column + " NOT LIKE '" + value + "%'";
  else if ('str_ends' === condition)
    replaced = column + " LIKE '%" + value + "'";
  else if ('str_not_ends' === condition)
    replaced = column + " NOT LIKE '%" + value + "'";
  else if ('str_equals' === condition)
    replaced = column + " = '" + value + "'";
  else if ('str_not_equals' === condition)
    replaced = column + " != '" + value + "'";
  else if ('str_in' === condition)
    replaced = column + " IN ('" + value + "')"; //???
  else if ('str_not_in' === condition)
    replaced = column + " NOT IN ('" + value + "')"; //???
  else if ('str_null' === condition)
    replaced = column + " IS NULL";
  else if ('str_not_null' === condition)
    replaced = column + " IS NOT NULL";
  
  // numeric
  else if ('num_equals' === condition)
    replaced = [column, value].join(' = ');
  else if ('num_not_equals' === condition)
    replaced = [column, value].join(' != ');
  else if ('num_more' === condition)
    replaced = [column, value].join(' > ');
  else if ('num_less' === condition)
    replaced = [column, value].join(' < ');
  else if ('num_more_and_equals' === condition)
    replaced = [column, value].join(' >= ');
  else if ('num_less_and_equals' === condition)
    replaced = [column, value].join(' <= ');
  else if ('num_in' === condition)
    replaced = column + " IN (" + value + ")"; //???
  else if ('num_not_in' === condition)
    replaced = column + " NOT IN (" + value + ")"; //???
  
  // date
  //TODO: Shoulb be added quotes
  else if ('date_equals' === condition)
    replaced = [column, "'" + value + "'"].join(' = ');
  else if ('date_not_equals' === condition)
    replaced = [column, "'" + value + "'"].join(' != ');
  else if ('date_more' === condition)
    replaced = [column, "'" + value + "'"].join(' > ');
  else if ('date_less' === condition)
    replaced = [column, "'" + value + "'"].join(' < ');
  else if ('date_more_and_equals' === condition)
    replaced = [column, "'" + value + "'"].join(' >= ');
  else if ('date_less_and_equals' === condition)
    replaced = [column, "'" + value + "'"].join(' <= ');
  else if ('date_between' === condition)
    replaced = column + " BETWEEN '" + value.join("' AND '") + "'";
  else if ('date_in' === condition)
    replaced = column + " IN (" + value + ")"; //???
  else if ('date_not_in' === condition)
    replaced = column + " NOT IN (" + value + ")"; //???
  
  return replaced;
}

function empty(str) {
  return (!str || 0 === str.length);
}

function unique(value, index, self) { 
  return self.indexOf(value) === index;
}
