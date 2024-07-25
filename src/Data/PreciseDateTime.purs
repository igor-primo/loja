module Loja.Data.PreciseDateTime where

import Prelude

import Data.Codec.Argonaut (JsonCodec)
import Data.Codec.Argonaut as CA
import Data.Formatter.DateTime (FormatterCommand(..), format)
import Data.List (List, fromFoldable)
import Data.Newtype (unwrap)
import Data.PreciseDateTime (PreciseDateTime)
import Data.PreciseDateTime as PDT
import Data.RFC3339String (RFC3339String(..))

-- Representação de datas.
-- TODO: submeter os formatos ao locale.

-- Serialização.
codec :: JsonCodec PreciseDateTime
codec = CA.prismaticCodec "PreciseDateTime" from to CA.string
  where
  from = PDT.fromRFC3339String <<< RFC3339String
  to = unwrap <<< PDT.toRFC3339String

toDisplayWeekName :: PreciseDateTime -> String
toDisplayWeekName = PDT.toDateTimeLossy >>> format dateFormatter
  where
  dateFormatter :: List FormatterCommand
  dateFormatter = fromFoldable
    [ DayOfWeekNameShort
    , Placeholder " "
    , MonthShort
    , Placeholder " "
    , DayOfMonth
    , Placeholder ", "
    , YearFull
    ]

toDisplayMonthDayYear :: PreciseDateTime -> String
toDisplayMonthDayYear = PDT.toDateTimeLossy >>> format dateFormatter
  where
  dateFormatter :: List FormatterCommand
  dateFormatter = fromFoldable
    [ MonthFull
    , Placeholder " "
    , DayOfMonth
    , Placeholder ", "
    , YearFull
    ]
