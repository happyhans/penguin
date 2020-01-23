import React, { useState } from 'react';
import { useHistory } from "react-router-dom";

const FORGOT_PASSWORD_FORM = Symbol('Show the forgot password form.');
const CHECK_YOUR_EMAIL = Symbol('Show the "check your email" view.');

function ForgotPassword() {
    const [email, setEmail] = useState('');
    const [pageState, setPageState] = useState(FORGOT_PASSWORD_FORM);
    const history = useHistory();

    async function handleForgotPassword(event) {
        event.preventDefault();

        const response = await fetch('localhost:3000/forgot_password', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json;charset=utf-8'
            },
            body: JSON.stringify({ email })
        });

        if(response.status === 200) {
            setPageState(CHECK_YOUR_EMAIL);
        }
    }

    function handleContinue(event) {
        history.push("/sign_in");
    }

    function renderForgotPasswordForm() {
        return (
            <form onSubmit={handleForgotPassword}>
                <label>
                    Email:
                    <input type="email" value={email} onChange={event => setEmail(event.target.value)} />
                </label>
    
                <input type="submit" value="Forgot Password" />
            </form>
        );
    }

    function renderCheckYourEmail() {
        function censorEmail(email) {
            const simpleEmailRegex = /(.+)@(.+)\.(.+)/;
            const matches = email.matches(simpleEmailRegex);
            
            if(matches.length === 4) {
                const censoredEmail = matches[1][0] + "*".repeat(matches[1].length - 1) +
                    '@' + matches[2][0] + "*".repeat(matches[2].length - 1) + '.' +
                    matches[3][0] + "*".repeat(matches[3].length - 1);
                return censoredEmail;
            } else {
                return email;
            }
        }

        return (
            <div>
                <h1>Check your email</h1>
                <p>
                    We've sent instructions on how to change your password to the following email addresses:
                    <br/>
                    {censorEmail(email)}
                </p>
                <button onClick={handleContinue}>Continue</button>
            </div>
        );
    }

    switch(pageState) {
        case FORGOT_PASSWORD_FORM:
            return renderForgotPasswordForm();
        case CHECK_YOUR_EMAIL:
            return renderCheckYourEmail();
        default:
            return renderForgotPasswordForm();
    }
}

export default ForgotPassword;