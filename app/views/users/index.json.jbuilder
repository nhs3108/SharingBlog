json.array!(@users) do |user|
  json.extract! user, :id, :name, :email, :admin, :picture, :password_digest, :remember_digest, :activation_digest
  json.url user_url(user, format: :json)
end
