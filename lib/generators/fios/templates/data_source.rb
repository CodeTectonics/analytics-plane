class <%= class_name %>
  include Fios::Definitions::Base

  def self.dataset_key
    :<%= file_name %>
  end
end
