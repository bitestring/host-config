# Syncthing

## Step 1: Create a volume to store Syncthing config files

```
mkdir --parents ./volumes/config/
```

## Step 2: Create .env file

Create a .env file which points to the host directory to be shared over Syncthing

```
nano .env
```

**Example .env file:**

```
HOST_DIR=<EXAMPLE>
MOUNT_POINT=/mnt/<EXAMPLE>
```

## Step 3: Launch Syncthing

```
make up
```
