module RaytracaH.Camera where

import Data.Vec

import RaytracaH.Math

data Camera = Camera {
    position :: Vector3D,
    target :: Vector3D,
    up :: Vector3D,
    fov :: Float
}

pointToCameraSpace :: Camera -> Vector3D -> Vector3D
pointToCameraSpace camera v = 
    Vec3F (x/w) (y/w) (z/w)
    where
        view = rotationLookAt (unpack $ up camera) (unpack $ position camera) (unpack $ target camera)
        (x :. y :. z :. w :. ()) = multmv view (snoc (unpack v) 1.0)