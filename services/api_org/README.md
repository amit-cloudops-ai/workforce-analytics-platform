# api_org (Workstream C)

Serves `GET /org/tree`: Scan `employees`, build the nested tree recursively; break cycles, attach orphans to root, depth limit 15, always report `warnings`. Issue WFA-022.
