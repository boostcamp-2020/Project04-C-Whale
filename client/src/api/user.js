import myAxios from "./myAxios";

const userAPI = {
  authorize() {
    return myAxios.get("/user/me");
  },
};

export default userAPI;
