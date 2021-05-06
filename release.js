let { Octokit } = require("@octokit/core")
const ghReleaseAssets = require('gh-release-assets')
const axios = require('axios')
const fs = require('fs')
const moment = require('moment')

require('dotenv').config()

const {
  SONAR_URL,
  REPO,
  OWNER, 
  TAG
  } = require('./consts.js')

const { TOKEN, RELEASE_MINOR } = process.env;

const octokit = new Octokit({ auth: TOKEN});

const getLatestRelease = async () => {
  const releases = await octokit.request('GET /repos/{owner}/{repo}/releases/tags/{tag}', {
    owner: OWNER,
    repo: REPO,
    tag: TAG
  })
  return releases.data[0]
}

const generateFilename = () => {
  const date_str = await getLatestRelease().created_at
  let date = moment(date_str).format('DD/MM/YYYY');
  // fga-eps-mds-2020_2-NOME_PROJETO-DATA_RELEASE
  return 'fga-eps-mds-2020_2-' + REPO + '-' + date + '_' + TAG + '.json'
}

const saveSonarFile = async (filename) => {
  await axios.get(SONAR_URL)
    .then((res) => {
      fs.writeFileSync(`~/getReleases/analytics-raw-data/${filename}`, JSON.stringify(res.data))
    })
}



const script = async () => {
  const filename = generateFilename()
  await saveSonarFile(filename)
}

script()