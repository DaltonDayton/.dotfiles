{ ... }:

{
  # Limit total size of system journal logs to 50MB.
  # Maximum number of separate journal files to keep (5).
  services.journald.extraConfig = "SystemMaxUse=50M\nSystemMaxFiles=5";

  # Allow up to 500 log entries in a short burst before rate limiting kicks in.
  services.journald.rateLimitBurst = 500;

  # The time window (30 seconds) over which the log burst limit is enforced.
  services.journald.rateLimitInterval = "30s";
}
