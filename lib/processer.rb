class  Processer
  attr_reader :job_seekers, :jobs

  def initialize(job_seekers_csv, jobs_csv)
    @job_seekers = job_seekers_csv.map(&:to_hash)
    @jobs = jobs_csv.map(&:to_hash)
  end

  def call
    output_array = []

    split_skills
  
    job_seekers.each do |job_seeker|
      output_array += process_jobseeker(job_seeker)
    end

    output_array.sort_by { |output_row| [output_row[0], -output_row[5], output_row[3]] }
  end

  private

  def split_skills
    # '1, 2, 3' -> ['1', '2', '3']
    jobs.map do |job|
      begin
        job["required_skills"] = job["required_skills"].split(', ').uniq
      rescue => e
        raise StandardError, "Error processing job: #{job}, #{e}"
      end
    end

    job_seekers.map do |job_seeker|
      begin
        job_seeker["skills"] = job_seeker["skills"].split(', ').uniq
      rescue => e
        raise StandardError, "Error processing jobseeker: #{job_seeker}, #{e}"
      end
    end
  end

  def process_jobseeker(job_seeker)
    job_seeker_output = []

    jobs.each do |job|
      matching_skills = match_skills(job_seeker["skills"], job["required_skills"])

      unless matching_skills.nil?
        job_seeker_output << [
          job_seeker["id"].to_i,
          job_seeker["name"],
          job["id"].to_i,
          job["title"],
          matching_skills.count,
          matching_percentage(matching_skills, job["required_skills"])
        ]
      end
    end

    job_seeker_output
  end

  def match_skills(seeker_skills, required_skills)
    matching_skills = seeker_skills.intersection(required_skills)
    matching_skills.empty? ? nil : matching_skills
  end

  def matching_percentage(matching_skills, required_skills)\
    ((matching_skills.count.to_f/required_skills.count)*100).round
  end
end
