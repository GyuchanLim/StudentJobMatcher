# ruby main.rb input/jobseekers.csv input/jobs.csv
require 'csv'
require './lib/processer'

jobseeker_csv_path = ARGV[0] || 'input/jobseekers.csv'
jobs_csv_path = ARGV[1] || 'input/jobs.csv'

jobseeker_csv = CSV.read(jobseeker_csv_path, headers: :first_row)
jobs_csv = CSV.read(jobs_csv_path, headers: :first_row)

processer = Processer.new(jobseeker_csv, jobs_csv)
pp processer.start