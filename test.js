#!/usr/bin node

const mysql = require("mysql2");
const faker = require("@faker-js/faker").default;
const dayjs = require("dayjs");
const DB_URI = `mysql://root:123456@localhost/headfirst`;
const db = mysql.createConnection(
  `${DB_URI}?debug=false&charset=utf8mb4&timezone=Z`
);
const _ = require("lodash");

const events = require("events");
const EVT_CREATE_USERS = Symbol();

const eventEmitter = new events.EventEmitter();

const transformQueryValue = (v) => {
  return v;
};

const transformObjectValue = (c, object) => {
  return Object.values(object)
    .map((v) => transformQueryValue(c.escape(v)))
    .join(", ");
};

const insertQuery = (c, table, object) => {
  const keys = Object.keys(object).join(", ");
  const values = transformObjectValue(c, object);
  return `INSERT INTO ${table} (${keys}) VALUES (${values})`;
};

const insertQueryBatch = (c, table, objects) => {
  const keys = Object.keys(objects[0]).join(", ");
  const values = objects
    .map((o) => Object.values(o))
    .map((o) => `(${transformObjectValue(c, o)})`)
    .join(",");
  return `INSERT INTO ${table} (${keys}) VALUES ${values}`;
};

const randomUser = (suffix) => {
  const userType = ["admin", "member"];
  const userStatus = ["pending", "active", "inactive"];
  return {
    login: faker.internet.userName() + suffix,
    password: faker.internet.password(),
    email: faker.internet.email() + suffix,
    first_name: faker.name.firstName(),
    last_name: faker.name.lastName(),
    type: userType[Math.floor(Math.random() * userType.length)],
    status: userStatus[Math.floor(Math.random() * userStatus.length)],
    created_at: dayjs().format(),
    updated_at: dayjs().format(),
    is_super_admin: Math.floor(Math.random() * 100) % 17 === 0,
  };
};
const randomUsers = (steps, offset) => {
  const users = [];
  for (let i = 0; i < steps; i++) {
    users.push(randomUser(offset + i + 1));
  }
  return users;
};
const executeQuery = (db, query) => {
  return new Promise((resolve, reject) => {
    db.query(query, (err, result) => {
      if (err) {
        console.error(err);
        return reject(err);
      }
      resolve(result);
    });
  });
};

(() => {
  db.connect(async (error) => {
    if (error) throw error;
    const N_USERS = 1e6; // 1 million records
    const STEPS = 100;
    await executeQuery(db, "TRUNCATE phpguru_users;");
    // insert
    const createUsers = (...args) => {
      const offset = args[0];
      const steps = args[1];
      const users = randomUsers(steps, offset);
      const query = insertQueryBatch(db, "phpguru_users", users);
      executeQuery(db, query).then(
        (res) => {
          console.log(`${offset}/${N_USERS}`);
          console.log(res);
          if (offset < N_USERS - steps) {
            eventEmitter.emit(EVT_CREATE_USERS, offset + steps, steps);
          }
        },
        (error) => {
          // stop
          console.error(error);
        }
      );
    };

    eventEmitter.on(EVT_CREATE_USERS, createUsers);

    eventEmitter.emit(EVT_CREATE_USERS, 0, STEPS);

    // for (let i = 0; i < N_USERS; i += STEPS) {
    //   const users = randomUsers(STEPS);
    //   const query = insertQueryBatch("phpguru_users", users);
    //   await executeQuery(db, query);
    //   console.log(`${i + STEPS}/${N_USERS}`);
    //   // count
    //   const count = await executeQuery(
    //     db,
    //     "SELECT COUNT(id) FROM headfirst.phpguru_users;"
    //   );
    //   await new Promise((resolve) => {
    //     setTimeout(() => resolve(true), 300);
    //   });
    //   console.log(count);
    // }
  });
})();
