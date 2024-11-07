class  Processer
    attr_reader :job_seekers_csv, :jobs_csv

    def initialize(job_seekers_csv, jobs_csv)
        @job_seekers_csv = job_seekers_csv
        @jobs_csv = jobs_csv
    end

    def start
        container = []

        job_seekers_csv.each do |jobseeker|
            container += (process_jobseeker(jobseeker))
        end

        # Sort by jobseeker_id
        # then followed by % matching
        # then by job id
        # TODO need to sort by real name, not #
        container.sort_by { |output_row| [output_row[0], output_row[5], output_row[3]] }
    end

    def process_jobseeker(jobseeker)
        jobseeker_output = []

        jobs_csv.each do |job|
            # assume no duplicate skills
            seeker_skills = jobseeker["skills"].split(', ')
            required_skills = job["required_skills"].split(', ')

            matched_skills = match_skills(seeker_skills, required_skills)

            unless matched_skills.nil?
                # OUTPUT IS WRONG TYPE
                # ALSO MAYBE APPEND AS HASH?
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

# Processer.new(CSV.read("input/jobseekers.csv", headers: :first_row), CSV.read("input/jobs.csv", headers: :first_row)).start
