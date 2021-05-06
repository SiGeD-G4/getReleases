const axios = require('axios')
const fs = require('fs')
//require('dotenv').config()

const { SONAR_URL } = require('./consts.js')

const { REPO, TAG } = process.env

const generateFilename = () => {
  // fga-eps-mds-2020_2-NOME_PROJETO-DATA_RELEASE
  const date = new Date ()
  //return 'fga-eps-mds-' + REPO + '-' + date + '_' + TAG + '.json'
  return 'fga-eps-mds-' + REPO + '-date_' + TAG + '.json'
}

const saveSonarFile = (filename) => {
  axios.get(SONAR_URL)
    .then(async (res) => {
      await fs.writeFileSync(`/root/getReleases/analytics-raw-data/${filename}`, JSON.stringify(res.data))
    })
}

const script = () => {
  console.log(REPO, TAG)
  const filename = generateFilename()
  saveSonarFile(filename)
}

script()
