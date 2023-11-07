# FactoryBotメソッドをそのまま使えるようにする
RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end
