connection: "snowlooker"

# include all the views
include: "/views/**/*.view"

datagroup: looker_intensive2_irina_fedorova_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: looker_intensive2_irina_fedorova_default_datagroup

explore: distribution_centers {
  description: "Explore distribution centers only"
}

explore: etl_jobs {
  description: "Explore etl_jobs only"
}

explore: events {
  description: "Explore events with users"
  join: users {
    type: left_outer
    sql_on: ${events.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: inventory_items {
  description: "Explore inventory intems with distribution centers"
  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: order_items {
  description: "Explore orders with additional information about users, products
  and distribution centers"
  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: products {
  description: "Explore products with distribution centers"
  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: users {
  description: "Explore users"
}

explore: customers {
  description: "Explore users and theirs behavior"
  view_name: users
  join: order_items{
    type: inner
    sql_on: ${users.id} = ${order_items.user_id} ;;
    relationship: one_to_many
  }
  join: events {
    type: left_outer
    sql_on: ${users.id} = ${events.user_id} ;;
    relationship: one_to_many
  }
  fields: [users.first_name,
           users.last_name,
           users.country,
           users.age_tier,
           users.gender,
           events.count,
           order_items.Average_Spend_per_Customer]
}
