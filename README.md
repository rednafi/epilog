<div align="center">

![logo](https://user-images.githubusercontent.com/30027932/136864286-6b69a63d-2023-4cde-b769-fb69de6712c8.png)

<strong>>> <i>Dead simple container log aggregation with ELK stack</i> <<</strong>

&nbsp;

</div>



## Preface

Epilog aims to demonstrate a language-agnostic, non-invasive, and straightforward way to add centralized logging to your stack. Centralized logging can be difficult depending on how much control you need over the log messages, how robust you need the logging system to be, and how you want to display the data to the consumer.

## Why?

Invasive logging usually entails you having to build a logging pipeline and integrate that into your application. Adding an extensive logging workflow directly to your application is non-trivial for a few reasons:

* The workflow becomes language-specific and hard to scale as your application gets decentralized over time and starts to take advantage of multiple languages.

* The logging pipeline gets tightly coupled with the application code.

* Extensive logging in a blocking manner can significantly hurt the performance of the application.

* Doing logging in a non-blocking state is difficult and usually requires a non-trivial amount of application code changes when the logging requirements change.

This repository lays out a dead-simple but extensible centralized logging workflow that collects logs from docker containers in a non-invasive manner. To achieve this, we've used the reliable ELK stack which is at this point, an industry standard.


## Features

• Asynchronous log-aggregation pipeline that's completely decoupled from the app instances generating the logs.

• Zero effect on performance if the app instances aren't doing expensive synchronous logging operations internally.

• Horizontal scaling is achievable by partitioning and replicating the Elasticsearch nodes.

• Too keep the storage requirements at bay, log messages are automatically deleted after 7 days. This is configurable.

• Synchronization during container startup to reduce the number of missing logs.

• All the Log messages can be filtered and queried interactively from a centralized location via Kibana dashboard.

## Architecture

This workflow leverages Filebeat to collect the logs, Elasticsearch to store and query the log messages, and Kibana to visualize the data interactively. The following diagram explains how logs flow from your application containers and becomes queryable in the Kibana dashboards:

![epilog_arch](https://user-images.githubusercontent.com/30027932/137157947-16f58852-5040-4a26-b5d4-b5a6e5ecc0d0.png)

Here, the **Application** is a dockerized Python module that continuously sends log messages to the standard output.

On a Unix machine, Docker containers save these log messages in the `/var/lib/docker/containers/*/*.log` directory. In this directory, **Filebeat** listens for new log messages and sends them to **Elasticsearch** in batches. This makes the entire logging workflow asynchronous as Filebeat isn't coupled with the application and is lightweight enough to be deployed with every instance of your application.

The log consumer can make query requests via the **Kibana** dashboards and interactively search and filter the relevant log messages. The **Caddy** reverse proxy server is helpful during local development as you won't have to memorize the ports to access Elasticsearch and Kibana. You can also choose to use Caddy instead of Ngnix as a reverse proxy and load balancer in your production orchestration.


## Directory Structure

Under construction...


## Installation

* Make sure you have Docker, Docker compose V2 installed on your system.
* Clone the repo.
* Go to the root directory and run:

    ```
    docker compose up -d
    ```
## Exploration

* To access the Kibana dashboard, go to: `https://kibana.localhost`.

* Since our reverse proxy adds SSL to the localhost, your browser will complain about the site being unsafe. Just ignore that and move past that.

* When prompted, use `elastic` as username and `debian` as password.

## Limitations

Under construction...


## Maintenance & Extensibility

**TODO:** Why not Logstash here? No transformation was done on the log messages, that's why.

Under construction...


## Resources

* [ELK: Delete old logging data using the Index Lifecycle Management](http://blog.ehrnhoefer.com/2019-05-04-elasticsearch-index-lifecycle-management/)


<div align="center">
<i> ✨ 🍰 ✨ </i>
</div>
