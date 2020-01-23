import React, { useState } from 'react';
import { Link } from "react-router-dom";
import { useHistory } from "react-router-dom";

function SignIn() {
    const history = useHistory();
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');

    async function handleSignIn(event) {
        event.preventDefault();

        const response = await fetch('localhost:3000/sign_in', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json;charset=utf-8'
            },
            body: JSON.stringify({ email, password })
        });

        if(response.status === 200) {
            history.push("/");
        }
    }

    return (
        <div>
            <form onSubmit={handleSignIn}>
                <label>
                    Email:
                    <input type="email" value={email} onChange={event => setEmail(event.target.value)} />
                </label>
                <label>
                    Password:
                    <input type="password" value={password} onChange={event => setPassword(event.target.value)} />
                </label>
                <input type="submit" value="Sign in" />
            </form>

            <Link to="/forgot_password">Forgot your password?</Link>
        </div>
    );
}

export default SignIn;