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
<summary>Container won't start due to user namespace issue</summary>

When running Wazuh containers in a rootless Podman environment, Linux user namespace mapping is used to translate the container's root user (UID 0) to a standard host user (typically UID 1000). The ***wazuh-indexer*** and ***wazuh-dashboard*** containers run with UID 1000 internally, which requires proper volume bind permissions.

To resolve potential access issues, you have three main solutions:

**Manually adjust volume bind ownership:**

Change the owner of volume binds to match the mapped user ID on the host. Calculate the new owner ID using the formula:

`<host_subuid> + <container_userid> - 1`

**Use Podman's UserNS=keep-id option:**

This automatically maps the container's user 1000 to the host's user 1000

**Use named volumes:**

https://docs.podman.io/en/latest/markdown/podman-systemd.unit.5.html#volume-units-volume

Named volumes automatically take care of permissions inside the container.

</details>

## Deploying Wazuh agents on Linux endpoints

https://documentation.wazuh.com/current/installation-guide/wazuh-agent/wazuh-agent-package-linux.html
