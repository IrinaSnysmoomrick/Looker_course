view: users {
  sql_table_name: "PUBLIC"."USERS"
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}."AGE" ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}."CITY" ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}."COUNTRY" ;;
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

  dimension: email {
    type: string
    sql: ${TABLE}."EMAIL" ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}."FIRST_NAME" ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}."GENDER" ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}."LAST_NAME" ;;
  }

  dimension: latitude {
    type: number
    sql: ${TABLE}."LATITUDE" ;;
  }

  dimension: longitude {
    type: number
    sql: ${TABLE}."LONGITUDE" ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}."STATE" ;;
  }

  dimension: state_geo{
    type: location
    sql_latitude: ${latitude} ;;
    sql_longitude: ${longitude} ;;
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}."TRAFFIC_SOURCE" ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}."ZIP" ;;
  }

  dimension: city_state {
    type: string
    sql: ${city} ||' ' || ${state} ;;
  }

  dimension: age_tier {
    type: tier
    tiers: [18, 25, 35, 45, 55, 65, 75, 90]
    style: integer
    sql: ${age} ;;
  }

  dimension: demographics_age_tier {
    type: tier
    tiers: [15, 25, 35, 50, 65]
    style: integer
    sql: ${age} ;;
  }

  dimension: new_user {
    type: yesno
    sql: DATEDIFF(day, ${created_date}, CURRENT_DATE()) < 90;;
  }

  measure: count {
    type: count
    drill_fields: [id, last_name, first_name, events.count, order_items.count]
  }

  set: user_info {
    fields:[
      id,
      age,
      age_tier,
      city,
      gender,
      first_name,
      last_name,
      country,
      city]
  }
}
