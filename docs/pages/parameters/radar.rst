^^^^^^^^^^^^^^^^^^^
Radar Parameters
^^^^^^^^^^^^^^^^^^^

The radar signal generation parameters are defined in :attr:`dv.radar_parameters` file. 
These parameters are listed in detail as follows.

Antenna Properties
==================

Shape
-----

.. attribute:: radar.num_ant_TX
  
  `Default:` |num_ant_TX|
  
  Number of antenna elements for the radar TX uniform planar arrays in the horizontal and vertical directions.
  
  An antenna array (ULA/UPA) of ``num_ant_BS(1) x num_ant_BS(2)`` elements is adopted for each active basestation.

  The axes of the antennas match the axes of the ray-tracing scenario.

  * If a 2D vector is given as input, all the TX arrays adopt the same array.
	
  * To set different array sizes for the TX arrays, you can add multiple rows of antenna sizes.

    .. admonition:: Example
	
	  	If we have 2 active basestations, to set two different radar TX array sizes we can apply the following.

		.. code-block:: matlab

			radar.num_ant_TX = [[8, 4]; [4, 4]];

.. attribute:: radar.num_ant_RX
  
  `Default:` |num_ant_RX|
  
  Number of antenna elements for the radar RX uniform planar arrays in the horizontal and vertical directions..
  
  An antenna array (ULA/UPA) of ``num_ant_BS(1) x num_ant_BS(2)`` elements is adopted for each active basestation.

  The axes of the antennas match the axes of the ray-tracing scenario.

  * If a 2D vector is given as input, all the radar RX arrays adopt the same array.
	
  * To set different array sizes for the radar RX arrays, you can add multiple rows of antenna sizes.

    .. admonition:: Example
	
	  	If we have 2 active basestations, to set two different radar RX array sizes we can apply the following.

		.. code-block:: matlab

			radar.num_ant_RX = [[8, 4]; [4, 4]];



FoV
-------

.. attribute:: radar.ant_FoV_TX
  
  `Default:` |ant_FoV_TX|
  
  The field of view of the TX antenna array. It is given as a 2D array of horizontal and vertical angles. The maximum value for the horizontal FoV is 360, and the vertical FoV is 180.


.. attribute:: radar.ant_FoV_RX
  
  `Default:` |ant_FoV_UE|
  
  The field of view of the RX antenna array. It is given as a 2D array of horizontal and vertical angles. The maximum value for the horizontal FoV is 360, and the vertical FoV is 180.

Spacing
-------

.. attribute:: radar.ant_spacing_TX
  
  `Default:` |ant_spacing_TX|
  
  The spacing between the radar TX antenna array elements of the basestation is determined as ``ant_spacing_TX x wavelength``.


.. attribute:: radar.ant_spacing_RX
  
  `Default:` |ant_spacing_RX|
  
  The spacing between the radar RX antenna array elements of the basestation is determined as ``ant_spacing_RX x wavelength``.

Rotation
--------

.. attribute:: radar.array_rotation_TX
  
  `Default:` |array_rotation_TX|
  
  The radar TX antenna array rotation parameters, which consists of three rotation angles (in degrees). These angles rotate the radar TX antenna array in the given angles around the local x, y, z axes, respectively. To assign the same array rotation parameters to all radar TX arrays, the following variable setting can be applied.

  * If a 3D vector is given as input, all the active radar TX antennas adopt the same rotation values.
  
    .. admonition:: Example
	
	    To assign the same antenna rotation of angles `x_rot`, `y_rot`, `z_rot` to the radar TX antennas at the all active BSs, we can apply the following. 

	    .. code-block:: matlab

		    radar.array_rotation_TX = [x_rot, y_rot, z_rot];  
	
  * To set different antenna rotations for the active BSs, you can add multiple rows of rotations.

    .. admonition:: Example
	
	    To assign different array rotation parameters to each radar TX antenna, set an N x 3 matrix, with N being the number of active BSs. For instance, with two active BSs, the following variable setting can be applied.

	    .. code-block:: matlab

		    radar.array_rotation_TX = [[x_rot_1, y_rot_1, z_rot_1]; 
						[x_rot_2, y_rot_2, z_rot_2]]; 
	
	
.. attribute:: radar.array_rotation_RX
  
  `Default:` |array_rotation_RX|
  
  The parameter determines the rotation of radar RX antennas. The functionality is the same with :attr:`radar.array_rotation_TX`, hence, the details are skipped.


Chirp Characteristics
=====================

.. attribute:: radar.S
  
  `Default:` |S|
  
	The slope of the chirps in a frame.
	
.. attribute:: radar.Fs
  
  `Default:` |Fs|
  
  The sampling rate of the FMCW radar ADC.
	
.. attribute:: radar.N_samples
  
  `Default:` |N_samples|
  
	The number of ADC samples collected from each chirp.
	
.. attribute:: radar.N_chirp
  
  `Default:` |N_chirp|
  
	The number of chirps in each radar frame.
	
Computation Properties
======================

.. attribute:: radar.num_paths_radar
  
  `Default:` |num_paths_radar|
  
  Maximum number of paths to be considered, e.g., choose 1 if you are only interested in the strongest radar reflection path.

.. attribute:: radar.comp_speed
  
  `Default:` |comp_speed|
  
  The parameter to control the compromise between computational speed and memory requirement.
  ..note:: 
  
    This parameter is defined between ``1`` and ``5``), e.g., choose ``5`` if you are only interested in the fastest computation with the largest memory requirement.

..
	---------------------------------------------------------------------------