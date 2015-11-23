def verify_augeas_changes(subject, title, expected_changes)
  changes = subject.resource('augeas', title).send(:parameters)[:changes]
  if changes.is_a?(String)
    changes = changes.split(/\n/)
  end
  expect(changes & expected_changes).to eq(expected_changes)
end
