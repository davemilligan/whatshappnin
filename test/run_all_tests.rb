# Unit tests
require 'test/unit/resource_test'
require 'test/unit/patron_test'
require 'test/unit/agent_test'
require 'test/unit/comment_test'
require 'test/unit/reply_test'
require 'test/unit/venue_test'
require 'test/unit/event_test'


# functional tests
require 'test/functional/forum_controller_test'
require 'test/functional/login_controller_test'
require 'test/functional/patron_profile_controller_test'
require 'test/functional/resources_controller_test'
require 'test/functional/search_controller_test'
require 'test/functional/welcome_controller_test'
require 'test/functional/agents_controller_test'
require 'test/functional/admin_controller_test'

# integration tests
require 'test/integration/registration_stories_test'
require 'test/integration/login_stories_test'