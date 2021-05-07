const axios = require('axios')
const fs = require('fs')
const moment = require('moment')
const { Octokit } = require("@octokit/core")

const { SONAR_URL } = require('./consts.js')

const { REPO, TAG } = process.env

const octokit = new Octokit();

const getReleaseDate = async () => {
  try {
    const releases = await octokit.request('GET /repos/{owner}/{repo}/releases/tags/{tag}', {
      owner: 'fga-eps-mds',
      repo: REPO,
      tag: TAG
    })
    return moment(releases.data.created_at).format('DD-MM-YYYY')
  } catch (err) {
    console.log(`ERROR ON GETTING RELEASE ${TAG} DATE`)
    console.log(err)
    return 'date'
  }
}

const generateFilename = async () => {
  // fga-eps-mds-2020_2-NOME_PROJETO-DATA_RELEASE
  const date = await getReleaseDate()
  return 'fga-eps-mds-' + REPO + '-' + date + '_' + TAG + '.json'
  // return 'fga-eps-mds-' + REPO + '-date_' + TAG + '.json'
}

const saveSonarFile = (filename) => {
  axios.get(SONAR_URL)
    .then(async (res) => {
      await fs.writeFileSync(`/root/getReleases/analytics-raw-data/${filename}`, JSON.stringify(res.data))
      // await fs.writeFileSync(`/root/teste/${filename}`, JSON.stringify(res.data))
    })
    .catch((err) => {
      console.log(`ERROR ON SAVING FILE ${filename}`)
      console.log(err)
    })
}

const script = async () => {
  console.log(REPO, TAG)
  const filename = await generateFilename()
  saveSonarFile(filename)
}

script()
