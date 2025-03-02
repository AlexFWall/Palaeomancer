---
layout: null
title: "Alex F Wall, PhD"
---

<style>
  /* Basic resets and body styling */
  body {
    margin: 0;
    padding: 0;
    background-color: #FFF9EC;
    color: #333;
    font-family: Arial, sans-serif;
  }

  /* Hero/header section */
  .hero {
    background-color: #58B62C;
    color: white;
    padding: 1em;
    text-align: left;
    position: relative;
  }
  .hero h1 {
    margin: 0;
  }

  /* Navigation bar */
  .nav {
    background-color: #333;
    text-align: left;
    padding: 0.5em 1em;
  }
  .nav a {
    margin: 0 15px;
    color: white;
    text-decoration: none;
  }

  /* Main container for content */
  .container {
    max-width: 1000px;
    margin: 1em auto;
    padding: 1em;
  }

  /* Responsive columns: single column on mobile, two columns on larger screens */
  .columns {
    display: flex;
    flex-direction: column;
    gap: 1em;
  }
  @media (min-width: 768px) {
    .columns {
      flex-direction: row;
    }
  }

  .left-col {
    flex: 2;
  }
  .right-col {
    flex: 1;
    position: relative;
  }

  /* Image styling */
  .profile-img {
    max-width: 100%;
    height: auto;
    display: block;
    margin: 0 auto;
  }

  /* Social links */
  .social-links {
    margin-top: 2em;
    text-align: center;
  }
  .social-links a {
    display: block;
    margin-bottom: 0.5em;
    color: #58B62C;
    text-decoration: none;
  }

  /* Iframe container for the map */
  .iframe-container {
    text-align: center;
    margin: 2em 0;
  }
  .iframe-container iframe {
    width: 100%;
    height: 600px;
    border: none;
  }
</style>

<div class="hero">
  <h1>Alex F Wall, PhD</h1>
</div>

<div class="nav">
  <a href="https://www.jcu.edu.au/college-of-science-and-engineering/vegemap">VegeMap</a>
  <a href="/Palaeomancer/_pages/cv.md">CV</a>
  <a href="/Palaeomancer/blog/">Blog</a>
</div>

<div class="container">
  <div class="columns">
    <div class="left-col">
      <p><strong>Palaeomancer</strong> (noun):<br>
      <em>pal·ae·o·man·cer</em> /ˈpæliˌoʊˌmænsər/</p>
      <p>
        1. A person who practices or is skilled in the interpretation of ancient records, 
        particularly those related to the earth's geological and climatic history.<br>
        2. An expert in deciphering historical environmental changes through the analysis 
        of fossilized remains, sediments, and other geological data.
      </p>
      <p>
        <em>Origin:</em> Latin <em>palaeo-</em> (from Greek <em>palaios</em>, meaning "ancient") + 
        <em>-mancer</em> (from Greek <em>manteia</em>, meaning "divination").
      </p>
    </div>
    <div class="right-col">
      <img src="AFWall ABC News.jpg" alt="Alex F. Wall" class="profile-img">
      <div class="social-links">
        <a href="https://www.linkedin.com/in/your-profile">LinkedIn</a>
        <a href="https://github.com/AlexFWall">GitHub</a>
        <a href="https://www.researchgate.net/profile/Your-Name">ResearchGate</a>
      </div>
    </div>
  </div>

  <div class="iframe-container">
    <iframe src="map.html"></iframe>
  </div>
</div>
