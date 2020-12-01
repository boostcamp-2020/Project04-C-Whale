import axios from "axios";

const headerConfig = {
  headers: {
    Authorization: `Bearer ${localStorage.getItem("token")}`,
  },
};

const BASE_URL = process.env.VUE_APP_SERVER_URL;

const myAxios = {
  GET: (path) => {
    return axios.get(BASE_URL + path, headerConfig);
  },
  POST: (path, body) => {
    return axios.post(BASE_URL + path, body, headerConfig);
  },
  PATCH: (path, body) => {
    return axios.patch(BASE_URL + path, body, headerConfig);
  },
  PUT: (path, body) => {
    return axios.put(BASE_URL + path, body, headerConfig);
  },
  DELETE: (path) => {
    return axios.delete(BASE_URL + path, headerConfig);
  },
};

export default myAxios;
