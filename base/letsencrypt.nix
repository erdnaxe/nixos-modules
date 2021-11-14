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
      # Add HSTS header with preloading to HTTPS requests.
      # Adding this header to HTTP requests is discouraged
      map $scheme $hsts_header {
          https   "max-age=31536000; includeSubdomains; preload";
      }
      add_header Strict-Transport-Security $hsts_header;
    '';
  };
}
