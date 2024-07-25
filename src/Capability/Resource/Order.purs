module Loja.Capability.Order where

import Prelude

import Control.Monad.Cont (lift)
import Data.Maybe (Maybe)
import Halogen (HalogenM)
import Loja.Data.Order (Order)

class Monad m <= ManageOrder m where
  getOrders :: m (Maybe Order)

instance orderHalogenM :: ManageOrder m => ManageOrder (HalogenM st act slots msg m) where
  getOrders = lift getOrders
