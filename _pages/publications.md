---
layout: page
permalink: /publications/
title: Publications
index: 2

description: The publications are listed in reversed chronological order.
years: [2023, 2022, 2021, 2020, 2019, 2018, 2017]
nav: true
---

For the complete list of publications, check my [Google Scholar](https://scholar.google.gr/citations?user=nP81eYkAAAAJ&hl=el&authuser=1) or [Semantic Scholar](https://www.semanticscholar.org/author/Christos-Baziotis/40928701?sort=total-citations) profile.

<div class="publications">

{% for y in page.years %}
  <h2 class="year">{{y}}</h2>
  {% bibliography -f papers -q @*[year={{y}}]* %}
{% endfor %}

</div>
