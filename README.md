<div align="center">

![logo](https://user-images.githubusercontent.com/30027932/136864286-6b69a63d-2023-4cde-b769-fb69de6712c8.png)

<strong>>> <i>Dead simple container log aggregation with ELK stack</i> <<</strong>

&nbsp;

</div>



## Preface

Epilog aims to demonstrate a language agnostic, non-invasive, and straigtforward way to add centralized logging to your stack. Centralized logging can be difficult depending on how much control you need over the log messages, how robust you need the logging system to be, and how you want to display the data to the consumer.

Invasive logging usually entails you having to build a logging pipeline and integrate that into your application. Adding extensive logging workflow directly into you application is non-trivial for a few reasons:

* The workflow becomes language specific and hard to scale as your application gets  decentralized over time and starts to take advantage of multiple languages.

* The logging pipeline gets tightly coupled with the application code.

* Extensive logging in a blocking manner can significantly hurt the performance of the application.

* Doing logging in a non-blocking state is difficult and usually requires non-trivial amount application code changes when the logging requirements change.

This repository lays out a dead-simple but an extensible centralized logging workflow that collects logs from docker containers in a non-invasive manner. It leverages Filebeat to collect the logs, Elasticsearch to store and query the log messages, and Kibana to visualize the data interactively.

## Architecture

Under construction...

## Installation

* Make sure you have Docker, Docker compose V2 installed on you system.
* Clone the repo.
* Go to the root directory and run:

    ```
    docker compose up -d
    ```
## Exploration

* To access the Kibana dashboard, go to: `https://kibana.localhost`.

* Since our reverse proxy adds SSL to the localhost, your browser will complain about the site being unsafe. Just ignore that and move past that.

* When prompted, use `elastic` as username and `debian` as password.

<div align="center">
<i> ✨ 🍰 ✨ </i>
</div>
