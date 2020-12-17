import axios from "axios";
import bus from "@/utils/bus.js";

const baseURL = process.env.VUE_APP_SERVER_URL + "/api";
// axios intercept 전역 설정
const myAxios = axios.create({
  baseURL,
});

myAxios.interceptors.request.use((config) => {
  config.headers.Authorization = "Bearer " + localStorage.getItem("token");
  return config;
});

export default myAxios;
