module RaytracaH.Plane where

import Data.Vec (dot)

import RaytracaH.Material
import RaytracaH.Math
import RaytracaH.Primitive
import RaytracaH.Ray

data Plane = Plane {
    point :: Vector3D,
    normal :: Vector3D,
    material :: Material
}

instance Primitive Plane where
    intersect (Plane planePoint planeNormal _) (Ray rayOrigin rayDir) = 
        if distance >= 0 then
            Intersection distance
        else 
            NoIntersection
        where
            distance = ((planePoint - rayOrigin) `dot` planeNormal) / (planeNormal `dot` rayDir)

    normalAtHitPoint (Plane _ planeNormal _) _ =
        planeNormal

    material (Plane _ _ planeMaterial) = 
        planeMaterial