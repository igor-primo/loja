module Loja.Capability.Navigate where

import Prelude

import Control.Monad.Trans.Class (lift)
import Loja.Data.Route (Route)
import Halogen (HalogenM)

-- Capabilidade que representa a habilidade do usuário mover-se pela
-- aplicação.
class Monad m <= Navigate m where
  navigate :: Route -> m Unit
  logout :: m Unit

-- Essa instância serve como wrapper sobre a função lift, para que possamos
-- utilizar essas funções dentro de componentes Halogen.
instance navigateHalogenM :: Navigate m => Navigate (HalogenM st act slots msg m) where
  navigate = lift <<< navigate
  logout = lift logout
