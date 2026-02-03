# Fios

Fios is a data analytics framework for Ruby on Rails applications.

It provides a structured, explicit way to define datasets, adapters, charts, reports, and dashboards — making analytics code predictable, testable, and reusable.


## Features

📊 Persisted datasets with explicit metadata
🔌 Adapters to control how data is fetched (ActiveRecord, SQL, APIs, etc.)
📈 Chart builders for producing chart-ready data
📑 Report builders for producing tabular data
🧠 Registry-based architecture (no magic constants)
⚙️ Rails generators to get started quickly
♻️ Works with or without ActiveRecord models


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

### 3. Generate a Dataset Definition
```
bin/rails generate fios:data_source EmployeeReport
```

This creates:

```
# app/datasets/employee_report.rb
class EmployeeReport
  include Fios::Definitions::Base

  def self.dataset_key
    :employee_report
  end
end
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
* Identifies the Dataset Definition via slug.
* Declares which adapter should be used.
* Acts as the stable reference point for Charts and Reports.
* A Dataset must always exist in the database.

### Dataset Definitions

A Dataset Definition is a Ruby class that represents where data comes from.
* May be an ActiveRecord model, a database view, or a plain Ruby class
* Must define a dataset_key
* Is looked up using Dataset.slug

```
class EmployeeReport
  include include Fios::Definitions::Base

  def self.dataset_key
    :employee_report
  end
end
```

Each Dataset Definition has exactly one corresponding Dataset record.

Instantiation of Dataset Definitions (if any) is controlled entirely by the Adapter.

### Adapters

Adapters define how data is fetched and shaped from a Dataset Definition.

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

  def self.fetch_chart_data(dataset_definition, report)
    # returns chart-ready data
  end

  def self.fetch_report_data(dataset_definition, report)
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
Fios::Definitions::Registry.definitions
# => { employee_report: EmployeeReport }

Fios::Adapters::Registry.adapters
# => { active_record: ActiveRecordAdapter }
```

Benefits:
* Explicit registration
* Inspectable state
* Predictable behavior
* No implicit class loading

## Initializer

All Datasets and Adapters are registered explicitly:

```
# config/initializers/fios.rb
Rails.application.config.to_prepare do
  Fios::Registrar.register do
    adapter Fios::Adapters::ActiveRecordAdapter
    dataset EmployeeReport
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
* Definitions describe where data comes from
* Adapters describe how data is fetched
* Registration should be opt-in and predictable
* Frameworks should clarify behavior, not hide it

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Fios project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/fios/blob/master/CODE_OF_CONDUCT.md).
