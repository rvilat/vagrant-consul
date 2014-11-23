core-pkgs:               
  pkg.installed:
    - pkgs:
      - telnet
      - man
      - unzip
      - daemon
      - curl

salt-minion:
  service.dead:
    - enable: False
