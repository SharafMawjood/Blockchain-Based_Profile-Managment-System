import React, { useState, useEffect } from 'react';
import axios from 'axios';

const UserProfile = ({ userId }) => {
    const [userProfile, setUserProfile] = useState({});

    useEffect(() => {
        axios.get(`/api/profile/${userId}/`)
            .then(response => {
                setUserProfile(response.data);
            })
            .catch(error => {
                console.error('Error fetching profile data: ', error);
            });
    }, [userId]);

    return (
        <div>
            <h1>User Profile</h1>
            <p>ID: {userProfile.id}</p>
            <p>Name: {userProfile.name}</p>
            <p>Date of Birth: {userProfile.date_of_birth}</p>
            <p>Address: {userProfile.address}</p>
            <img src={userProfile.image} alt="User" />  {/* Show image */}
            <p>Contact Numbers: </p>
            <ul>
                {/* Iterate over contact numbers */}
                {userProfile.contact_numbers && userProfile.contact_numbers.map((number, index) => (
                    <li key={index}>{number}</li>
                ))}
            </ul>
        </div>
    );
};


export default UserProfile;
