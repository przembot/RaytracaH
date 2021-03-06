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

import Test.QuickCheck

import qualified RaytracaH.Math.Test as MT
import qualified RaytracaH.Light.Test as LT
import qualified RaytracaH.Plane.Test as PT
import qualified RaytracaH.Ray.Test as RT
import qualified RaytracaH.Sphere.Test as ST

main :: IO ()
main = do
    quickCheck MT.prop_deg2rad
    quickCheck MT.prop_rad2deg
    quickCheck MT.prop_mutlvs
    quickCheck MT.prop_clampedToPositiveBiggerOrEqualZero
    quickCheck MT.prop_limitedToOneAllLessThanOrEqualToOne
    quickCheck MT.prop_angleOfIncidenceEqualToAngleOfReflection
    quickCheck LT.prop_intensityForDirectionalLightIsConstant
    quickCheck LT.prop_intensityForPointLightDecreasesWithDistance
    quickCheck PT.prop_raysDirectedAtPlaneAlwaysHit
    quickCheck PT.prop_raysNotDirectedAtPlaneAlwaysMiss
    quickCheck RT.prop_allPrimaryRaysDirectionNormalized
    quickCheck ST.prop_hitPointAtRadiusDistance
    quickCheck ST.prop_rayDirectedAtSphereIntersect
