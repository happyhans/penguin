import React, { useState } from 'react';

const SIGN_UP_FORM = Symbol('Show the sign up form.');
const SIGN_UP_SUCCESS = Symbol('Show the sign up success view.');

function SignUp() {
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    const [pageState, setPageState] = useState(SIGN_UP_FORM);

    async function handleSignUp(event) {
        event.preventDefault();

        const response = await fetch('localhost:3000/sign_up', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json;charset=utf-8'
            },
            body: JSON.stringify({ email, password })
        });

        if(response.status === 201) {
            setPageState(SIGN_UP_SUCCESS);
        }
    }

    async function handleResendActivationEmail(event) {
        event.preventDefault();

        const response = await fetch('localhost:3000/resend_activation_email', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json;charset=utf-8'
            },
            body: JSON.stringify({ email })
        });
    }

    function renderSignUpForm() {
        return (
            <form onSubmit={handleSignUp}>
                <label>
                    Email:
                    <input type="email" value={email} onChange={event => setEmail(event.target.value)} />
                </label>
                <label>
                    Password:
                    <input type="password" value={password} onChange={event => setPassword(event.target.value)} />
                </label>
                <input type="submit" value="Sign up" />
            </form>
        );
    }

    function renderSignUpSuccess() {
        return (
            <div>
                <p>You have successfully signed up for a Penguin account. Activate your account by following the instructions provided in the email sent to {email}. Happy beatmaking!</p>
                <form onSubmit={handleResendActivationEmail}>
                    <input type="submit" value="Resend Activation Email" />
                </form>
            </div>
        );
    }

    switch(pageState) {
        case SIGN_UP_FORM:
            return renderSignUpForm();
        case SIGN_UP_SUCCESS:
            return renderSignUpSuccess();
        default:
            return renderSignUpForm();
    }
}

export default SignUp;