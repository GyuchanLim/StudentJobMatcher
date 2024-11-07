require 'csv'
require 'debug'

module  StudentJobMatcher
    class  Processer
        attr_reader :job_seekers_csv, :jobs_csv

        def initialize(job_seekers_csv, jobs_csv)
            @job_seekers_csv = job_seekers_csv
            @jobs_csv = jobs_csv
        end

        def start
            job_seekers_csv.each do |jobseeker|
                puts "Processing #{jobseeker["name"]}, id: #{jobseeker["id"]}"
                pp process_jobseeker(jobseeker)
            end
        end

        def process_jobseeker(jobseeker)
            jobseeker_output = []

            jobs_csv.each do |job|
                seeker_skills = jobseeker["skills"].split(', ')
                required_skills = job["required_skills"].split(', ')

                matched_skills = match_skills(seeker_skills, required_skills)

                unless matched_skills.nil?
                    jobseeker_output.append([jobseeker["id"], jobseeker["name"], job["id"], job["title"], matched_skills.count, format_matched_percentage(matched_skills, required_skills) ])
                end
            end

            jobseeker_output
        end

        def match_skills(seeker_skills, required_skills)
            matched_skills = seeker_skills.intersection(required_skills)
            matched_skills.empty? ? nil : matched_skills
        end

        def format_matched_percentage(matched_skills, required_skills)
            ((matched_skills.count.to_f/required_skills.count)*100).round
        end
    end
end

StudentJobMatcher::Processer.new(CSV.read("input/jobseekers.csv", headers: :first_row), CSV.read("input/jobs.csv", headers: :first_row)).start
