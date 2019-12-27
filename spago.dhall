{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name =
    "corefn"
, dependencies =
    [ "aff"
    , "console"
    , "effect"
    , "errors"
    , "foldable-traversable"
    , "newtype"
    , "node-fs"
    , "profunctor"
    , "psci-support"
    , "strings"
    , "tuples"
    ]
, packages =
    ./packages.dhall
, sources =
    [ "src/**/*.purs", "test/**/*.purs" ]
}
