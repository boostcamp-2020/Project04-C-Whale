import myAxios from "./myAxios";

const userAPI = {
  authorize() {
    return myAxios.GET("/user/me");
  },
};

export default userAPI;
