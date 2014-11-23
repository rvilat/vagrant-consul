{% set host_name = salt['grains.get']('host') %}
{% set bind_addr = salt['grains.get']('bind_addr') %}
{% set join_addr = salt['grains.get']('join_addr') %}
{% set num_servers = salt['grains.get']('num_servers') %}
{% set dc_id = salt['grains.get']('dc_id') %}
{% set join_wan_ip = salt['grains.get']('join_wan_ip') %}

consul:
  group.present:
    - name: consul
  user.present:
    - name: consul
    - fullname: Consul
    - home: /tmp/consul
    - groups:
      - consul
    - require:
      - group: consul
  file.managed:
    - name: /usr/local/bin/consul
    - source: salt://consul
    - user: consul
    - group: consul
    - mode: 755
    - require:
      - user: consul
  cmd.run:
    - name: daemon -n consul -X "/usr/local/bin/consul agent -server -dc {{ dc_id }} -bootstrap-expect {{ num_servers }} -data-dir /tmp/consul -node={{ host_name }} -bind {{ bind_addr }} -join {{ join_addr }}"
    - user: consul
    - cwd: /tmp/consul
    - require:
      - file: /usr/local/bin/consul

consul-join-wan:
  cmd.run:
    - name: sleep 20 && consul join -wan {{ join_wan_ip }}
    - user: consul
    - cwd: /tmp/consul
    - require:
      - cmd: consul