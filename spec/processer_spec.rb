require 'processer'
require 'csv'
require 'byebug'

RSpec.describe Processer do
    let(:jobseekers) do
        <<~CSV
            id,name,skills
            1,A,"s1, s2, s3"
            2,B,"s1, s2"
            3,C,"s1"
        CSV
      end
    
      let(:jobs) do
        <<~CSV
            id,title,required_skills
            1,X,"s1, s2"
            2,Y,"s2"
            3,Z,"s2, s1"
        CSV
      end

      let(:expected_output) do
        [
            ["1", "A", "1", "X", 2, 100],
            ["1", "A", "2", "Y", 1, 100],
            ["1", "A", "3", "Z", 2, 100],
            ["2", "B", "1", "X", 2, 100],
            ["2", "B", "2", "Y", 1, 100],
            ["2", "B", "3", "Z", 2, 100],
            ["3", "C", "1", "X", 1, 50],
            ["3", "C", "3", "Z", 1, 50]
        ]
      end

    context "happy path" do
        it "gives expected output" do
            # expect(described_class.new('a', 'b').start ).to eq 1
            expect(described_class.new(CSV.parse(jobseekers, headers: true), CSV.parse(jobs, headers: true)).start).to eq expected_output
        end
    end

    context "when order of jobseekers are random" do
        let(:jobseekers) do
            <<~CSV
                id,name,skills
                2,B,"s1, s2"
                1,A,"s1, s2, s3"
                3,C,"s1"
            CSV
        end

        it "still gives expected output" do
            # expect(described_class.new('a', 'b').start ).to eq 1
            expect(described_class.new(CSV.parse(jobseekers, headers: true), CSV.parse(jobs, headers: true)).start).to eq expected_output
        end
    end

    context "when order of jobs are random" do
        let(:jobs) do
            <<~CSV
                id,title,required_skills
                3,Z,"s2, s1"
                1,X,"s1, s2"
                2,Y,"s2"
            CSV
        end

        it "still gives expected output" do
            # expect(described_class.new('a', 'b').start ).to eq 1
            expect(described_class.new(CSV.parse(jobseekers, headers: true), CSV.parse(jobs, headers: true)).start).to eq expected_output
        end
    end
end