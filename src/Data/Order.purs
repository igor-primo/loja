module Loja.Data.Order where

import Data.Bounded (class Ord)
import Data.Codec.Argonaut (JsonCodec)
import Data.Codec.Argonaut as CA
import Data.Codec.Argonaut.Record as CAR
import Data.Eq (class Eq)
import Data.Newtype (class Newtype)
import Data.PreciseDateTime (PreciseDateTime)
import Data.Profunctor (wrapIso)
import Loja.Data.PreciseDateTime as PDT

newtype Total = Total String

derive instance newtypeTotal :: Newtype Total _
derive instance eqTotal :: Eq Total
derive instance ordTotal :: Ord Total

newtype OrderId = OrderId Int

derive instance newtypeOrderId :: Newtype OrderId _
derive instance eqOrderId :: Eq OrderId
derive instance ordOrderId :: Ord OrderId

type Order =
  { orderId :: OrderId
  , date :: PreciseDateTime
  , delivered :: Boolean
  , total :: Total
  , numItems :: Int
  }

orderCodec :: JsonCodec Order
orderCodec =
  CAR.object "Order"
    { orderId: wrapIso OrderId CA.int
    , date: PDT.codec
    , delivered: CA.boolean
    , total: wrapIso Total CA.string
    , numItems: CA.int
    }
