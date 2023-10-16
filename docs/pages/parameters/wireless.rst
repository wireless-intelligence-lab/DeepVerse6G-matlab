^^^^^^^^^^^^^^^^^^^
Wireless Parameters
^^^^^^^^^^^^^^^^^^^

The communication channel generation parameters are defined in :attr:`dv.communication_parameters` file. 
These parameters are listed in detail as follows.


Antenna Properties
==================

Shape
-----

.. attribute:: comm.num_ant_BS
  
  `Default:` |num_ant_BS|
  
  Number of antenna elements for the basestation uniform planar arrays in the horizontal and vertical directions.
  
  An antenna array (ULA/UPA) of ``num_ant_BS(1) x num_ant_BS(2)`` elements is adopted for each active basestation.

  The axes of the antennas match the axes of the ray-tracing scenario.

  * If a 2D vector is given as input, all the active basestations adopt the same array.
	
  * To set different array sizes for the active BSs, you can add multiple rows of antenna sizes.

    .. admonition:: Example
	
	  	If we have 2 active basestations, to set two different array sizes we can apply the following.

		.. code-block:: matlab

			comm.num_ant_BS = [[8, 4]; [4, 4]];

.. attribute:: comm.num_ant_UE
  
  `Default:` |num_ant_UE|
  
  Number of antenna elements for the user uniform planar arrays in the horizontal and vertical directions.

  An antenna array (ULA/UPA) of ``num_ant_UE(1) x num_ant_UE(2)`` elements is adopted for each active UE.

  The axes of the antennas match the axes of the ray-tracing scenario.


FoV
-------

.. attribute:: comm.ant_FoV_BS
  
  `Default:` |ant_FoV_BS|
  
  The field of view of the antenna array. It is given as a 2D array of horizontal and vertical angles. The maximum value for the horizontal FoV is 360, and the vertical FoV is 180.


.. attribute:: comm.ant_FoV_UE
  
  `Default:` |ant_FoV_UE|
  
  The field of view of the antenna array. It is given as a 2D array of horizontal and vertical angles. The maximum value for the horizontal FoV is 360, and the vertical FoV is 180.


Spacing
-------

.. attribute:: comm.ant_spacing_BS
  
  `Default:` |ant_spacing_BS|
  
  The spacing between the antenna array elements of the basestation is determined as ``ant_spacing_BS x wavelength``.


.. attribute:: comm.ant_spacing_UE
  
  `Default:` |ant_spacing_UE|
  
  The spacing between the antenna array elements of the UEs is determined as ``ant_spacing_UE x wavelength``.

Rotation
--------
  
.. attribute:: comm.array_rotation_BS 
  
  `Default:` |array_rotation_BS|
  
  The BS antenna array rotation parameters, which consists of three rotation angles (in degrees). These angles rotate the BS antenna array in the given angles around the local x, y, z axes, respectively. To assign the same array rotation parameters to all active BSs, the following variable setting can be applied.

  * If a 3D vector is given as input, all the active basestations adopt the same rotation values.
  
    .. admonition:: Example
	
	    To assign the same antenna rotation of angles `x_rot`, `y_rot`, `z_rot` to all active BSs, we can apply the following. 

	    .. code-block:: matlab

		    comm.array_rotation_BS = [x_rot, y_rot, z_rot];  
	
  * To set different antenna rotations for the active BSs, you can add multiple rows of rotations.

    .. admonition:: Example
	
	    To assign different array rotation parameters to each active BS, set an N x 3 matrix, with N being the number of active BSs. For instance, with two active BSs, the following variable setting can be applied.

	    .. code-block:: matlab

		    comm.array_rotation_BS = [[x_rot_1, y_rot_1, z_rot_1]; 
						[x_rot_2, y_rot_2, z_rot_2]]; 
	
	
.. attribute:: comm.array_rotation_UE
  
  `Default:` |array_rotation_UE|
  
  The UE antenna array rotation parameters, which consists of three rotation angles (in degrees). 
  These angles rotate the UE antenna array in the given angles around the local x, y, z axes, respectively.

  * If a 3D vector is given as input, all UEs adopt the same rotation values.
  
    .. admonition:: Example
	
	    To assign the same antenna rotation of angles `x_rot`, `y_rot`, `z_rot` to all UEs, we can apply the following. 

	    .. code-block:: matlab

		    comm.array_rotation_BS = [x_rot, y_rot, z_rot];  
	
  * To set random antenna rotations for each UE, you can add three rows of rotations, each representing the minimum and maximum over x, y, z axes, respectively.

    .. admonition:: Example
	
	    To assign uniformly random array rotations to each UE, set a ``3 x 2`` matrix, where the first column defines the lower limits of the uniform distribution, and the second column defines the upper limits. For instance, for each UE, uniformly random values between the minimum and the maximum limits can be assigned for the array rotation angles as follows.

	    .. code-block:: matlab
		
		    comm.array_rotation_UE = [x_rot_min, x_rot_max;
						y_rot_min, y_rot_max;
						z_rot_min, z_rot_max] 
	
Channel Properties
==================

.. attribute:: comm.num_paths
  
  `Default:` |num_paths|
  
  Maximum number of paths to be considered, e.g., choose ``1`` if you are only interested in the strongest path.

.. attribute:: comm.generate_OFDM_channels
  
  `Default:` |generate_OFDM_channels|
  
  The indicator for OFDM or CIR output in the dataset.
  
  * ``0`` activates time domain (TD) channel impulse response generation.

  * ``1`` activates frequency domain (FD) channel generation for OFDM systems.
  
.. attribute:: comm.bandwidth
  
  `Default:` |bandwidth|
  
  Total bandwidth of the channel in GHz. 


.. attribute:: comm.enable_Doppler
  
  `Default:` |enable_Doppler|
  
  Turn on/off the Doppler shift due to the speed of the objects in the scene.
  
  * ``0`` No Doppler shift is applied.
  * ``1`` Doppler shift is applied to the channels.


OFDM Options
------------

.. attribute:: comm.num_OFDM
  
  `Default:` |num_OFDM|
  
  Number of OFDM subcarriers (e.g., ``256``, ``512``, ``1024``). 

.. attribute:: comm.OFDM_sampling
  
  `Default:` |OFDM_sampling|
  
  The constructed channels will be calculated only at the sampled subcarriers to reduce the size of the dataset. 
  The list of subcarriers given in this parameter will be generated.


.. admonition:: Example
  
	For ``num_OFDM = 512``, ``OFDM_sampling = 1:8:512``, the subcarriers ``{1, 9, 17, 25}`` are subsampled from the available subcarriers ``{1, 2, …, 512}``.
  
.. note:: 
  
	The computation of subsampled subcarriers is implemented efficiently. Thus, only the selected subcarriers are computed by the generator.
	

.. attribute:: comm.activate_RX_filter
  
  `Default:` |activate_RX_filter|
  
  Turn on/off the receive LPF.
  
  * ``0`` No RX filter is applied.
  * ``1`` Ideal RX low-pass filter is applied. (ideal: Sinc in the time domain)


..
	---------------------------------------------------------------------------