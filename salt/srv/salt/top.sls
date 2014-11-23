base:
  '*':
    - core
  'host:consul*':
    - match: grain
    - consul