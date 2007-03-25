--
-- Haddock - A Haskell Documentation Tool
--
-- (c) Simon Marlow 2003
--
-- This file, (c) Neil Mitchell 2006
-- Write out Hoogle compatible documentation
-- http://www.haskell.org/hoogle/

module Haddock.Hoogle ( 
	ppHoogle
  ) where

ppHoogle = undefined

{-
import HaddockTypes
import HaddockUtil
import HsSyn2

import Data.List ( intersperse )



prefix = ["-- Hoogle documentation, generated by Haddock",
          "-- See Hoogle, http://www.haskell.org/hoogle/"]

ppHoogle :: Maybe String -> [Interface] -> FilePath -> IO ()
ppHoogle maybe_package ifaces odir =
    do
        let
            filename = case maybe_package of
                        Just x -> x ++ ".txt"
                        Nothing -> "hoogle.txt"

            visible_ifaces = filter visible ifaces
            visible i = OptHide `notElem` iface_options i

            contents = prefix : map ppModule visible_ifaces

        writeFile (pathJoin [odir, filename]) (unlines $ concat contents)
 


-- ---------------------------------------------------------------------------
-- Generate the HTML page for a module


ppDecl :: HsDecl -> [String]
ppDecl (HsNewTypeDecl src context name args ctor unknown docs) =
    ppData "newtype" context name args [ctor]

ppDecl (HsDataDecl src context name args ctors unknown docs) =
    ppData "data" context name args ctors

ppDecl (HsTypeSig src names t doc) = map (`ppFunc` t) names

ppDecl (HsForeignImport src _ _ _ name t doc) = ppDecl $ HsTypeSig src [name] t doc

ppDecl (HsClassDecl src context name args fundeps members doc) =
    ("class " ++ ppContext context ++ ppType typ) : concatMap f members
    where
        typ = foldl HsTyApp (HsTyCon $ UnQual name) (map HsTyVar args)
        newcontext = (UnQual name, map HsTyVar args)
        f (HsTypeSig src names t doc) = ppDecl (HsTypeSig src names (addContext newcontext t) doc)
        f (HsFunBind{}) = []
        f (HsPatBind{}) = []
        f x = ["-- ERR " ++ show x]

ppDecl (HsTypeDecl src name args t doc) =
    ["type " ++ show name ++ concatMap (\x -> ' ':show x) args ++ " = " ++ ppType t]

ppDecl x = ["-- ERR " ++ show x]



addContext :: HsAsst -> HsType -> HsType
addContext ctx (HsForAllType Nothing context t) = HsForAllType Nothing (HsAssump ctx : context) t
addContext ctx x = HsForAllType Nothing [HsAssump ctx] x



ppFunc :: HsName -> HsType -> String
ppFunc name typ = show name ++ " :: " ++ ppType typ


ppData :: String -> HsContext -> HsName -> [HsName] -> [HsConDecl] -> [String]
ppData mode context name args ctors = (mode ++ " " ++ ppType typ) : concatMap (ppCtor typ) ctors
    where
        typ = foldl HsTyApp (HsTyCon $ UnQual name) (map HsTyVar args)
        
        
deBang :: HsBangType -> HsType
deBang (HsBangedTy   x) = x
deBang (HsUnBangedTy x) = x


ppCtor :: HsType -> HsConDecl -> [String]
ppCtor result (HsConDecl src name types context typ doc) =
    [show name ++ " :: " ++ ppContext context ++ ppTypesArr (map deBang typ ++ [result])]

ppCtor result (HsRecDecl src name types context fields doc) =
        ppCtor result (HsConDecl src name types context (map snd fields2) doc) ++
        concatMap f fields2
    where
        fields2 = [(name, typ) | HsFieldDecl names typ _ <- fields, name <- names]
        f (name, typ) = ppDecl $ HsTypeSig src [name] (HsTyFun result (deBang typ)) doc


brack True  x = "(" ++ x ++ ")"
brack False x = x

ppContext :: HsContext -> String
ppContext [] = ""
ppContext xs = brack (length xs > 1) (concat $ intersperse ", " $ map ppContextItem xs) ++ " => "

ppContextItem :: HsAsst -> String
ppContextItem (name, types) = ppQName name ++ concatMap (\x -> ' ':ppType x) types

ppContext2 :: HsIPContext -> String
ppContext2 xs = ppContext [x | HsAssump x <- xs]


ppType :: HsType -> String
ppType x = f 0 x
    where
        f _ (HsTyTuple _ xs) = brack True $ concat $ intersperse ", " $ map (f 0) xs
        f _ (HsTyCon x) = ppQName x
        f _ (HsTyVar x) = show x

        -- ignore ForAll types as Hoogle does not support them
        f n (HsForAllType (Just items) context t) =
            -- brack (n > 1) $
            -- "forall" ++ concatMap (\x -> ' ':toStr x) items ++ " . " ++ f 0 t
            f n t

        f n (HsForAllType Nothing context t) = brack (n > 1) $
            ppContext2 context ++ f 0 t

        f n (HsTyFun a b) = brack g $ f (h 3) a ++ " -> " ++ f (h 2) b
            where
                g = n > 2
                h x = if g then 0 else x
        
        f n (HsTyApp a b) | ppType a == "[]" = "[" ++ f 0 b ++ "]"
        
        f n (HsTyApp a b) = brack g $ f (h 3) a ++ " " ++ f (h 4) b
            where
                g = n > 3
                h x = if g then 0 else x
        
        f n (HsTyDoc x _) = f n x

        f n x = brack True $ show x


ppQName :: HsQName -> String
ppQName (Qual _ name) = show name
ppQName (UnQual name) = show name



ppTypesArr :: [HsType] -> String
ppTypesArr xs = ppType $ foldr1 HsTyFun xs



ppInst :: InstHead -> String
ppInst (context, item) = "instance " ++ ppContext context ++ ppContextItem item



ppModule :: Interface -> [String]
ppModule iface = "" : ("module " ++ mdl) : concatMap ppExport (iface_exports iface)
    where
        Module mdl = iface_module iface


ppExport :: ExportItem -> [String]
ppExport (ExportDecl name decl insts) = ppDecl decl ++ map ppInst insts
ppExport _ = []


-}