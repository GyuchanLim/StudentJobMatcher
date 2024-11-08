## Requirements
- Ruby 3.1.2
- Bundler

## Assumption
- `id` column for both csvs will always be an integer - no quotation around them in example csvs

## How to run
- `ruby main.rb` will run with default set of data
- `ruby main.rb "jobseeker_csv_path" "jobs_csv_path"` will run with any set of data given
- Result will be stored as `job_match_result.csv` in root project directory

## Testing
- `bundle exec rspec`
