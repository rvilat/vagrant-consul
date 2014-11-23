{% set host_name = salt['grains.get']('host') %}
{% set bind_addr = salt['grains.get']('bind_addr') %}
{% set join_addr = salt['grains.get']('join_addr') %}
{% set num_servers = salt['grains.get']('num_servers') %}

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
{% if host_name == 'consul-01' %}
    - name: daemon -n consul -X "/usr/local/bin/consul agent -server -bootstrap-expect {{ num_servers }} -data-dir /tmp/consul -node={{ host_name }} -bind {{ bind_addr }}"
{% else %}
    - name: daemon -n consul -X "/usr/local/bin/consul agent -server -bootstrap-expect {{ num_servers }} -data-dir /tmp/consul -node={{ host_name }} -bind {{ bind_addr }} -join {{ join_addr }}"
{% endif %}
    - user: consul
    - cwd: /tmp/consul
    - require:
      - file: /usr/local/bin/consul
