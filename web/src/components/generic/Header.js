import React from 'react';
import { Link } from "react-router-dom";

function Header(props) {
    return (
        <header className="header">
            <nav className="nav">
                <ul>
                    <li>
                        <Link to="play">Play</Link>
                    </li>
                    <li>
                        <Link to="discover">Discover</Link>
                    </li>
                    <li>
                        <Link to="support">Support</Link>
                    </li>
                </ul>

                <ul>
                    <li>
                        <Link to="sign_in">Sign in</Link>
                    </li>
                    <li>
                        <Link to="sign_up">Sign up</Link>
                    </li>
                </ul>
            </nav>
        </header>
    );
}

export default Header;