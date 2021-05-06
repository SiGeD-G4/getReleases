require('dotenv').config()
const { REPO, TAG } = process.env
const OWNER = 'SiGeD-G4';
const SONAR_ID = `SiGeD-G4_${REPO}`;
const SONAR_URL = `https://sonarcloud.io/api/measures/component_tree?component=${SONAR_ID}&metricKeys=files,functions,complexity,coverage,ncloc,comment_lines_density,duplicated_lines_density,security_rating,tests,test_success_density,test_execution_time,reliability_rating&ps=500`;

module.exports = {
  SONAR_URL,
  REPO,
  OWNER,
  TAG
}