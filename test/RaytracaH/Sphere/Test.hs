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

module RaytracaH.Sphere.Test where

import Test.QuickCheck

import qualified Data.Vec as Vec

import RaytracaH.Math
import RaytracaH.Primitive
import RaytracaH.Primitive.Test
import RaytracaH.Ray
import RaytracaH.Sphere

raysOutsideSphere :: Sphere -> Gen Ray
raysOutsideSphere sphere = do
    xDistance <- choose (sphereRadius * 1.2, sphereRadius * 2.0)
    yDistance <- choose (sphereRadius * 1.2, sphereRadius * 2.0)
    zDistance <- choose (sphereRadius * 1.2, sphereRadius * 2.0)
    rayDirection <- arbitrary :: (Gen AnyVector3D)
    return $ Ray (sphereCenter + Vec.Vec3F xDistance yDistance zDistance) (Vec.normalize $ v3d rayDirection)
    where
        sphereCenter = center sphere
        sphereRadius = radius sphere

prop_hitPointAtRadiusDistance :: Sphere -> Property
prop_hitPointAtRadiusDistance sphere = 
    forAll (raysOutsideSphere sphere) $ \ray ->
        rayHitPointAtRadius sphere ray

rayHitPointAtRadius :: Sphere -> Ray -> Bool
rayHitPointAtRadius sphere ray = 
    case intersection of Intersection distance ->
                             let
                                hitPoint = pointOnRay ray distance
                                sphereCenter = center sphere
                                sphereRadius = radius sphere
                             in
                                equalsCustomEpsilon 1e-4 (Vec.norm $ sphereCenter - hitPoint) sphereRadius
                         _ ->
                             True
    where
        intersection = sphere `intersect` ray

raysDirectedAtSphere :: Sphere -> Gen Ray
raysDirectedAtSphere sphere = do
    (Ray rayOrigin _) <- raysOutsideSphere sphere
    return $ Ray rayOrigin (Vec.normalize $ center sphere - rayOrigin)

prop_rayDirectedAtSphereIntersect :: Sphere -> Property
prop_rayDirectedAtSphereIntersect sphere = 
    forAll (raysDirectedAtSphere sphere) $ \ray ->
        rayHitPrimitive sphere ray
