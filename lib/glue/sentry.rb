# Sentry, Copyright (c) 2005 Rick Olson
# This is an  adapter to use Sentry within Nitro.

require 'openssl'
require 'base64'
require 'sentry/symmetric_sentry'
require 'sentry/asymmetric_sentry'
require 'sentry/sha_sentry'
require 'sentry/symmetric_sentry_callback'
require 'sentry/asymmetric_sentry_callback'

module Sentry
  class NoKeyError < StandardError
  end
  class NoPublicKeyError < StandardError
  end
  class NoPrivateKeyError < StandardError
  end
end
