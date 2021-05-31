## onemap-api-demo

# Introduction
This repo contains some sample R and Python code snippets to be used with OneMap's API

# Contents
Demo includes:

1. How to display maps available on onemap (openlayers and WMTS formats)
2. How to call Rest APIS (Coordinates conversion and Search function)

# Notes
1. This code requires network access to onemap's api, either on an internet machine or on a GSIB with allowed access to onemap
2. WMTS map layers are in EPSG 3857 format. Although it is meant to work with ipyleaflet, the coordinates are not lat,long.
