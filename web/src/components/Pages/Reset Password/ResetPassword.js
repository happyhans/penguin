import React, { useState } from 'react';
import { useHistory, useParams } from "react-router-dom";

function ResetPassword() {
    const [password, setPassword] = useState('');
    const [passwordConfirmation, setPasswordConfirmation] = useState('');
    const history = useHistory();
    const { token : resetPasswordToken } = useParams();

    async function handleResetPassword(event) {
        event.preventDefault();

        const response = await fetch(`localhost:3000/reset_password/${resetPasswordToken}`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json;charset=utf-8'
            },
            body: JSON.stringify({ password, password_confirmation: passwordConfirmation })
        });

        if(response.status === 200) {
            // The user should appear to be signed in once password is reset. There should also
            // be a positive indication (e.g Toast or Bootstrap-style Alert) that the user's
            // password has been reset and they are now signed in.
            history.push("/");
        }
    }

    return (
        <form onSubmit={handleResetPassword}>
            <label>
                Password:
                <input type="password" value={password} onChange={event => setPassword(event.target.value)} />
            </label>

            <label>
                Confirm Password:
                <input type="password" value={passwordConfirmation} onChange={event => setPasswordConfirmation(event.target.value)} />
            </label>

            <input type="submit" value="Reset Password" />
        </form>
    );
}

export default ResetPassword;