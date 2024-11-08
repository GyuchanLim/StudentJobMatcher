require 'processer'
require 'csv'

RSpec.describe Processer do
  let(:jobseekers) { CSV.read("spec/fixtures/mock_jobseekers.csv", headers: true) }
  let(:jobs) { CSV.read("spec/fixtures/mock_jobs.csv", headers: true) }
  let(:expected_output) do
    [
      [1, "Aable", 1, "X", 3, 100],
      [1, "Aable", 2, "Y", 2, 100],
      [1, "Aable", 3, "Z", 1, 100],
      [2, "Barry", 2, "Y", 2, 100],
      [2, "Barry", 3, "Z", 1, 100],
      [2, "Barry", 1, "X", 2, 67],
      [3, "Cody", 3, "Z", 1, 100],
      [3, "Cody", 2, "Y", 1, 50],
      [3, "Cody", 1, "X", 1, 33]
    ]
  end

  let(:subject) { described_class.new(jobseekers,jobs) }

  context "when not in order by id" do
    it "gives expected output" do
      jobseekers[0], jobseekers[2] = jobseekers[2], jobseekers[0]


      # assert jobseeker is in reverse order
      expect(subject.job_seekers.map{ |seeker| seeker["id"] }).to eq ["3", "2", "1"]
      expect(subject.call).to eq expected_output
    end
  end

  context "when skills contain duplicates" do
    it "removes the duplicates and puts into an array" do
      jobseekers.first["skills"] = "A, B, C, C, C"
      jobs.first["required_skills"] = "A, A, A, B, C"

      expect { subject.call }.to change {
        subject.job_seekers.first["skills"]
        }.from("A, B, C, C, C").to(["A", "B", "C"])
        .and change {
          subject.jobs.first["required_skills"]
        }.from("A, A, A, B, C").to(["A", "B", "C"])
    end

    it "gives expected output" do
      expect(subject.call).to eq expected_output
    end
  end

  it "gives expected output" do
    expect(subject.call).to eq expected_output
  end
end