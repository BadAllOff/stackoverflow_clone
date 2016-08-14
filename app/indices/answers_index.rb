ThinkingSphinx::Index.define :answer, with: :active_record do
  # fields
  indexes body
  indexes user.username, as: :author, sortable: true
  # attributes
  has question_id, user_id, created_at, updated_at
end
