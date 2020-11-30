import axios from "axios";

const headerConfig = {
  header: {
    Authorization: `Bearer ${localStorage.getItem("token")}`,
  },
};

const BASE_URL = process.env.VUE_APP_BASE_URL;

const GET = (path) => {
  return axios.get(BASE_URL + path, headerConfig);
};

const POST = (path, body) => {
  return axios.post(BASE_URL + path, body, headerConfig);
};

const PATCH = (path, body) => {
  return axios.patch(BASE_URL + path, body, headerConfig);
};

const PUT = (path, body) => {
  return axios.put(BASE_URL + path, body, headerConfig);
};

const DELETE = (path) => {
  return axios.delete(BASE_URL + path, headerConfig);
};

export default { GET, POST, PATCH, PUT, DELETE };
