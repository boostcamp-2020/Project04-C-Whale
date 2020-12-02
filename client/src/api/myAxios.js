import axios from "axios";

const getToken = () => localStorage.getItem("token");

const headerConfig = () => {
  return {
    headers: {
      Authorization: "Bearer " + getToken(),
    },
  };
};

const SERVER_URL = process.env.VUE_APP_SERVER_URL + "/api";

const myAxios = {
  GET: (path) => {
    return axios.get(SERVER_URL + path, headerConfig());
  },
  POST: (path, body) => {
    return axios.post(SERVER_URL + path, body, headerConfig());
  },
  PATCH: (path, body) => {
    return axios.patch(SERVER_URL + path, body, headerConfig());
  },
  PUT: (path, body) => {
    return axios.put(SERVER_URL + path, body, headerConfig());
  },
  DELETE: (path) => {
    return axios.delete(SERVER_URL + path, headerConfig());
  },
};

export default myAxios;
