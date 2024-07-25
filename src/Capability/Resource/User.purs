module Loja.Capability.Resource.User where

import Prelude

import Control.Monad.Cont (lift)
import Data.Maybe (Maybe)
import Halogen (HalogenM)
import Loja.Data.Email (Email)
import Loja.Data.Profile (ProfileRep, Profile)

-- Tipo para fazer modificação no perfil.
type UpdateProfileFields =
  { email :: Email
  , password :: Maybe String
  | ProfileRep ()
  }

-- Implementa a capabilidade de gerenciar perfil de usuário.
class Monad m <= ManageUser m where
  loginUser :: { email :: Email, password :: Maybe String } -> m (Maybe Profile)
  registerUser :: { email :: Email, password :: Maybe String } -> m (Maybe Profile)
  getCurrentUser :: m (Maybe Profile)
  updateUser :: UpdateProfileFields -> m Unit

instance manageUserHalogenM :: ManageUser m => ManageUser (HalogenM st act slots msg m) where
  loginUser = lift <<< loginUser
  registerUser = lift <<< registerUser
  getCurrentUser = lift getCurrentUser
  updateUser = lift <<< updateUser
