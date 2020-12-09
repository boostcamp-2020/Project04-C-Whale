import axios from "axios";
import bus from "@/utils/bus.js";

const baseURL = process.env.VUE_APP_SERVER_URL + "/api";
// axios intercept 전역 설정
const myAxios = axios.create({
  baseURL,
});

myAxios.interceptors.request.use((config) => {
  config.headers.Authorization = "Bearer " + localStorage.getItem("token");
  bus.$emit("start:spinner");
  return config;
});

myAxios.interceptors.response.use(
  (res) => {
    bus.$emit("end:spinner");
    return res;
  },
  (error) => {
    bus.$emit("end:spinner");
    return Promise.reject(error);
  }
);

export default myAxios;
