# Minimal task module for the queue worker.

import os
import time


def reindex(document_id):
    return {"document": document_id, "status": "queued"}


def main():
    spool = os.environ.get("WORKER_SPOOL", "/var/lib/worker/spool")
    print("worker ready, spool is %s" % spool)
    while True:
        time.sleep(60)


if __name__ == "__main__":
    main()
