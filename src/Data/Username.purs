module Loja.Data.Username
  ( Username
  , parse
  , toString
  , codec
  ) where

import Prelude

import Data.Codec.Argonaut (JsonCodec)
import Data.Codec.Argonaut as CA
import Data.Maybe (Maybe(..))
import Data.Profunctor (dimap)

-- Representação de username, nome de usuário.
newtype Username = Username String

derive instance eqUsername :: Eq Username
derive instance ordUsername :: Ord Username

codec :: JsonCodec Username
codec = dimap (\(Username user) -> user) Username CA.string

-- Faz a validação do username. Por enquanto valide apenas se
-- o campo está vazio.
parse :: String -> Maybe Username
parse "" = Nothing
parse str = Just (Username str)

toString :: Username -> String
toString (Username str) = str
