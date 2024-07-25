module Loja.Capability.LogMessages where

import Prelude

import Loja.Capability.Now (class Now)
import Loja.Data.Log (Log, LogReason(..), mkLog)
import Control.Monad.Trans.Class (lift)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Halogen (HalogenM)

-- Capabilidade de fazer logging.
class Monad m <= LogMessages m where
  logMessage :: Log -> m Unit

instance logMessagesHalogenM :: LogMessages m => LogMessages (HalogenM st act slots msg m) where
  logMessage = lift <<< logMessage

-- | Next, we'll provide a few helper functions to help users easily create and dispatch logs
-- | from anywhere in the application. Each helper composes a couple of small functions together
-- | so that we've got less to remember later on.

-- | This instance lets us avoid having to use `lift` when we use these functions in a component.
log :: forall m. LogMessages m => Now m => LogReason -> String -> m Unit
log reason = logMessage <=< mkLog reason

-- | Log para depuração.
logDebug :: forall m. LogMessages m => Now m => String -> m Unit
logDebug = log Debug

-- | Log para informação.
logInfo :: forall m. LogMessages m => Now m => String -> m Unit
logInfo = log Info

-- | Log para avisos.
logWarn :: forall m. LogMessages m => Now m => String -> m Unit
logWarn = log Warn

-- | Log para erros.
logError :: forall m. LogMessages m => Now m => String -> m Unit
logError = log Error

-- | Silencia uma ação monádica e imprime o log.
logHush :: forall m a. LogMessages m => Now m => LogReason -> m (Either String a) -> m (Maybe a)
logHush reason action =
  action >>= case _ of
    Left e -> case reason of
      Debug -> logDebug e *> pure Nothing
      Info -> logInfo e *> pure Nothing
      Warn -> logWarn e *> pure Nothing
      Error -> logError e *> pure Nothing
    Right v -> pure $ Just v

-- | O mesmo, específico para depuração.
debugHush :: forall m a. LogMessages m => Now m => m (Either String a) -> m (Maybe a)
debugHush = logHush Debug
