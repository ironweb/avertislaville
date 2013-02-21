module Open311

  class Response
    include ActiveAttr::Model

    attribute :service_request_id
    attribute :token
    attribute :service_notice
    attribute :account_id
  end

end
