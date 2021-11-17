view: order_items {
  sql_table_name: "PUBLIC"."ORDER_ITEMS"
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."CREATED_AT" ;;
  }

  dimension_group: delivered {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."DELIVERED_AT" ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."INVENTORY_ITEM_ID" ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."RETURNED_AT" ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}."SALE_PRICE" ;;
  }

  dimension_group: shipped {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."SHIPPED_AT" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."USER_ID" ;;
  }

  dimension: shipping_days {
    type: duration_day
    sql_start: ${shipped_date} ;;
    sql_end: ${delivered_date} ;;
  }

  dimension: is_returned {
    type: yesno
    sql: UPPER(${status} = 'RETURNED' ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: Total_Sale_Price {
    type: sum
    label: "Total sale price"
    group_label: "Totals"
    description: "Total sales of items sold"
    value_format_name: usd
    sql: ${sale_price} ;;
    filters: [status: "Complete"]
  }

  measure: Average_Sale_Price {
    type: average
    label: "Average sale price"
    group_label: "Averages"
    description: "Average sale price of items sold"
    value_format_name: usd
    sql: ${sale_price};;
    filters: [status: "Complete"]
  }

  measure: Cumulative_Total_Sales {
    type: running_total
    label: "Cumulative total sales"
    group_label: "Totals"
    description: "Cumulative total sales from items sold (also known as a running total)"
    value_format_name: usd
    sql: ${Total_Sale_Price};;
    }

  measure: Total_Gross_Revenue {
    type: sum
    label: "Total gross revenue"
    group_label: "Totals"
    description: "Total revenue from completed sales"
    value_format_name: usd
    sql: ${sale_price} ;;
    filters: [status: "-Returned, -Cancelled"]
    drill_fields: [detail*]
  }

  measure: Total_Gross_Margin_Amount {
    type: sum
    label: "Total gross margin amount"
    group_label: "Totals"
    description: "Total difference between the total revenue from completed sales and the cost of the goods that were sold"
    value_format_name: usd
    sql: ${sale_price} - ${inventory_items.cost} ;;
    drill_fields: [detail*]
  }

  measure: Average_Gross_Margin {
    type: average
    label: "Average gross margin"
    group_label: "Averages"
    description: "Average difference between the total revenue from completed sales and the cost of the goods that were sold"
    value_format_name: usd
    sql: ${sale_price} - ${inventory_items.cost} ;;
    drill_fields: [detail*]
  }

  measure: Gross_Margin {
    type: number
    label: "Gross margin %"
    description: "Total Gross Margin Amount / Total Gross Revenue"
    value_format_name: percent_2
    sql: nullif(${Total_Gross_Margin_Amount},0) / nullif(${Total_Gross_Revenue},0) ;;
    drill_fields: [detail*]
  }

  measure: Number_of_Items_Returned {
    type: count_distinct
    label: "Number of items returned"
    description: "Number of items that were returned by dissatisfied customers"
    sql: ${inventory_item_id} ;;
    filters: [status: "Returned"]
    drill_fields: [detail*]
  }

  measure: Item_Return_Rate {
    type: number
    label: "Item return rate"
    group_label: "Rates"
    description: "Number of Items Returned / total number of items sold"
    value_format_name: percent_2
    sql: ${Number_of_Items_Returned} / nullif(${inventory_items.sold_items_count},0);;
    drill_fields: [detail*]
    }

  measure: Number_Of_Customer_Returning_Items {
    type: count_distinct
    label: "Number of customer returning items"
    description: "Number of users who have returned an item at some point"
    sql: ${user_id} ;;
    filters: [status: "Returned"]
    drill_fields: [detail*]
  }

  measure: Percent_Of_Users_With_Returns {
    type: number
    label: "% of Users with returns"
    group_label: "Rates"
    description: "Number of Customer Returning Items / total number of customers"
    value_format_name: percent_2
    sql: ${Number_Of_Customer_Returning_Items} / nullif(${users.count},0) ;;
    drill_fields: [detail*]
    }

  measure: Average_Spend_per_Customer {
    type: number
    label: "Average spend per customer"
    group_label: "Averages"
    description: "Total Sale Price / total number of customers"
    value_format_name: usd
    sql: ${Total_Sale_Price} / nullif(${users.count},0) ;;
    drill_fields: [detail*]
  }
  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      inventory_items.product_name,
      inventory_items.id,
      users.last_name,
      users.first_name,
      users.id
    ]
  }
}
