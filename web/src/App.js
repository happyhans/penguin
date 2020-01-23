import React from 'react';
import {
  BrowserRouter as Router,
  Switch,
  Route
} from "react-router-dom";

import Header from './components/generic/Header';
import SignUp from './components/Pages/Sign Up/SignUp';
import SignIn from './components/Pages/Sign In/SignIn';
import ForgotPassword from './components/Pages/Forgot Password/ForgotPassword';
import ResetPassword from './components/Pages/Reset Password/ResetPassword';

function App() {
  return (
    <Router>
      <div>
        <Header />
        <Switch>
            <Route path="/sign_up">
              <SignUp />
            </Route>
            <Route path="/sign_in">
              <SignIn />
            </Route>
            <Route path="/forgot_password">
              <ForgotPassword />
            </Route>
            <Route path="/reset_password/:token">
              <ResetPassword />
            </Route>
        </Switch>
      </div>
    </Router>
  );
}

export default App;
