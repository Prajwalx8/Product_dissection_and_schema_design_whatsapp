-- Users table
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,         -- unique user
    phone_number VARCHAR(15) UNIQUE,    -- login
    display_name VARCHAR(100),
    about TEXT,
    profile_image_url TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    last_seen_at TIMESTAMP,
    is_business_account BOOLEAN DEFAULT FALSE
);

-- Devices table
CREATE TABLE devices (
    device_id SERIAL PRIMARY KEY,       -- linked device
    user_id INT REFERENCES users(user_id),
    device_type VARCHAR(20),            -- mobile/web/desktop
    last_active_at TIMESTAMP,
    is_primary_device BOOLEAN DEFAULT FALSE
);

-- Chats table
CREATE TABLE chats (
    chat_id SERIAL PRIMARY KEY,         -- chat thread
    is_group BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Chat participants
CREATE TABLE chat_participants (
    id SERIAL PRIMARY KEY,
    chat_id INT REFERENCES chats(chat_id),
    user_id INT REFERENCES users(user_id),
    role VARCHAR(20) DEFAULT 'member',  -- admin/member
    joined_at TIMESTAMP DEFAULT NOW()
);

-- Messages
CREATE TABLE messages (
    message_id SERIAL PRIMARY KEY,
    chat_id INT REFERENCES chats(chat_id),
    sender_id INT REFERENCES users(user_id),
    message_type VARCHAR(20),           -- text/image/audio/etc.
    content TEXT,                       -- message text
    sent_at TIMESTAMP DEFAULT NOW(),
    status VARCHAR(20) DEFAULT 'sent',  -- sent/delivered/seen
    is_deleted BOOLEAN DEFAULT FALSE
);

-- Media files
CREATE TABLE media (
    media_id SERIAL PRIMARY KEY,
    message_id INT REFERENCES messages(message_id),
    media_url TEXT,                     -- file link
    media_type VARCHAR(20),             -- image/video etc.
    file_size BIGINT,
    uploaded_at TIMESTAMP DEFAULT NOW()
);

-- Status updates
CREATE TABLE status (
    status_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    status_type VARCHAR(20),            -- text/image/video
    content_url TEXT,
    caption TEXT,
    created_at TIMESTAMP DEFAULT NOW(),
    expires_at TIMESTAMP                -- auto delete
);

-- Status views
CREATE TABLE status_views (
    id SERIAL PRIMARY KEY,
    status_id INT REFERENCES status(status_id),
    viewer_id INT REFERENCES users(user_id),
    viewed_at TIMESTAMP DEFAULT NOW()
);

-- Call logs
CREATE TABLE call_logs (
    call_id SERIAL PRIMARY KEY,
    caller_id INT REFERENCES users(user_id),
    receiver_id INT REFERENCES users(user_id),
    call_type VARCHAR(20),              -- voice/video
    call_status VARCHAR(20),            -- missed/received
    duration_sec INT,
    started_at TIMESTAMP DEFAULT NOW()
);

-- Blocked users
CREATE TABLE blocked_contacts (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    blocked_user_id INT REFERENCES users(user_id),
    blocked_at TIMESTAMP DEFAULT NOW()
);
