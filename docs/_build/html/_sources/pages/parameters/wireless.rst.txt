^^^^^^^^^^^^^^^^^^^
Wireless Parameters
^^^^^^^^^^^^^^^^^^^

The wireless generation parameters are defined in :attr:`dv.wireless_parameters` file. 
These parameters are listed in detail as follows.


Antenna Properties
==================

Shape
-----

.. attribute:: params.num_ant_BS
  
  `Default:` |num_ant_BS|
  
  Number of antenna elements for the basestation arrays in the x,y,z-axes.
  
  An antenna array (ULA/UPA) of ``num_ant_BS(1) x num_ant_BS(2) x num_ant_BS(3)`` elements is adopted for each active basestation.

  The axes of the antennas match the axes of the ray-tracing scenario.

  * If a 3D vector is given as input, all the active basestations adopt the same array.
	
  * To set different array sizes for the active BSs, you can add multiple rows of antenna sizes.

    .. admonition:: Example
	
	  	If we have 2 active basestations, to set two different array sizes we can apply the following.

		.. code-block:: matlab

			params.num_ant_BS = [[1, 8, 4]; [1, 4, 4]];

.. attribute:: params.num_ant_UE
  
  `Default:` |num_ant_UE|
  
  Number of antenna elements for the user arrays in the x,y,z-axes.

  An antenna array (ULA/UPA) of ``num_ant_UE(1) x num_ant_UE(2) x num_ant_UE(3)`` elements is adopted for each active UE.

  The axes of the antennas match the axes of the ray-tracing scenario.



Spacing
-------

.. attribute:: params.ant_spacing_BS
  
  `Default:` |ant_spacing_BS|
  
  The spacing between the antenna array elements of the basestation is determined as ``ant_spacing_BS x wavelength``.


.. attribute:: params.ant_spacing_UE
  
  `Default:` |ant_spacing_UE|
  
  The spacing between the antenna array elements of the UEs is determined as ``ant_spacing_UE x wavelength``.

Rotation
--------
.. attribute:: params.activate_array_rotation
  
  `Default:` |activate_array_rotation|
  
  Turn on/off the array rotation. Setting this parameter to ``1`` applies the rotation defined in :attr:`params.array_rotation_BS` and :attr:`params.array_rotation_UE`.
  
  
.. attribute:: params.array_rotation_BS 
  
  `Default:` |array_rotation_BS|
  
  The BS antenna array rotation parameters, which consists of three rotation angles (in degrees). These angles rotate the BS antenna array in the given angles around the local x, y, z axes, respectively. To assign the same array rotation parameters to all active BSs, the following variable setting can be applied.

  * If a 3D vector is given as input, all the active basestations adopt the same rotation values.
  
    .. admonition:: Example
	
	    To assign the same antenna rotation of angles `x_rot`, `y_rot`, `z_rot` to all active BSs, we can apply the following. 

	    .. code-block:: matlab

		    params.array_rotation_BS = [x_rot, y_rot, z_rot];  
	
  * To set different antenna rotations for the active BSs, you can add multiple rows of rotations.

    .. admonition:: Example
	
	    To assign different array rotation parameters to each active BS, set an N x 3 matrix, with N being the number of active BSs. For instance, with two active BSs, the following variable setting can be applied.

	    .. code-block:: matlab

		    params.array_rotation_BS = [[x_rot_1, y_rot_1, z_rot_1]; 
						[x_rot_2, y_rot_2, z_rot_2]]; 
	
	
.. attribute:: params.array_rotation_UE
  
  `Default:` |array_rotation_UE|
  
  The UE antenna array rotation parameters, which consists of three rotation angles (in degrees). 
  These angles rotate the UE antenna array in the given angles around the local x, y, z axes, respectively.

  * If a 3D vector is given as input, all UEs adopt the same rotation values.
  
    .. admonition:: Example
	
	    To assign the same antenna rotation of angles `x_rot`, `y_rot`, `z_rot` to all UEs, we can apply the following. 

	    .. code-block:: matlab

		    params.array_rotation_BS = [x_rot, y_rot, z_rot];  
	
  * To set random antenna rotations for each UE, you can add three rows of rotations, each representing the minimum and maximum over x, y, z axes, respectively.

    .. admonition:: Example
	
	    To assign uniformly random array rotations to each UE, set a ``3 x 2`` matrix, where the first column defines the lower limits of the uniform distribution, and the second column defines the upper limits. For instance, for each UE, uniformly random values between the minimum and the maximum limits can be assigned for the array rotation angles as follows.

	    .. code-block:: matlab
		
		    params.array_rotation_UE = [x_rot_min, x_rot_max;
						y_rot_min, y_rot_max;
						z_rot_min, z_rot_max] 
	
Channel Properties
==================

.. attribute:: params.num_paths
  
  `Default:` |num_paths|
  
  Maximum number of paths to be considered, e.g., choose ``1`` if you are only interested in the strongest path.

.. attribute:: params.generate_OFDM_channels
  
  `Default:` |generate_OFDM_channels|
  
  The indicator for OFDM or CIR output in the dataset.
  
  * ``0`` activates time domain (TD) channel impulse response generation.

  * ``1`` activates frequency domain (FD) channel generation for OFDM systems.
  
.. attribute:: params.bandwidth
  
  `Default:` |bandwidth|
  
  Total bandwidth of the channel in GHz. 

OFDM Options
------------

.. attribute:: params.num_OFDM
  
  `Default:` |num_OFDM|
  
  Number of OFDM subcarriers (e.g., ``256``, ``512``, ``1024``). 

.. attribute:: params.OFDM_limit
  
  `Default:` |OFDM_limit|
  
  The constructed channels will be calculated only at the sampled subcarriers to reduce the size of the dataset. 
  The first OFDM_limit subcarriers are subsampled with :attr:`params.OFDM_sampling_factor` spacing between the selected subcarriers.


.. attribute:: params.OFDM_sampling_factor
  
  `Default:` |OFDM_sampling_factor|
  
  The subsampling spacing between generated subcarriers. 

.. admonition:: Example
  
	For ``OFDM_limit = 512``, ``OFDM_limit = 32`` and ``OFDM_sampling_factor = 8``, the subcarriers ``{1, 9, 17, 25}`` are subsampled from the available subcarriers ``{1, 2, …, 512}``.
  
.. note:: 
  
	The computation of subsampled subcarriers is implemented efficiently. Thus, only the selected subcarriers are computed by the generator.
	

.. attribute:: params.activate_RX_filter
  
  `Default:` |activate_RX_filter|
  
  Turn on/off the receive LPF.
  
  * ``0`` No RX filter is applied.
  * ``1`` Ideal RX low-pass filter is applied. (ideal: Sinc in the time domain)


..
	---------------------------------------------------------------------------