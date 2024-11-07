require 'csv'

def main
    # id,name,skills
    arr_of_jobseekers_rows = CSV.read("input/jobseekers.csv", headers: :first_row)

    # id,title,required_skills
    arr_of_jobs_rows = CSV.read("input/jobs.csv", headers: :first_row)

    arr_of_jobseekers_rows.each do |jobseeker|
        matching_jobs = []

        puts "Processing #{jobseeker["name"]}, id: #{jobseeker["id"]}"
        arr_of_jobs_rows.each do |jobs|
            matching_jobs.append(match_skills(jobseeker["skills"], jobs["required_skills"]))
        end

        pp matching_jobs
    end
end

def match_skills(jobseeker, jobs)
    seeker_skills = jobseeker.split(', ')
    required_skills = jobs.split(', ')

    seeker_skills.intersection(required_skills)
end

main