########
Commands
########

In this page, you can find the details of each data field. Specifically, the following questions are answered.

  * how they are activated, 
  
  * how these can be accessed,
  
  * what they contain,
  
  * relation to the parameters.
  
For an overview of the fields, please check the summary page.

In the following, the generated dataset structure variable is names as ``dataset``. 

.. attribute:: dataset{s}.bsi
  
  `Scene:` ``s`` - `Transmitter:` ``BS i``
  
  The transmitter data structure of the basestation ``i``. 
  
  .. note::
  
	  The ``i`` here represents the ``i``-th activated basestation, but not the index of the basestation given in the scenario description.
  
  
Wireless
========

The wireless data is activated with :attr:`dv.wireless`. If this parameter is ``0``, the wireless fields will not be available.

.. attribute:: dataset{s}.bsi.wireless.parameters
  
  `Scene:` ``s`` - `Transmitter:` ``BS i``
  
  The wireless communication parameters used to generate the dataset can be found in this structure. 
  The structure contains all the parameters relevant to the communication data generation, including the wireless parameters file and carrier frequency.
  This allows checking the details of the saved/loaded dataset.
  

.. attribute:: dataset{s}.bsi.wireless.channels
  
  `Scene:` ``s`` - `Transmitter:` ``BS i``
  
  The channel information structure.

  .. attribute:: dataset{s}.bsi.wireless.channels.loc
  
    `Scene:` ``s`` - `Transmitter:` ``BS i``
  
    `Size: 1x3`
  
    The location of the transmitter in the global coordinates of the form [x, y, z].
  

  .. attribute:: dataset{s}.bsi.wireless.channels.rotation
  
    `Scene:` ``s`` - `Transmitter:` ``BS i``
  
    `Size: 1x3`
  
    The rotation angles applied to the transmitter. This value is determined based on the parameters :attr:`params.activate_array_rotation` and :attr:`params.array_rotation_BS`.
  
  .. attribute:: dataset{s}.bsi.wireless.channels.user{j}
  
    `Scene:` ``s`` - `Transmitter:` ``BS i`` - `Receiver:` ``UE j``
  
    The communication channel data structure. 
	
	.. note::
	
	  The ``j`` here represents the ``j``-th available UE of the communication. The number of available UEs and their order changes may change in each scene. 
	  For the actual ID of the transmitter, :attr:`dataset{s}.trajectory.objects{j}.id` can be accessed. This value does not change within the scenes, but varies for different dynamic objects.
    
	
	.. attribute:: dataset{s}.bsi.wireless.channels.user{j}.channel
  
		`Scene:` ``s`` - `Transmitter:` ``BS i`` - `Receiver:` ``UE j``
  
		The corresponding communication channel. The size of this matrix depends on the OFDM or CIR channel parameter :attr:`params.OFDM_channels`:
		
		* If the OFDM channels are generated, the size is ``RX ant x TX ant x OFDM subcarriers``.
		
		* If the CIR response are generated, the size is ``RX ant x TX ant x number of paths``, where the time of arrival of each path is presented in :attr:`dataset{s}.bsi.wireless.channels.user{j}.ToA` (which is only available in this case).
  
	.. attribute:: dataset{s}.bsi.wireless.channels.user{j}.rotation
  
		`Scene:` ``s`` - `Transmitter:` ``BS i`` - `Receiver:` ``UE j``
  
		The rotation angles applied to the receiver. This value is determined based on the parameters :attr:`params.activate_array_rotation` and :attr:`params.array_rotation_UE`.

	.. attribute:: dataset{s}.bsi.wireless.channels.user{j}.loc
  
		`Scene:` ``s`` - `Transmitter:` ``BS i`` - `Receiver:` ``UE j``
  
		The location of the receiver in the global coordinates of the form [x, y, z].

	.. attribute:: dataset{s}.bsi.wireless.channels.user{j}.LoS_status
  
		`Scene:` ``s`` - `Transmitter:` ``BS i`` - `Receiver:` ``UE j``
  
		Indicator integer for the line-of-sight status of the channel. It can take the following values:
		
		* ``-1`` No paths are available between the transmitter and receiver,
		
		* ``0`` Only non-line-of-sight paths are available between the transmitter and receiver,
		
		* ``1`` Line-of-sight path is available between the transmitter and receiver.
		
	.. attribute:: dataset{s}.bsi.wireless.channels.user{j}.distance
  
		`Scene:` ``s`` - `Transmitter:` ``BS i`` - `Receiver:` ``UE j``
  
		The distance value provided by the ray-tracing software.
		
		.. note::
		
			This may show inconsistencies compared to the distance computed from the transmitter and receiver locations. We recommend to use the latter.
		
	.. attribute:: dataset{s}.bsi.wireless.channels.user{j}.pathloss
  
		`Scene:` ``s`` - `Transmitter:` ``BS i`` - `Receiver:` ``UE j``
  
		The path loss (dB) value provided by the ray-tracing software.
	
		.. note::
		
			The ray-tracing data is generated with a single omni-directional antenna. For this reason, this path-loss value includes all the paths. 
			However, the DeepVerse generator only utilizes (and provides) the channel paths within the angles 0-180 degrees assuming an antenna panel.
		
	
	.. attribute:: dataset{s}.bsi.wireless.channels.user{j}.path_params
  
		`Scene:` ``s`` - `Transmitter:` ``BS i`` - `Receiver:` ``UE j``
  
		The raw channel path information provided by the ray-tracing software presented in a structure. It includes the following fields of the corresponding channel's paths:
	
		* ``DoD_phi`` Azimuth of departure - Array of ``1 x number of paths``
		
		* ``DoA_phi`` Azimuth of arrival - Array of ``1 x number of paths``
		
		* ``DoD_theta`` Elevation of departure - Array of ``1 x number of paths``
		
		* ``DoA_theta`` Elevation of arrival - Array of ``1 x number of paths``
	
		* ``phase`` Phase - Array of ``1 x number of paths``
	
		* ``ToA`` Time of arrival - Array of ``1 x number of paths``
		
		* ``power`` Power (Watts) - Array of ``1 x number of paths``
		
		* ``Doppler_vel`` Doppler velocity of the path - Array of ``1 x number of paths``
		
		* ``Doppler_acc`` Doppler acceleration of the path - Array of ``1 x number of paths``
		
		* ``num_paths`` Number of paths
		
		.. note::
		
			The ray-tracing data is generated with a single omni-directional antenna.
			The DeepVerse generator, however, only utilizes (and provides) the channel paths within the angles 0-180 degrees assuming an antenna panel.
		
		
  .. attribute:: dataset{s}.bsi.wireless.channels.basestation{j}
  
    `Scene:` ``s`` - `Transmitter:` ``BS i`` - `Receiver:` ``BS j``
  
    The communication channel data structure. The sub-fields of this structure are the same with the user channel structure given in :attr:`dataset{s}.bsi.wireless.channels.user{j}`.
 
Radar
=====
 
The radar data is activated with :attr:`dv.radar`. If this parameter is ``0``, the radar fields will not be available.

.. attribute:: dataset{s}.bsi.radar.parameters
  
  `Scene:` ``s`` - `Transmitter:` ``BS i``
  
  The radar data parameters used to generate the dataset can be found in this structure. 
  The structure contains all the parameters relevant to the radar data generation, including the radar parameters file and carrier frequency.
  This allows checking the details of the saved/loaded dataset.
  

.. attribute:: dataset{s}.bsi.radar.channels
  
  `Scene:` ``s`` - `Transmitter:` ``BS i``
  
  The radar data information structure.

  .. attribute:: dataset{s}.bsi.radar.channels.loc
  
    `Scene:` ``s`` - `Transmitter:` ``BS i``
  
    `Size: 1x3`
  
    The location of the transmitter in the global coordinates of the form [x, y, z].
  

  .. attribute:: dataset{s}.bsi.radar.channels.rotation
  
    `Scene:` ``s`` - `Transmitter:` ``BS i``
  
    `Size: 1x3`
  
    The rotation angles applied to the transmitter. This value is determined based on the parameters :attr:`params.activate_radar_array_rotation` and :attr:`params.array_rotation_TX`.
  
  .. attribute:: dataset{s}.bsi.radar.channels.basestation{j}
  
    `Scene:` ``s`` - `Transmitter:` ``BS i`` - `Receiver:` ``BS j``
  
    The communication channel data structure. 
	
	.. note::
	
	  The ``j`` here represents the ``j``-th active BS but not the ID of the basestation presented in the scenario.
	
	.. attribute:: dataset{s}.bsi.radar.channels.basestation{j}.IF_signal
  
		`Scene:` ``s`` - `Transmitter:` ``BS i`` - `Receiver:` ``BS j``
  
		The corresponding radar intermediate frequency (IF) data. The size of this matrix depends on the radar parameters and given as ``RX_ant x TX_ant x samples per chirp x num chirps``.
		
	.. attribute:: dataset{s}.bsi.radar.channels.basestation{j}.radar_KPI
  
		`Scene:` ``s`` - `Transmitter:` ``BS i`` - `Receiver:` ``BS j``
  
		The corresponding radar key performance indicators presented by the following fields:
		
		* ``range_resolution`` - Range resolution of the radar
		 
		* ``max_detectable_range`` - Maximum detectable range of the radar
		
		* ``velocity_resolution`` - Velocity resolution of the radar
		
		* ``max_detectable_velocity`` - Maximum detectable velocity of the radar
		
		* ``Radar_frame_rate`` - TBA..
		
	.. attribute:: dataset{s}.bsi.radar.channels.basestation{j}.rotation
  
		`Scene:` ``s`` - `Transmitter:` ``BS i`` - `Receiver:` ``BS j``
  
		The rotation angles applied to the receiver. This value is determined based on the parameters :attr:`params.activate_radar_array_rotation` and :attr:`params.array_rotation_RX`.

	.. attribute:: dataset{s}.bsi.radar.channels.basestation{j}.loc
  
		`Scene:` ``s`` - `Transmitter:` ``BS i`` - `Receiver:` ``BS j``
  
		The location of the receiver in the global coordinates of the form [x, y, z].

	.. attribute:: dataset{s}.bsi.radar.channels.basestation{j}.LoS_status
  
		`Scene:` ``s`` - `Transmitter:` ``BS i`` - `Receiver:` ``BS j``
  
		Indicator integer for the line-of-sight status of the channel. It can take the following values:
		
		* ``-1`` No paths are available between the transmitter and receiver,
		
		* ``0`` Only non-line-of-sight paths are available between the transmitter and receiver,
		
		* ``1`` Line-of-sight path is available between the transmitter and receiver.
		
	.. attribute:: dataset{s}.bsi.radar.channels.basestation{j}.distance
  
		`Scene:` ``s`` - `Transmitter:` ``BS i`` - `Receiver:` ``BS j``
  
		The distance value provided by the ray-tracing software.
		
		.. note::
		
			This may show inconsistencies compared to the distance computed from the transmitter and receiver locations. We recommend to use the latter.
		
	.. attribute:: dataset{s}.bsi.radar.channels.basestation{j}.pathloss
  
		`Scene:` ``s`` - `Transmitter:` ``BS i`` - `Receiver:` ``BS j``
  
		The path loss (dB) value provided by the ray-tracing software.
	
		.. note::
		
			The ray-tracing data is generated with a single omni-directional antenna. For this reason, this path-loss value includes all the paths. 
			However, the DeepVerse generator only utilizes (and provides) the channel paths within the angles 0-180 degrees assuming an antenna panel.
		
	
	.. attribute:: dataset{s}.bsi.radar.channels.basestation{j}.path_params
  
		`Scene:` ``s`` - `Transmitter:` ``BS i`` - `Receiver:` ``UE j``
  
		The raw channel path information provided by the ray-tracing software presented in a structure. It includes the following fields of the corresponding channel's paths:
	
		* ``DoD_phi`` Azimuth of departure - Array of ``1 x number of paths``
		
		* ``DoA_phi`` Azimuth of arrival - Array of ``1 x number of paths``
		
		* ``DoD_theta`` Elevation of departure - Array of ``1 x number of paths``
		
		* ``DoA_theta`` Elevation of arrival - Array of ``1 x number of paths``
	
		* ``phase`` Phase - Array of ``1 x number of paths``
	
		* ``ToA`` Time of arrival - Array of ``1 x number of paths``
		
		* ``power`` Power (Watts) - Array of ``1 x number of paths``
		
		* ``Doppler_vel`` Doppler velocity of the path - Array of ``1 x number of paths``
		
		* ``Doppler_acc`` Doppler acceleration of the path - Array of ``1 x number of paths``
		
		* ``num_paths`` Number of paths
		
		.. note::
		
			The ray-tracing data is generated with a single omni-directional antenna.
			The DeepVerse generator, however, only utilizes (and provides) the channel paths within the angles 0-180 degrees assuming an antenna panel.
		
Image
=====

The RGB camera image data is activated with :attr:`dv.camera`. If this parameter is ``0``, the image fields will not be available.

.. attribute:: dataset{s}.bsi.image
  
  `Scene:` ``s`` - `Cameras of:` ``BS i``
  
  The data structure of the cameras belonging to ``BS i``.
  

  .. attribute:: dataset{s}.bsi.image.camj
  
    `Scene:` ``s`` - `Camera:` ``BS i`` - ``Camera j``
  
    The path of the corresponding camera image (jpg, png, etc.) relative to the scenario folder.
	
	.. note:
	
		The scenario folder can also be obtained from the parameters as :attr:`dv.dataset_folder` + :attr:`dv.scenario`.

Lidar
=====

The lidar point cloud data (PCD) is activated with :attr:`dv.lidar`. If this parameter is ``0``, the lidar fields will not be available.

.. attribute:: dataset{s}.bsi.lidar
  
  `Scene:` ``s`` - `Lidar at:` ``BS i``
  
  The data structure of the lidar at the position of ``BS i``.
  

  .. attribute:: dataset{s}.bsi.lidar.data
  
    `Scene:` ``s`` - `Lidar at:` ``BS i``
  
    The path of the corresponding lidar point cloud data (.pcd) relative to the scenario folder.
	
	.. note:
	
		The scenario folder can also be obtained from the parameters as :attr:`dv.dataset_folder` + :attr:`dv.scenario`.


Position
========

The trajectory data is activated with :attr:`dv.position`. If this parameter is ``0``, the trajectory fields will not be available. 

.. note::

	The position data can also be obtained from the radar and communication structures. The trajectory data provides additional information related to the dynamic objects.

.. attribute:: dataset{s}.trajectory.time
  
  `Scene:` ``s``
  
  The time information of the scene ``s``.

.. attribute:: dataset{s}.trajectory.objects{j}
  
  `Scene:` ``s`` `Object:` ``j``
  
  The information of the dynamic object ``j``. 
  
  .. note::
	
	Each dynamic object carries a receiver, hence, the value ``j`` corresponds to the user channel ``j`` :attr:`dataset{s}.wireless.channels.bsi.users{j}`. 
	The order of these objects change within the scenes. 
	However, each dynamic object is given a static ID, which can be accessed by :attr:`dataset{s}.trajectory.objects{j}.id`. 
	
  The object structure contain the following fields:
	
  * ``id`` - The identity of the dynamic object. Each dynamic object (e.g., vehicle) is assigned with a single ID within the scenes. 
	
  * ``x`` - x-axis global location of the object.
  
  * ``y`` - y-axis global location of the object.
  
  * ``z`` - z-axis global location of the object (This defines the ground level of the object).

  * ``tx_height`` - z-axis global location of the object's receiver (e.g., top of the vehicle).
  
  * ``angle`` - Angle of the object (e.g., 180 or 0 defines the direction/rotation in x-axis).
  
  * ``type`` - Type of the dynamic object (e.g., bus, truck or various car types).
  
  * ``speed`` - Instantaneous speed of the object. This value is used to compute the Doppler velocity.
  
  * ``acceleration`` - Instantaneous acceleration of the object.  This value is used to compute the Doppler acceleration.
  
  * ``bounds`` - The bounding box of the object. This value is used to compute the Doppler velocity/acceleration by determining if a path has interacted within these limits.
  
  * ``direction`` - Direction of the velocity/acceleration.
  
  * ``slope`` - Slope of the object. Currently, only flat surface is supported, hence, this value is always ``0``.
  
  * ``lane`` - Lane/Road information from SUMO.
  
  * ``navigation`` - Navigation information from SUMO.
  
  * ``pos`` - TBA..
  
  