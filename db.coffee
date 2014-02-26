module.exports = ->

  mongoose = require('mongoose')
  mongoose.connect "mongodb://" + process.env.MONGODB_USERNAME + ":" + process.env.MONGODB_PASSWORD + "@ds027729.mongolab.com:27729/bitcoin"

  Schema = mongoose.Schema
  secondSchema = new Schema(
    timestamp:
      type: Date
      index: true

    last: Number
    bid: Number
    ask: Number
  ,
    capped:
      size: 52428800
  )
  minuteSchema = new Schema(
    timestamp:
      type: Date
      index: true

    last: Number
    bid: Number
    ask: Number
  ,
    capped:
      size: 52428800
  )

  # strict: false,
  hourSchema = new Schema(
    timestamp:
      type: Date
      index: true

    last: Number
    bid: Number
    ask: Number
  ,
    capped:
      size: 52428800
  )

  # strict: false,
  daySchema = new Schema(
    timestamp:
      type: Date
      index: true

    last: Number
    bid: Number
    ask: Number
    high: Number
    low: Number
    volume: Number
  ,
    capped:
      size: 52428800
  )

  # strict: false,
  secondModel : mongoose.model("secondModel", secondSchema)
  minuteModel : mongoose.model("minuteModel", minuteSchema)
  hourModel : mongoose.model("hourModel", hourSchema)
  dayModel : mongoose.model("dayModel", daySchema)


