module Loja.Data.Profile where

import Data.Codec.Argonaut (JsonCodec)
import Data.Codec.Argonaut as CA
import Data.Codec.Argonaut.Compat as CAC
import Data.Codec.Argonaut.Record as CAR
import Data.Maybe (Maybe)
import Loja.Data.Email (Email)
import Loja.Data.Email as Email
import Loja.Data.Username (Username)
import Loja.Data.Username as Username

-- Tipo para representar um perfil.
-- Utilizamos um row type porque ora queremos utilizar um valor desse
-- registro contendo a senha, ora não.
type ProfileRep row =
  ( username :: Username
  , email :: Email
  | row
  )

type Profile = { | ProfileRep () }

type ProfileWithPassword = { | ProfileRep (password :: Maybe String) }

-- Serialização.
profileCodec :: JsonCodec Profile
profileCodec =
  CAR.object "Profile"
    { username: Username.codec
    , email: Email.codec
    }

profileWithPasswordCodec :: JsonCodec ProfileWithPassword
profileWithPasswordCodec =
  CAR.object "Profile"
    { username: Username.codec
    , email: Email.codec
    , password: CAC.maybe CA.string
    }
