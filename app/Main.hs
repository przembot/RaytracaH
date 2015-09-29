{-

Copyright 2015 Rafał Nowak

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

-}

module Main where

import qualified Data.Aeson as JSON
import qualified Data.ByteString.Lazy.Char8 as BS
import qualified Data.Vec as Vec
import qualified Data.Vector as V
import Data.Time
import System.IO

import RaytracaH.Bitmap
import RaytracaH.Camera
import RaytracaH.Color
import RaytracaH.Light
import RaytracaH.Material
import RaytracaH.Primitive
import RaytracaH.Scene
import RaytracaH.Sphere
import RaytracaH.Options
import RaytracaH.Plane
import RaytracaH.RayTracer

-- TODO: input scene loaded from file
sampleLights :: V.Vector Light
sampleLights = V.fromList [Directional (Vec.normalize $ Vec.Vec3F 0.0 0.0 0.0 - Vec.Vec3F 0.0 1.0 1.0) 0.8 (Color 1 1 1),
                           Directional (Vec.normalize $ Vec.Vec3F 0.0 0.0 0.0 - Vec.Vec3F (-1.0) 1.0 1.0) 0.3 (Color 1 1 1),
                           Directional (Vec.normalize $ Vec.Vec3F 0.0 0.0 0.0 - Vec.Vec3F 1.0 1.0 1.0) 0.1 (Color 1 1 1)]

sampleSpheres :: V.Vector AnyPrimitive
sampleSpheres = V.fromList [AnyPrimitive $ Plane (Vec.Vec3F 0.0 (-4.0) 0.0) (Vec.Vec3F 0.0 1.0 0.0) (Material (Color 0.78 0.78 0.78) Nothing Nothing),
                            AnyPrimitive $ Plane (Vec.Vec3F 0.0 (-4.0) (-35.0)) (Vec.Vec3F 0.0 0.0 1.0) (Material (Color 0.0 0.0 0.0) Nothing (Just 0.9)),
                            AnyPrimitive $ Sphere (Vec.Vec3F (-5.0) 0.0 (-5.0)) 1.0 (Material (Color 0 1 0) Nothing Nothing),
                            AnyPrimitive $ Sphere (Vec.Vec3F 0.0 0.0 (-5.0)) 2.0 (Material (Color 0.0 0.7 0.0) Nothing (Just 1.0)),
                            AnyPrimitive $ Sphere (Vec.Vec3F 4.0 0.0 (-3.0)) 1.0 (Material (Color 0.0 0.0 0.0) (Just 5.0) (Just 0.8)),
                            AnyPrimitive $ Sphere (Vec.Vec3F 0.0 5.0 (-5.0)) 2.0 (Material (Color 1 1 1) (Just 5.0) Nothing),
                            AnyPrimitive $ Sphere (Vec.Vec3F 0.0 3.0 (-10.0)) 2.0 (Material (Color 1 0 0) Nothing Nothing),
                            AnyPrimitive $ Sphere (Vec.Vec3F 0.0 0.0 6.0) 1.0 (Material (Color (227.0/255.0) (166.0/255.0) 0) (Just 5.0) Nothing)]

sampleScene :: Scene
sampleScene = Scene sampleLights sampleSpheres

sampleCamera :: Camera
sampleCamera = Camera (Vec.Vec3F 0.0 5.0 35.0) (Vec.Vec3F 0 0 0) (Vec.Vec3F 0 1 0) 30.0

loadOptions :: String -> IO (Either String RayTracerOptions)
loadOptions fileName =
    do
        file <- openFile fileName ReadMode
        contents <- BS.hGetContents file
        return (JSON.eitherDecode contents :: Either String RayTracerOptions)

main :: IO ()
main = do
    putStrLn "raytracaH\n"
    startTime <- getCurrentTime
    optionsDecoded <- loadOptions "config.json"
    case optionsDecoded of
        Left err ->
            putStrLn err
        Right options -> do
            putStrLn "Loaded options from config.json"
            writeAsciiPPMFile (outputFileName options) (fileWithRenderedImage sampleCamera options sampleScene)
    endTime <- getCurrentTime
    putStr ("Work finished, results saved to " ++ "test" ++ ", total time: ")
    print $ diffUTCTime endTime startTime
    return ()
