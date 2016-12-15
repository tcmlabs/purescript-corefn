module CoreFn.Names
  ( ModuleName(..)
  , OpName(..)
  , ProperName(..)
  , Qualified(..)
  , readModuleName
  , readModuleNameJSON
  , readOpName
  , readOpNameJSON
  , readProperName
  , readProperNameJSON
  ) where

import Prelude
import Control.Error.Util (exceptNoteM)
import Data.Array (init, last, null)
import Data.Foreign (F, Foreign, ForeignError(..), parseJSON, readString)
import Data.Foreign.Class (class IsForeign)
import Data.Generic (class Generic, gShow)
import Data.List.NonEmpty (singleton)
import Data.List.Types (NonEmptyList)
import Data.Maybe (Maybe(..))
import Data.Newtype (class Newtype, wrap)
import Data.String (Pattern(..), joinWith, split)

-- |
-- Module names
--
newtype ModuleName = ModuleName String

derive instance eqModuleName :: Eq ModuleName
derive instance genericModuleName :: Generic ModuleName
derive instance newtypeModuleName :: Newtype ModuleName _
derive instance ordModuleName :: Ord ModuleName

instance showModuleName :: Show ModuleName where
  show = gShow

readModuleName :: Foreign -> F ModuleName
readModuleName x = ModuleName <$> readString x

readModuleNameJSON :: String -> F ModuleName
readModuleNameJSON json = parseJSON json >>= readModuleName

-- |
-- Operator alias names.
--
newtype OpName = OpName String

derive instance eqOpName :: Eq OpName
derive instance genericOpName :: Generic OpName
derive instance newtypeOpName :: Newtype OpName _
derive instance ordOpName :: Ord OpName

instance showOpName :: Show OpName where
  show = gShow

readOpName :: Foreign -> F OpName
readOpName x = OpName <$> readString x

readOpNameJSON :: String -> F OpName
readOpNameJSON json = parseJSON json >>= readOpName

-- |
-- Proper name, i.e. capitalized names for e.g. module names, type/data
-- constructors.
--
newtype ProperName = ProperName String

derive instance eqProperName :: Eq ProperName
derive instance genericProperName :: Generic ProperName
derive instance newtypeProperName :: Newtype ProperName _
derive instance ordProperName :: Ord ProperName

instance showProperName :: Show ProperName where
  show = gShow

readProperName :: Foreign -> F ProperName
readProperName x = ProperName <$> readString x

readProperNameJSON :: String -> F ProperName
readProperNameJSON json = parseJSON json >>= readProperName

-- |
-- A qualified name, i.e. a name with an optional module name
--
data Qualified a = Qualified (Maybe ModuleName) a

derive instance eqQualified :: (Generic a, Eq a) => Eq (Qualified a)
derive instance genericQualified :: (Generic a) => Generic (Qualified a)
derive instance ordQualified :: (Generic a, Ord a) => Ord (Qualified a)

instance isForeignQualified :: Newtype t String => IsForeign (Qualified t) where
  read value = readString value >>= (flip exceptNoteM errors) <<< toQualified

    where

    arrayToMaybe :: forall a. Array a -> Maybe (Array a)
    arrayToMaybe xs | null xs = Nothing
                    | otherwise = Just xs

    init' :: forall a. Array a -> Maybe (Array a)
    init' xs = init xs >>= arrayToMaybe

    delimiter = "."

    toModuleName :: Array String -> ModuleName
    toModuleName = ModuleName <<< (joinWith delimiter)

    toQualified :: Newtype t String => String -> Maybe (Qualified t)
    toQualified s = do
      let parts = split (Pattern delimiter) s
      Qualified (toModuleName <$> init' parts) <<< wrap <$> last parts

    errors :: NonEmptyList ForeignError
    errors = singleton (ForeignError "Error parsing qualified name")

instance showQualified :: (Generic a, Show a) => Show (Qualified a) where
  show = gShow
