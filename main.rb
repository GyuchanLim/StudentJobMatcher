require 'csv'
require './lib/processer'

puts "Processing job matcher."

jobseeker_csv_path = ARGV[0] || 'input/jobseekers.csv'
jobs_csv_path = ARGV[1] || 'input/jobs.csv'

jobseeker_csv = CSV.read(jobseeker_csv_path, headers: :first_row)
jobs_csv = CSV.read(jobs_csv_path, headers: :first_row)

result = Processer.new(jobseeker_csv, jobs_csv).call

output_file_path = 'job_match_result.csv'

CSV.open(output_file_path, "wb") do |result_csv|
  # Headers
  result_csv << 
  [
    "jobseeker_id",
    "jobseeker_name",
    "job_id",
    "job_title",
    "matching_skill_count",
    "matching_skill_percent"
  ]

  # Rows
  result.each do |row|
    result_csv << row
  end
end

puts "#{result.length} lines written to `#{output_file_path}`."