<div align="left">

<h1>Epilog<img src='https://user-images.githubusercontent.com/30027932/137415294-289f24ae-486b-421f-bf19-99c79a99d501.png' align='right' width='128' height='128'></h1>


<strong>>> <i>Dead simple container log aggregation with ELK stack</i> <<</strong>


</div>

![python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![elasticsearch](https://img.shields.io/badge/Elastic_Search-005571?style=for-the-badge&logo=elasticsearch&logoColor=white)
![kibana](https://img.shields.io/badge/Kibana-005571?style=for-the-badge&logo=Kibana&logoColor=white)
![kibana](https://img.shields.io/badge/Docker-2CA5E0?style=for-the-badge&logo=docker&logoColor=white)
![github_actions](https://img.shields.io/badge/GitHub_Actions-2088FF?style=for-the-badge&logo=github-actions&logoColor=white)
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

* Asynchronous log-aggregation pipeline that's completely decoupled from the app instances generating the logs.

* Zero effect on performance if the app instances aren't doing expensive synchronous logging operations internally.

* Horizontal scaling is achievable by adding more nodes to the Elasticsearch cluster.

* To keep the storage requirements at bay, log messages are automatically deleted after 7 days. This is configurable.

* Synchronization during container startup to reduce the number of missing logs.

* All the Log messages can be filtered and queried interactively from a centralized location via the Kibana dashboard.


## Architecture

This workflow leverages Filebeat to collect the logs, Elasticsearch to store and query the log messages, and Kibana to visualize the data interactively. The following diagram explains how logs flow from your application containers and becomes queryable in the Kibana dashboards:

![epilog_arch](https://user-images.githubusercontent.com/30027932/137414620-b32c09e3-6c11-4020-847b-5ea0e1222c33.png)

Here, the **Application** is a dockerized Python module that continuously sends log messages to the standard output.

On a Unix machine, Docker containers save these log messages in the `/var/lib/docker/containers/*/*.log` directory. In this directory, **Filebeat** listens for new log messages and sends them to **Elasticsearch** in batches. This makes the entire logging workflow asynchronous as Filebeat isn't coupled with the application and is lightweight enough to be deployed with every instance of your application.

The log consumer can make query requests via the **Kibana** dashboards and interactively search and filter the relevant log messages. The **Caddy** reverse proxy server is helpful during local development as you won't have to memorize the ports to access Elasticsearch and Kibana. You can also choose to use Caddy instead of Ngnix as a reverse proxy and load balancer in your production orchestration.


## Installation

* Make sure you have [Docker](https://www.docker.com/), [Docker compose V2](https://docs.docker.com/compose/cli-command/) installed on your system.

* Clone the repo.

* Go to the root directory and run:

    ```
    make up
    ```
    This will spin up 2 Elasticsearch nodes, 1 Filebeat instance, 1 log emitting app instance, and the reverse proxy server.

* To shut down everything gracefully, run:

    ```
    make down
    ```

* To kill the container processes and clean up all the volumes, run:

    ```
    make kill && make clean
    ```

## Exploration

Once you've run the `make up` command:

* To access the Kibana dashboard, go to `https://kibana.localhost`. Since our reverse proxy adds SSL to the localhost, your browser will complain about the site being unsafe. Just ignore it and move past.

* When prompted for credentials, use `elastic` as username and `debian` as password. You can configure this in the `.env` file.

* Once you're inside the Kibana dashboard, head over to the Logs panel under the Observability section on the left panel.

    ![kibana_1](https://user-images.githubusercontent.com/30027932/137523508-9a201267-ab61-4678-a4a0-dc0e7505d773.png)

* You can filter the logs by container name. Once you start typing `container.name` literally, Kibana will give you suggestions based on the names of the containers running on your machine.


    ![kibana_2](https://user-images.githubusercontent.com/30027932/137524544-3f1d83a6-c6ed-4fca-957f-223ca6c378b6.png)
    )

* Another filter you might want to explore is filtering by hostname. To do so, type `host.name` and it'll show the available host identifiers in a dropdown. In this case, all the containers live in the same host. So there's only one available host to filter by. These filters are defined in the `processors` segment of the `filebeat.yml` file. You can find a comprehensive list of `processors` [here](https://www.elastic.co/guide/en/beats/filebeat/current/defining-processors.html).

    ![kibana_3](https://user-images.githubusercontent.com/30027932/137534100-c1bea3dd-d580-4db2-9dcf-0138edb7e10d.png)


## Maintenance & Extensibility

* If you need log transformation, adding Logstash to this stack is quite easy. All you'll have to do is add a Logstash instance to the docker-compose.yml file and point Filebeat to send the logs to Logstash instead of Elasticsearch. Logstash will then transform the logs and save them in the Elasticsearch search cluster.

* To scale up the Elasticsearch cluster, you can follow the configuration of `es02` node in the docker-compose file. More nodes can be added similarly to achieve horizontal scaling.

* In a production setup, your app will most likely live in separate hosts than the Elasticsearch clusters. In that case, a Filebeat instance should live with every instance of the log generating app and these will send the logs to a centralized location—directly to Elasticsearch or first to Logstash and then to Elasticsearch clusters—depending on your need.

## Disclaimer

* This setup only employs a rudimentary password-based authentication system. You should add TLS encryption to your production ELK stack. [Here's](https://www.elastic.co/guide/en/elasticsearch/reference/current/configuring-tls-docker.html) an example of how you might be able to do so.

* For demonstration purposes, this repository has `.env` file in the root directory. In your production application, you should never add the `.env` files to your version control system.

## Resources

* [ELK: Delete old logging data using the Index Lifecycle Management](http://blog.ehrnhoefer.com/2019-05-04-elasticsearch-index-lifecycle-management/)


<div align="center">
<i> ✨ 🍰 ✨ </i>
</div>
