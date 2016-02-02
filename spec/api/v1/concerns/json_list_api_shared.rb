require 'rails_helper'

shared_examples_for "json list" do |hash, object, path, match = true|
  hash.each do |attr|
    it "object #{match ? "contains" : "does not contain"} matching #{attr}" do
      matching_object = send(object)
      if match
        expect(response.body).to be_json_eql(matching_object.send(attr.to_sym).to_json).at_path(path + attr)
      else
        expect(response.body).not_to be_json_eql(matching_object.send(attr.to_sym).to_json).at_path(path + attr)
      end
    end
  end
end

shared_examples_for "json path exclusion" do |hash, path|
  hash.each do |attr|
    it "object does not contain path #{path}" do
      expect(response.body).to_not have_json_path(path + attr)
    end
  end
end