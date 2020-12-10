# debian_ssh

An ssh-enabled base image for Debian

### Building the image:

```bash
> docker build -t goodsy/debian_ssh:18.04 .
```

### Running:

The image exposes port 22 by default in the resulting container.
You could stipulate to map the host to the same port on the machine (i.e. `'-p 22:22'`), but I prefer to keep it random.

```bash
> docker run -d -P --name pg_debian_ssh goodsy/debian_ssh:18.04
```

### SSH method 1 (password method)

First, the default root password for this build is `'root'`.
Might want to change that to something else:

```bash
> docker exec -ti pg_debian_ssh passwd root
 Enter  new UNIX password: my_new_password 
 Retype new UNIX password: my_new_password
 passwd: password updated successfully
```

Now, find out which random port from the host machine has been allocated to the container's port 22:

```bash
> docker port pg_debian_ssh 22
 0.0.0.0:32768
```

So port 22 on the container has been mapped to port `32768` locally, and we can ssh via that port:

```bash
> ssh root@localhost -p 32768
root@localhost's password: my_new_password
Last login: Thu Dec 10 12:03:35 2020 from 172.17.0.1
root@pg_debian_ssh:~# 
```

### SSH method 2 (ssh keys only)

If you're more security concious, you can disable passwords altogether, and only allow ssh to connect via the ssh keys.

Disable password for root:

```bash
> docker exec pg_debian_ssh passwd -d root
```

Confirm that ssh via password no longer works:

```bash
> ssh root@localhost -p 32768             
  root@localhost's password: 
  Permission denied, please try again.
  root@localhost's password: 
```

Copy the local ssh keys to the container:

```bash
> docker cp ~/.ssh/id_rsa.pub pg_debian_ssh:/root/.ssh/authorized_keys
```

Change to ownership of the keys to root:

```bash
> docker exec pg_debian_ssh chown root:root /root/.ssh/authorized_keys
```

Now ssh works without a password, enabled only for your local machine with the corresponding ssh keys:

```bash
> ssh root@localhost -p 32768                                         
  Last login: Thu Dec 10 12:12:13 2020 from 172.17.0.1
  root@pg_debian_ssh:~# 
```

---