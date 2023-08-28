# powershell-scripts

This repository is the public container of the Powershell scripts that I've written.

## Description

I push varied of scripts if you find something useful, use it freely, or if you find anything that could have been done better, feel free to fork the repo and fix it. I'm an enthusiastic tech guy who enjoys scripting and logical challenges. Do not expect too much from this project however, I have the hope that someone could find something useful here.

## Contribution

If you want to contribute, please follow the patterns of how I'm creating the functions and using variables.

**And of course, a huge high five for your support in advance! 😉**

## Snippets

They are what they are, snippets. Only a few lines of code perform specific tasks, usually really short tasks or a portion of a larger script. I try to keep the filenames lucid and the file itself should contain the description, thus they won't have readme.

## Scripts

Usually medium size (50-300 lines)  scripts which perform specific tasks.

### Legend

|Letter|Meaning|
|-----|--------|
|R|Reporting|
|T|Tool|
|RT|Reporting & Tool|

These are the main indicators of the behavior of the scripts. The **R** generates a report and **does not make any changes**. Scripts with **T** perform a certain task and modify data. The mixed **RT** scripts capable of doing both actions, usually tasks that need to be verified before being performed.

## Recursive subordinates finder - R-RecursiveSubordinateFinder.ps1

This script queries all the users from the hierarchy tree starting from a given manager all the way down.
