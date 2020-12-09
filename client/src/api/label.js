import myAxios from "./myAxios";

const labelAPI = {
  getLabels() {
    return myAxios.get("/label");
  },
};

export default labelAPI;
