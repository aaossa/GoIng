class ChangeParticipantsFromSerializedTextToArray < ActiveRecord::Migration[5.2]
  # Custom StubedRequest classes
  class StubedRequestUp < ActiveRecord::Base
    # Stub class to hold this table
    self.table_name = 'requests'
    # Keep legacy serialization
    serialize :participants, Hash
  end
  class StubedRequestDown < ActiveRecord::Base
    # Stub class to hold this table
    self.table_name = 'requests'
    # Use temporal serialization
    serialize :participants_temp, Hash
  end


  def up
    # Add new temporal column current format
    add_column :requests, :participants_temp, :string, array: true, length: 4, default: []
    # Manually update each record
    StubedRequestUp.find_each do |request|
      _participants = request.participants # Hash
      # Using the request.participants serialization from Hash
      request.participants_temp = _participants.values
      # Save but skip validations
      request.save!
    end
    # Remove old column
    remove_column :requests, :participants
    # Change temporal column name to real column name
    rename_column :requests, :participants_temp, :participants
    # Add index
    add_index :requests, :participants, using: 'gin'
  end

  def down
    # Add new temporal column with legacy format
    add_column :requests, :participants_temp, :text
    # Manually update each record
    StubedRequestDown.find_each do |request|
      _participants = request.participants # Array
      # Using the array to save participants as hash
      request.participants_temp = _participants.size.times.zip(_participants).to_h
      # Save but skip validations
      request.save!
    end
    # Remove old column
    remove_column :requests, :participants
    # Change temporal column name to real column name
    rename_column :requests, :participants_temp, :participants
  end
end