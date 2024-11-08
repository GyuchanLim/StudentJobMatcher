class  Cleaner
  def initialize(job_seekers_csv, jobs_csv)
    @job_seekers_csv = job_seekers_csv
    @jobs_csv = jobs_csv
  end
  
  # What cleaning?
  # duplicate skills -jobs, seekers
  # missing column values
  # skills in weird format? e.g. "a,b, c"
  def clean

  end
end