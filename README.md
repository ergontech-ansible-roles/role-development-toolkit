### Role Skeleton

This project uses a custom Ansible Role Skeleton to stay within our coding guidlines. Docs on Ansible Galaxy Skeletons [Here](https://docs.ansible.com/ansible/latest/reference_appendices/galaxy.html#create-roles)

This skeleton will provide less file overhead than the default, while also adding some basic tests and travis setup.

```
# Initialize a new role
ansible-galaxy init --role-skeleton=<path-to-role-skeleton-directory> <role_name>
```