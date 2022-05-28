{
  # Let's Encrypt certificate default configuration
  # This enables any service to use a Let's Encrypt certificate
  security.acme.email = "a+acme@crans.org";
  security.acme.acceptTerms = true;

  # Security hardening
  services.nginx = {
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    commonHttpConfig = ''
      add_header Strict-Transport-Security "max-age=31536000; includeSubdomains; preload" always;
    '';
  };
}
