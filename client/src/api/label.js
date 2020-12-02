import myAxios from "./myAxios";

const labelAPI = {
  getLabels() {
    return myAxios.GET("/label");
  },
};

export default labelAPI;
