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

****
Data
****

The data can be accessed with :attr:`.scene` as follows.

.. attribute:: dataset.scene{s}
  
  `Scene:` ``s``
  
  The (scene) data sub-structure. The basestation and ue sensors are included in each of scene data structure.
  
  .. note::
  
	  The ``s`` here represents the ``s``-th generated scene, index by starting from `1`. This is not the index of the scene given in the scenario description.
		
Basestation
===========

.. attribute:: dataset.scene{s}.bs{i}
  
  `Scene:` ``s`` - `Sensor:` ``BS i``
  
  The sensor data structure of the basestation ``i``. It includes the sub-structures for different sensors of the basestation (communication, radar, image, lidar, position).
  
  .. note::
  
	  The ``i`` here represents the ``i``-th activated basestation, but not the index of the basestation given in the scenario description.
  
  
Communication
-------------

	The communication channel data is activated with :attr:`dv.communication`. If this parameter is ``0``, the communication fields will not be available.

	.. attribute:: dataset.scene{s}.bs{i}.comm.loc

		`Scene:` ``s`` - `Transmitter:` ``BS i``

		`Size: 1x3`

		The location of the transmitter in the global coordinates of the form [x, y, z].


	.. attribute:: dataset.scene{s}.bs{i}.comm.rotation

		`Scene:` ``s`` - `Transmitter:` ``BS i``

		`Size: 1x3`

		The rotation angles applied to the transmitter. This value is determined based on the parameters :attr:`comm.activate_array_rotation` and :attr:`comm.array_rotation_BS`.

	.. attribute:: dataset.scene{s}.bs{i}.comm.ue{j}

		`Scene:` ``s`` - `Transmitter:` ``BS i`` - `Receiver:` ``UE j``

		The communication channel data structure. 

		.. note::

			The ``j`` here represents the ``j``-th available UE of the communication. The number of available UEs and their order changes may change in each scene. 
			For the actual ID of the transmitter, :attr:`dataset.scene{s}.ue{j}.id` can be accessed. This value does not change within the scenes, but varies for different dynamic objects.


		.. attribute:: dataset.scene{s}.bs{i}.comm.ue{j}.channel

			`Scene:` ``s`` - `Transmitter:` ``BS i`` - `Receiver:` ``UE j``

			The corresponding communication channel. The size of this matrix depends on the OFDM or CIR channel parameter :attr:`comm.OFDM_channels`:
			
			* If the OFDM channels are generated, the size is ``RX ant x TX ant x OFDM subcarriers``.
			
			* If the CIR response are generated, the size is ``RX ant x TX ant x number of paths``, where the time of arrival of each path is presented in :attr:`dataset.scene{s}.bs{i}.comm.ue{j}.ToA` (which is only available in this case).

		.. attribute:: dataset.scene{s}.bs{i}.comm.ue{j}.loc

			`Scene:` ``s`` - `Transmitter:` ``BS i`` - `Receiver:` ``UE j``

			The location of the receiver in the global coordinates of the form [x, y, z].
			
		.. attribute:: dataset.scene{s}.bs{i}.comm.ue{j}.rotation

			`Scene:` ``s`` - `Transmitter:` ``BS i`` - `Receiver:` ``UE j``

			The rotation angles applied to the receiver. This value is determined based on the parameters :attr:`comm.activate_array_rotation` and :attr:`comm.array_rotation_UE`.

		.. attribute:: dataset.scene{s}.bs{i}.comm.ue{j}.LoS_status

			`Scene:` ``s`` - `Transmitter:` ``BS i`` - `Receiver:` ``UE j``

			Indicator integer for the line-of-sight status of the channel. It can take the following values:
			
			* ``-1`` No paths are available between the transmitter and receiver,
			
			* ``0`` Only non-line-of-sight paths are available between the transmitter and receiver,
			
			* ``1`` Line-of-sight path is available between the transmitter and receiver.
			
		.. attribute:: dataset.scene{s}.bs{i}.comm.ue{j}.distance

			`Scene:` ``s`` - `Transmitter:` ``BS i`` - `Receiver:` ``UE j``

			The distance value provided by the ray-tracing software.
			
			.. note::
			
				This may show inconsistencies compared to the distance computed from the transmitter and receiver locations. We recommend to use the latter.
			
		.. attribute:: dataset.scene{s}.bs{i}.comm.ue{j}.pathloss

			`Scene:` ``s`` - `Transmitter:` ``BS i`` - `Receiver:` ``UE j``

			The path loss (dB) value provided by the ray-tracing software.

			.. note::
			
				The ray-tracing data is generated with a single omni-directional antenna. For this reason, this path-loss value includes all the paths. 
				However, the DeepVerse generator only utilizes (and provides) the channel paths within the angles 0-180 degrees assuming an antenna panel.
			
		.. attribute:: dataset.scene{s}.bs{i}.comm.ue{j}.id
	 
			`Scene:` ``s`` - `Transmitter:` ``BS i`` - `Receiver:` ``UE j``

			The identity of the dynamic object. Each dynamic object (e.g., vehicle) is assigned with a single unique ID within the scenes.
			
		.. attribute:: dataset.scene{s}.bs{i}.comm.ue{j}.path_params

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
			
		
	.. attribute:: dataset.scene{s}.bs{i}.comm.bs{j}

		`Scene:` ``s`` - `Transmitter:` ``BS i`` - `Receiver:` ``BS j``

		The communication channel data structure. The sub-fields of this structure are the same with the user channel structure given in :attr:`dataset.scene{s}.bs{i}.comm.ue{j}`.

Radar
-----
	 
	The radar data is activated with :attr:`dv.radar`. If this parameter is ``0``, the radar fields will not be available.

	.. attribute:: dataset.scene{s}.bs{i}.radar.loc

		`Scene:` ``s`` - `Transmitter:` ``BS i``

		`Size: 1x3`

	The location of the transmitter in the global coordinates of the form [x, y, z].

	.. attribute:: dataset.scene{s}.bs{i}.radar.rotation

		`Scene:` ``s`` - `Transmitter:` ``BS i``

		`Size: 1x3`

	The rotation angles applied to the transmitter. This value is determined based on the parameters :attr:`radar.activate_array_rotation` and :attr:`radar.array_rotation_TX`.

	.. attribute:: dataset.scene{s}.bs{i}.radar.bs{j}

		`Scene:` ``s`` - `Transmitter:` ``BS i`` - `Receiver:` ``BS j``

		The radar signal data structure. 

		.. note::

			The ``j`` here represents the ``j``-th active BS but not the ID of the basestation presented in the scenario.


		.. attribute:: dataset.scene{s}.bs{i}.radar.bs{j}.IF_signal

			`Scene:` ``s`` - `Transmitter:` ``BS i`` - `Receiver:` ``BS j``

			The corresponding radar intermediate frequency (IF) data. The size of this matrix depends on the radar parameters and given as ``RX_ant x TX_ant x samples per chirp x num chirps``.
			
		.. attribute:: dataset.scene{s}.bs{i}.radar.bs{j}.radar_KPI

			`Scene:` ``s`` - `Transmitter:` ``BS i`` - `Receiver:` ``BS j``

			The corresponding radar key performance indicators presented by the following fields:
			
			* ``range_resolution`` - Range resolution of the radar
			 
			* ``max_detectable_range`` - Maximum detectable range of the radar
			
			* ``velocity_resolution`` - Velocity resolution of the radar
			
			* ``max_detectable_velocity`` - Maximum detectable velocity of the radar
			
			* ``Radar_frame_rate`` - TBA..
			
		.. attribute:: dataset.scene{s}.bs{i}.radar.bs{j}.rotation

			`Scene:` ``s`` - `Transmitter:` ``BS i`` - `Receiver:` ``BS j``

			The rotation angles applied to the receiver. This value is determined based on the parameters :attr:`radar.activate_array_rotation` and :attr:`radar.array_rotation_RX`.

		.. attribute:: dataset.scene{s}.bs{i}.radar.bs{j}.loc

			`Scene:` ``s`` - `Transmitter:` ``BS i`` - `Receiver:` ``BS j``

			The location of the receiver in the global coordinates of the form [x, y, z].

		.. attribute:: dataset.scene{s}.bs{i}.radar.bs{j}.LoS_status

			`Scene:` ``s`` - `Transmitter:` ``BS i`` - `Receiver:` ``BS j``

			Indicator integer for the line-of-sight status of the channel. It can take the following values:
			
			* ``-1`` No paths are available between the transmitter and receiver,
			
			* ``0`` Only non-line-of-sight paths are available between the transmitter and receiver,
			
			* ``1`` Line-of-sight path is available between the transmitter and receiver.
			
		.. attribute:: dataset.scene{s}.bs{i}.radar.bs{j}.distance

			`Scene:` ``s`` - `Transmitter:` ``BS i`` - `Receiver:` ``BS j``

			The distance value provided by the ray-tracing software.
			
			.. note::
			
				This may show inconsistencies compared to the distance computed from the transmitter and receiver locations. We recommend to use the latter.
			
		.. attribute:: dataset.scene{s}.bs{i}.radar.bs{j}.pathloss

			`Scene:` ``s`` - `Transmitter:` ``BS i`` - `Receiver:` ``BS j``

			The path loss (dB) value provided by the ray-tracing software.

			.. note::
			
				The ray-tracing data is generated with a single omni-directional antenna. For this reason, this path-loss value includes all the paths. 
				However, the DeepVerse generator only utilizes (and provides) the channel paths within the angles 0-180 degrees assuming an antenna panel.
			

		.. attribute:: dataset.scene{s}.bs{i}.radar.bs{j}.path_params

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
-----

	The RGB camera image data is activated with :attr:`dv.camera`. If this parameter is ``0``, the image fields will not be available.

	.. attribute:: dataset.scene{s}.bsi.cam{j}

		`Scene:` ``s`` - `Sensor:` ``BS i`` - ``Camera j``

		The path of the corresponding camera image (jpg, png, etc.) relative to the scenario folder.

		.. note:

			The scenario folder can also be obtained from :attr:`dataset.info.scenario_folder`.

Lidar
-----

	The lidar point cloud data (PCD) is activated with :attr:`dv.lidar`. If this parameter is ``0``, the lidar fields will not be available.

	.. attribute:: dataset.scene{s}.bs{i}.lidar{j}
		
		`Scene:` ``s`` - `Sensor:` ``BS i`` - ``Lidar j``
		
		The path of the corresponding lidar point cloud data (.pcd) relative to the scenario folder.
		
		.. note:
		
			The scenario folder can also be obtained from :attr:`dataset.info.scenario_folder`.


Location
--------

	The location data is activated with :attr:`dv.position`. If this parameter is ``0``, the trajectory fields will not be available. 

	.. attribute:: dataset.scene{s}.bs{i}.location

		`Scene:` ``s`` - `Sensor:` ``BS i``

		The location of the basestation in the form of [x, y, z] (in the global coordinates).


User Equipment
==============

.. attribute:: dataset.scene{s}.ue{i}
  
  `Scene:` ``s`` - `Sensor:` ``UE i``
  
	The sensor data structure of the UE ``i``. It includes the sub-structures for the sensors of the UE (position, mobility).
  
Location
--------

	The location data is activated with :attr:`dv.position`. If this parameter is ``0``, the location field will not be available. 

	.. attribute:: dataset.scene{s}.ue{i}.location

		`Scene:` ``s`` - `Sensor:` ``UE i``

		The location of the user in the form of [x, y, z] (in the global coordinates).
		
	
  
Mobility
--------

	The mobility data is activated with :attr:`dv.position`. If this parameter is ``0``, the mobility field will not be available. 


	.. attribute:: dataset.scene{s}.ue{i}.mobility

		`Scene:` ``s`` - `Sensor:` ``UE i``

		The information of the user ``j``. 
  
		.. note::
		
			Each user carries a receiver, hence, the value ``j`` corresponds to the user channel ``j`` :attr:`dataset.scene{s}.bs{i}.comm.ue{j}`. 
			The order of these objects change within the scenes. 
			However, each user object is given a static ID, which can be accessed by :attr:`dataset.scene{s}.ue{j}.id`. 
			
			The object structure contain the following fields:
			
			* ``id`` - The identity of the dynamic object. Each dynamic object (e.g., vehicle) is assigned with a single ID within the scenes. 

			* ``z`` - z-axis global ground location of the object.

			* ``angle`` - Angle of the object (e.g., 180 or 0 defines the direction/rotation in x-axis).
			
			* ``type`` - Type of the dynamic object (e.g., bus, truck or various car types).
			
			* ``speed`` - Instantaneous speed of the object. This value is used to compute the Doppler velocity.
			
			* ``acceleration`` - Instantaneous acceleration of the object.  This value is used to compute the Doppler acceleration.
			
			* ``bounds`` - The bounding box of the object. This value is used to compute the Doppler velocity/acceleration by determining if a path has interacted within these limits.
			
			* ``direction`` - Direction of the velocity/acceleration.
			
			* ``slope`` - Slope of the object. Currently, only flat surface is supported, hence, this value is always ``0``.
			
			* ``lane`` - Lane/Road information from SUMO.
			
			* ``navigation`` - Navigation information from SUMO.
  
Identity
--------
		
	The identity data is activated with :attr:`dv.position`. If this parameter is ``0``, the id fields will not be available. 
		
	.. attribute:: dataset.scene{s}.ue{i}.id

		`Scene:` ``s`` - `Sensor:` ``UE i``

		Each dynamic object that enters to the environment within the scenes is given a fixed ID presented with this command.
		

***********
Information
***********

The scene independent general information about the dataset is provided in this sub-structure.

The data can be accessed with :attr:`.scene` as follows.

.. attribute:: dataset.info
  
  The information sub-structure.
	
	.. attribute:: dataset.info.scenario_folder
		
		The folder of the scenario data.
		
	.. attribute:: dataset.info.mobility
		
		The mobility information of the different types of objects (e.g., vehicles). The corresponding type of different users are provided in :attr:`dataset.scene{s}.ue{i}.mobility.type`.
		
	.. attribute:: dataset.info.comm
		
		The information for the communication data. The radar parameters of the generation are included in this structure.
		
	.. attribute:: dataset.info.radar
		
		The information for the radar data. The radar parameters of the generation are included in this structure.