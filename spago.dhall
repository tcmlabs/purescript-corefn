{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name =
    "corefn"
, dependencies =
    [ "arrays"
    , "console"
    , "effect"
    , "foreign-generic"
    , "profunctor"
    , "psci-support"
    , "spec-discovery"
    ]
, packages =
    ./packages.dhall
, sources =
    [ "src/**/*.purs", "test/**/*.purs" ]
}
