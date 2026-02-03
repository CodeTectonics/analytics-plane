# Fios

Fios is a data analytics framework for Ruby on Rails applications.

It provides a structured, explicit way to define datasets, adapters, charts, reports, and dashboards — making analytics code predictable, testable, and reusable.


## Features

- 📊 Persisted datasets with explicit metadata
- 🔌 Adapters to control how data is fetched (ActiveRecord, SQL, APIs, etc.)
- 📈 Chart builders for producing chart-ready data
- 📑 Report builders for producing tabular data
- 🧠 Registry-based architecture (no magic constants)
- ⚙️ Rails generators to get started quickly
- ♻️ Works with or without ActiveRecord models


## Installation

Add the gem to your Gemfile:
```
gem "fios"
```

Then install:
```
bundle install
```


## Getting Started

### 1. Run the installer
```
bin/rails generate fios:install
```

This will:
* Add a Fios initializer
* Set up registry hooks using config.to_prepare

### 2. Generate core models

#### Chart
```
bin/rails generate fios:chart Chart
```

Creates:
* Chart model
* Migration

#### Report
```
bin/rails generate fios:report Report
```

Creates:
* Report model
* Migration

#### Dashboard
```
bin/rails generate fios:dashboard Dashboard
```

Creates:
* Dashboard model
* DashboardWidget model
* Migrations

#### Dataset
```
bin/rails generate fios:dataset Dataset
```

Creates:
* Dataset model
* Migration

### 3. Generate a Data Source
```
bin/rails generate fios:data_source EmployeeReport
```

This creates:

```
# app/datasets/employee_report.rb
class EmployeeReport
  include Fios::DataSources::Base

  def self.dataset_key
    :employee_report
  end
end
```


## Minimal End-to-End Example

This example shows the complete flow from a persisted Dataset to chart-ready data.

### 1. Dataset Record

Create a Dataset record:

```
Dataset.create!(
  slug: "employee_report",
  name: "Employee Report",
  description: "Employees grouped by department",
  adapter: "active_record"
)
```

### 2. Data Source

Define where the data comes from:

```
# app/datasets/employee_report.rb
class EmployeeReport
  include Fios::DataSources::Base

  def self.dataset_key
    :employee_report
  end

  def self.all
    Employee.all
  end
end
```

This data source does not need to be an ActiveRecord model.

### 3. Register the Data Source and Adapter

Register your Data Source:

```
# config/initializers/fios.rb
Rails.application.config.to_prepare do
  Fios::Registrar.register do
    adapter Fios::Adapters::ActiveRecordAdapter
    data_source EmployeeReport
  end
end
```

### 4. Create a Chart

```
chart = Chart.create!(
  name: "Employees by Department",
  configuration: {
    dataset_id: Dataset.find_by!(slug: "employee_report").id,
    chart_type: "column",
    x_axis: { attr: "department", label: "Department" },
    y_axes: [
      { attr: "id", label: "Employees", aggregation: "count" }
    ],
    filters: [
      { attr: "job", type: "string", operator: "=", value: "Clerk" }
    ]
  }
)
```

### 5. Fetch Chart Data

ChartBuilder.build returns a frontend-agnostic hash shaped for charting libraries.

```
data = Fios::Builders::ChartBuilder.build(chart)
```

Result:
```
{
  'chart': {
    'type': 'column'
  },

  'title': {
    'text': 'Employees by Department'
  },

  'xAxis': {
    'categories': ['Engineering', 'Sales', 'HR']
  },

  'yAxis': {
    'title': {
      'text': nil
    }
  },

  'series': [{ name: "Employees", data: [12, 8, 5] }]
}
```

This data can be passed directly to a frontend charting library such as Highcharts.

### 6. Create a Report

```
report = Report.create!(
  name: "Employees by Department",
  configuration: {
    dataset_id: Dataset.find_by!(slug: "employee_report").id,
    aggregated: true,
    columns: [
      { name: "department", type: "string", selected: true, group_by: true, count: false, count_distinct: false, average: false, max: false, min: false, sum: false },
      { name: "id", type: "string", selected: true, group_by: false, count: true, count_distinct: false, average: false, max: false, min: false, sum: false }
    ],
    filters: [
      { name: "job", type: "string", operator: "=", value: "Clerk" }
    ]
  }
)
```

### 7. Fetch Report Data

ReportBuilder.build returns a frontend-agnostic array shaped for tabular reporting.

```
data = Fios::Builders::ReportBuilder.build(report)
```


## Core Concepts

### Dataset (Persisted)

A Dataset is a persisted record that describes a data source available to the application.

Schema:
```
t.string :slug
t.string :name
t.text   :description
t.string :adapter
```

Responsibilities:
* Identifies the Data Source via slug.
* Declares which adapter should be used.
* Acts as the stable reference point for Charts and Reports.
* A Dataset must always exist in the database.

### Data Sources

A Data Source is a Ruby class that defines how a Dataset’s data is retrieved.
* May be an ActiveRecord model, a database view, or a plain Ruby class
* Must define a dataset_key
* Is looked up using Dataset.slug

```
class EmployeeReport
  include Fios::DataSources::Base

  def self.dataset_key
    :employee_report
  end
end
```

Each Data Source has exactly one corresponding Dataset record.

Instantiation of Data Sources (if any) is controlled entirely by the Adapter.

### Adapters

Adapters define how data is fetched and shaped from a Data Source.

Examples:
* ActiveRecord
* Raw SQL
* External APIs
* In-memory or computed datasets

```
class ActiveRecordAdapter
  include Fios::Adapters::Base

  def self.adapter_key
    :active_record
  end

  def self.fetch_chart_data(data_source, chart)
    # returns chart-ready data
  end

  def self.fetch_report_data(data_source, report)
    # returns tabular data
  end
end
```

Adapters are responsible for:
* Querying
* Aggregation
* Filtering
* Formatting output

### Charts

Charts:
* Reference a Dataset
* Store filters and chart configuration in configuration
* Produce chart-ready data (series, categories, metadata)

### Reports

Reports:
* Reference a Dataset
* Store filters and column configuration in configuration
* Produce tabular data

### Registries

Fios uses registries instead of global constants.

```
Fios::DataSources::Registry.data_sources
# => { employee_report: EmployeeReport }

Fios::Adapters::Registry.adapters
# => { active_record: ActiveRecordAdapter }
```

Benefits:
* Explicit registration
* Inspectable state
* Predictable behavior
* No implicit class loading

### Initializer

All Datasets and Adapters are registered explicitly:

```
# config/initializers/fios.rb
Rails.application.config.to_prepare do
  Fios::Registrar.register do
    adapter Fios::Adapters::ActiveRecordAdapter
    data_source EmployeeReport
  end
end
```

This works correctly in:
* development (reloadable)
* test
* production

No eager loading required.


## Architecture Philosophy

Fios is built around a few guiding principles:
* Analytics logic should live outside controllers
* Datasets should be explicit and persisted
* Data Sources describe where data comes from
* Adapters describe how data is fetched
* Registration should be opt-in and predictable
* Frameworks should clarify behavior, not hide it


## Why Fios Exists

Analytics code in Rails applications often grows organically:
* Queries live in controllers or services
* Charts embed SQL or ActiveRecord logic
* Reports duplicate filtering and aggregation logic
* Business rules become scattered and hard to reason about

Over time, analytics becomes:
* difficult to test
* difficult to extend
* risky to change

Fios exists to solve this problem by making analytics a first-class concern.

Instead of hiding complexity, Fios makes analytics code:
* explicit
* structured
* inspectable

### What Fios Does Differently

Fios separates analytics into clear responsibilities:
* Datasets describe what data exists (persisted metadata)
* Data Sources describe where data comes from
* Adapters describe how data is fetched and shaped
* Charts and Reports describe how data is queried and presented

This separation:
* avoids tight coupling to ActiveRecord
* supports multiple data sources
* keeps analytics logic out of controllers
* encourages reuse instead of duplication

### Who Fios Is For

Fios is designed for teams that:
* build internal tools or data-heavy applications
* need dashboards and reports backed by real business logic
* care about maintainability more than “quick charts”
* want analytics code that survives beyond the first version

Fios is not a BI tool, a charting library, or a UI framework.

It is the analytics layer that sits between your application data and whatever frontend or visualization tool you choose.

### Philosophy

Fios is built on a few core beliefs:
* Analytics deserves the same structure as the rest of your application
* Explicit registration is better than magic loading
* Query logic should be testable Ruby code
* Frameworks should help you understand your system, not obscure it

If your analytics logic is becoming hard to reason about, Fios gives it a home.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).


## Code of Conduct

Everyone interacting in the Fios project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/CodeTectonics/fios/blob/master/CODE_OF_CONDUCT.md).
