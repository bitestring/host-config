## Known issues and workarounds

<details>
<summary>ERROR: contains an unknown parameter [_type]</summary>

```
2023-09-12T12:27:38.249+0200 ERROR [publisher_pipeline_output] pipeline/output.go:180 failed to publish events: 400 Bad Request: {"error":{"root_cause":[{"type":"illegal_argument_exception","reason":"Action/metadata line [1] contains an unknown parameter [_type]"}],"type":"illegal_argument_exception","reason":"Action/metadata line [1] contains an unknown parameter [_type]"},"status":400}
```

https://groups.google.com/g/wazuh/c/qe6DTJnq7qo

Add following option in `./config/wazuh_indexer/wazuh.indexer.yml`

```
compatibility.override_main_response_version: true
```

</details>

<details>
<summary>wazuh-certs-generator fails to check for download while using proxy</summary>

https://github.com/wazuh/wazuh-docker/issues/1934

If you are connected to Tailscale, VPN or Proxy, wazuh-certs-generator may not generate the certificates. Disable the proxy to generate certificates successfully.
</details>


## Deploying Wazuh agents on Linux endpoints

https://documentation.wazuh.com/current/installation-guide/wazuh-agent/wazuh-agent-package-linux.html
