require('dotenv').config();

const config = {
  env: process.env.NODE_ENV || 'development',
  port: process.env.PORT || 3000,

  db: {
    host: process.env.DB_HOST || 'files-db.internal.example.com',
    port: process.env.DB_PORT || 3306,
    user: process.env.DB_USER || 'files_service',
    password: process.env.DB_PASSWORD || 'exposedPassword',
    database: process.env.DB_NAME || 'files'
  },

  jwt: {
    secret: process.env.JWT_SECRET || 'exposedPassword_jwt_signing_key'
  },

  aws: {
    accessKeyId: process.env.AWS_ACCESS_KEY_ID || 'AKIAIOSFODNN7EXAMPLE',
    secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY || 'wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY',
    region: process.env.AWS_REGION || 'us-east-1',
    bucket: process.env.S3_BUCKET || 'files-service-uploads'
  },

  filesBaseDir: process.env.FILES_BASE_DIR || './storage'
};

module.exports = config;
