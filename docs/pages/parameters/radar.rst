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
  
  Number of antenna elements for the radar TX arrays in the x,y,z-axes.
  
  An antenna array (ULA/UPA) of ``num_ant_BS(1) x num_ant_BS(2) x num_ant_BS(3)`` elements is adopted for each active basestation.

  The axes of the antennas match the axes of the ray-tracing scenario.

  * If a 3D vector is given as input, all the TX arrays adopt the same array.
	
  * To set different array sizes for the TX arrays, you can add multiple rows of antenna sizes.

    .. admonition:: Example
	
	  	If we have 2 active basestations, to set two different radar TX array sizes we can apply the following.

		.. code-block:: matlab

			radar.num_ant_TX = [[1, 8, 4]; [1, 4, 4]];

.. attribute:: radar.num_ant_RX
  
  `Default:` |num_ant_RX|
  
  Number of antenna elements for the radar RX arrays in the x,y,z-axes.
  
  An antenna array (ULA/UPA) of ``num_ant_BS(1) x num_ant_BS(2) x num_ant_BS(3)`` elements is adopted for each active basestation.

  The axes of the antennas match the axes of the ray-tracing scenario.

  * If a 3D vector is given as input, all the radar RX arrays adopt the same array.
	
  * To set different array sizes for the radar RX arrays, you can add multiple rows of antenna sizes.

    .. admonition:: Example
	
	  	If we have 2 active basestations, to set two different radar RX array sizes we can apply the following.

		.. code-block:: matlab

			radar.num_ant_RX = [[1, 8, 4]; [1, 4, 4]];



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
.. attribute:: radar.activate_array_rotation
  
  `Default:` |activate_radar_array_rotation|
  
  Turn on/off the radar array rotation. 
  Setting this parameter to ``1`` applies the rotation defined in :attr:`radar.array_rotation_TX` and :attr:`radar.array_rotation_RX`.
  
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
  
  
.. attribute:: radar.Fs
  
  `Default:` |Fs|
  
.. attribute:: radar.N_ADC
  
  `Default:` |N_ADC|
  
.. attribute:: radar.N_loop
  
  `Default:` |N_loop|
  
.. attribute:: radar.T_idle
  
  `Default:` |T_idle|
  
.. attribute:: radar.T_start
  
  `Default:` |T_start|
  
.. attribute:: radar.T_excess
  
  `Default:` |T_excess|
  
.. attribute:: radar.duty_cycle
  
  `Default:` |duty_cycle|
  
Computation Properties
======================

.. attribute:: radar.radar_channel_taps
  
  `Default:` |radar_channel_taps|
  
  Maximum number of paths to be considered, e.g., choose 1 if you are only interested in the strongest radar reflection path.

.. attribute:: radar.comp_speed
  
  `Default:` |comp_speed|
  
  The parameter to control the compromise between computational speed and memory requirement.
  ..note:: 
  
    This parameter is defined between ``1`` and ``5``), e.g., choose ``5`` if you are only interested in the fastest computation with the largest memory requirement.

..
	---------------------------------------------------------------------------