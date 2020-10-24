---
layout: page
permalink: /publications/
title: Publications
index: 2

description: The publications are listed in reversed chronological order.
years: [2020, 2019, 2018, 2017]
nav: true
---

<div class="publications">

{% for y in page.years %}
  <h2 class="year">{{y}}</h2>
  {% bibliography -f papers -q @*[year={{y}}]* %}
{% endfor %}

</div>
