^^^^^^^^^^^^^^^^^^^
General Parameters
^^^^^^^^^^^^^^^^^^^

The general dataset parameters are defined in :mod:`dv_params.m` file. 
These parameters are listed in detail as follows.


.. attribute:: dv.dataset_folder
  
  `Default:` |dataset_folder|
  
  The path of the extracted scenario folders. For example, if you have a folder named ``DeepVerse_Scenarios`` on the windows desktop, you may set
  ``dv.dataset_folder = 'C:\Users\username\Desktop\DeepVerse_Scenarios'``. This folder needs to contain the scenario folders extracted from the downloaded scenario zip files.

Scenario Settings
=================

.. attribute:: dv.scenario
  
  `Default:` |scenario|
  
  The name of the scenario to be utilized in the dataset. The scenario folder name must be the same as the name given here.

.. attribute:: dv.basestations
  
  `Default:` |basestations|
  
  The ID of the basestations to be included in the dataset. The basestation IDs can be selected from the scenario description.
  
  .. note:: 
  
	In the final dataset, the activated basestations IDs are renumbered in the same order starting from 1 to the number of active basestations.

.. attribute:: dv.scenes
  
  `Default:` |scenes|
  
  Determines the range of the scenes (time-steps) to be loaded in the final dataset. 
  
  .. note::
  
	The number of available scenes and the duration consecutive scenes can be found in the corresponding scenario page.

Sensors
=======

Wireless
--------

.. attribute:: dv.wireless
  
  `Default:` |wireless|
  
  The indicator for generating the wireless samples in the final dataset. 
  
  * ``1`` generates the wireless channels and includes it in the final dataset.
  * ``0`` does not include the wireless channels in the final dataset.
  
.. attribute:: dv.wireless_parameters
  
  `Default:` |wireless_parameters|
  
  Name of the parameters file containing the wireless parameters. It is not utilized if the wireless channels are not activated with :attr:`dv.wireless`.
  
Radar
-----

.. attribute:: dv.radar
  
  `Default:` |radar|
  
  The indicator for generating the FMCW radar samples in the final dataset. 
  
  * ``1`` generates the wireless channels and includes it in the final dataset.
  * ``0`` does not include the wireless channels in the final dataset.
  
.. attribute:: dv.radar_parameters
  
  `Default:` |radar_parameters|
  
  Name of the parameters file containing the radar parameters. It is not utilized if the radar channels are not activated with :attr:`dv.radar`.
  
Camera
------

.. attribute:: dv.camera
  
  `Default:` |camera|
  
  The indicator for generating the RGB camera images in the final dataset. 
  
  * ``1`` includes the RGB camera images in the final dataset.
  * ``0`` does not include the RGB camera images in the final dataset.
  
.. attribute:: dv.camera_id
  
  `Default:` |camera_id|
  
  The IDs of the cameras to be included in the dataset. The camera IDs can be selected from the scenario description.
    
  .. note:: 
  
	  In the final dataset, the activated cameras IDs are renumbered in the same order starting from 1 to the number of active cameras.

Lidar
-----

.. attribute:: dv.lidar
  
  `Default:` |lidar|
  
  The indicator for including the lidar point cloud data files in the final dataset. 
  
  * ``1`` includes the lidar point cloud data in the final dataset.
  * ``0`` does not include the lidar point cloud data in the final dataset.
  
Position
--------

.. attribute:: dv.position
  
  `Default:` |position|
  
  The indicator for generating the position and trajectory information in the final dataset. 
  
  * ``1`` includes the position in the final dataset.
  * ``0`` does not include the position data in the final dataset.
  

..
	---------------------------------------------------------------------------