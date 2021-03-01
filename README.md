
# Necrotelecomnicon

_Based on Shpuld's Cleaned up Quake id1 v1.01 QuakeC source_

**Necrotelecomnicon** is a Quake mod that allows entities to transfer values
between eachother.

## General Changes

The behavior of `SUB_UseTargets` has been modified such that a firing entity
writes its `io_send` field to the targeted entity's `io_received` field.

Any previously existing entity (with the exception of `trigger_relay`) can have 
its `io_send` field initialized, such that it will be sent when it calls its
targets.

## Entities

### trigger_relay

`trigger_relay` has been modified to transfer its **received** value to its
**send** field.  This has the effect of _relaying_ its received value to its
target entity.

For default `trigger_relay` behavior, see `math_var` below.

### trigger_setskill

`trigger_setskill` has been updated to allow being targeted if given a
`targetname`.  It can also be set to use its **received** value as the skill
level, and it will **send** the skill value to its targets.

### trigger_repeat

This entity repeats firing its targeted entity `count` times; that is, it is
fired `count` + 1 times in total when triggered.  The entity will **send** its
current value starting from 0 and ending with `count`.  The initial firing
occurs `delay` seconds after triggered, while the interval between subsequent
firings is `wait` seconds.

### trigger_init

Fires on map load.  Can be set to **send** its provided `io_send` field or the
current skill level.

### trigger_toggle

Holds a value of 0 or 1, and assigns itself the *opposite* and **send**s that
value to its target.  Can be initializd with `io_send`.

### dbg_io

This entity center-prints its **received** value.  A prefix can be provided
using the `message` field; it defaults to "Received:".

### math_adder

This entity stores a value which other entities can add to via **received**
value.  The value can be bounded between a lower bound (`waitmin`) and upper
bound (`waitmax`) as well as being directed to fire only when the value changes,
or hits a boundary.  When it is fired, it will **send** its value to the
targeted entity.

### math_compare

This entity compares its **received** value against its `io_arg2` field.  The
comparison can be _greater than_, _less than_, _equal_, etc.  If the comparison
evaluates to true, it fires its targeted entity.  Like the vanilla entities, 
the `io_send` field can be set to provide a value to send to targeted entities.

### math_op

This entity evaluates a unary operation on its **received** value, or a binary
operation on its **received** value and its `io_arg2` field.  Then the entity
will **send** the result of the evaluation.  If an error occurs during
evaluation it will not fire, instead broadcasting a message to players.

### control_vis

Instead of firing its target, this entity sets its target's opacity to the
**received** value.  A flag can be set to determine whether or not to disable
solidity when the targeted entity's opacity is effectively 0 (only works on
`func_wall`).

### control_var

This entity sets its target's `io_send` value to the **received** value.
WARNING: Will cause unstable behavior if targeting `trigger_repeater` or
`math_adder` since both rely on maintaining the state of their `io_send` fields.
If the targeting `trigger_relay`, `math_op`, or `func_actuator` it has no
effect.

### control_var

Sets the target's `frame` value to the **received** value.

### func_actuator

This entity moves to arbitrary positions along a linear path.  You can set a
reference point to move to via the `target` field.  BE SURE one of the brushes
this entity is composed of is textured with "origin", otherwise the world's 
origin will be used as a reference point.  When triggered, the **received**
value indicates where the brush will move to -- 1 will cause it to move to its
target, 0 will cause it to move to its initial position, 0.5 will cause it to
move to a point half-way between, etc.  Negative values and values greater than
1 are also valid. Damage behavior can be set to "Grow" (damage grows
quadratically), "Constant" (damage remains the same) or "Crush" (damage is
applied every frame to kill its blocker quickly).  The entity can also be set
to be non-solid (useful for indicators that aren't meant to obstruct the player
or monsters).  When a `func_actuator` stops at a destination, it will **send**
its current **received** value.

### func_meter

Non-solid indicator that rotates about its origin (use an origin-textured
brush).  This entity can be configured to move between a start (`angles`) and
end (`mangle`) position.  It moves to a position relative to its **received**
value.

### fx_model_toggle

A toggleable model/sprite.  Specify a primary model with `model` and/or a
secondary model with `wad`.  If targeted and the **received** value is 0,
the models will be swapped.  If the **received** value is negative, the model
will be set to its primary model.  If the **received** value is positive, the
model will be set to its secondary model.

## Misc. Improvements

Grenades getting "stuck" on slopes leading downwards have been fixed.  (Thanks,
Spike!)
