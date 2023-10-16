# Configuration file for the Sphinx documentation builder.
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Project information -----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information

import os
import sphinx_rtd_theme, sphinx_bootstrap_theme

project = 'DeepVerse 6G'
copyright = '2023, Umut Demirhan, Abdelrahman Taha, Shuaifeng Jiang, Ahmed Alkhateeb'
author = 'Umut Demirhan, Abdelrahman Taha, Shuaifeng Jiang, Ahmed Alkhateeb'
release = '0.1'

# -- General configuration ---------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration

extensions = ['sphinx_rtd_theme', 
              'sphinxcontrib.matlab', 
              'sphinx.ext.autodoc', 
              'sphinx.ext.viewcode', 
              'sphinx.ext.autosummary']


autosummary_generate = True
templates_path = ['_templates']
exclude_patterns = ['_build', 'Thumbs.db', '.DS_Store']

primary_domain = 'mat'

matlab_src_dir = os.path.abspath('../../')

# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output

html_theme = 'sphinx_rtd_theme'
html_theme_path = ["_themes", ]

# html_theme = 'bootstrap'
# html_theme_path = sphinx_bootstrap_theme.get_html_theme_path()
html_show_sourcelink = False

html_static_path = ['_static']

pygments_style = 'staroffice'

html_theme_options = {
    "navigation_depth": 4
}

html_css_files = [
    'custom.css',
]

rst_prolog = """
.. |dataset_folder| replace:: './scenarios/'
.. |scenario| replace:: 'Scenario 1'
.. |basestations| replace:: [1, 2, 3, 4]
.. |scenes| replace:: [1:2000]
.. |wireless| replace:: 1
.. |wireless_parameters| replace:: 'wireless_params.m'
.. |radar| replace:: 0
.. |radar_parameters| replace:: 'radar_params.m'
.. |camera| replace:: 1
.. |camera_id| replace:: [1, 2, 3]
.. |lidar| replace:: 1
.. |position| replace:: 1

.. |num_ant_BS| replace:: [32, 1]
.. |num_ant_UE| replace:: [1, 1]
.. |array_rotation_BS| replace:: [0, 0, 0]
.. |array_rotation_UE| replace:: [0, 0, 0]
.. |ant_FoV_BS| replace:: [180, 180]
.. |ant_FoV_UE| replace:: [360, 180]
.. |ant_spacing_BS| replace:: 0.5
.. |ant_spacing_UE| replace:: 0.5
.. |bandwidth| replace:: 0.05
.. |activate_RX_filter| replace:: 0
.. |generate_OFDM_channels| replace:: 1
.. |num_paths| replace:: 25
.. |num_OFDM| replace:: 512
.. |OFDM_sampling| replace:: [1]
.. |enable_Doppler| replace:: 1


.. |num_ant_TX| replace:: [1, 1]
.. |num_ant_RX| replace:: [16, 1]
.. |array_rotation_TX| replace:: [0, 0, 0]
.. |array_rotation_RX| replace:: [0, 0, 0]
.. |ant_FoV_TX| replace:: [180, 180]
.. |ant_FoV_RX| replace:: [180, 180]
.. |ant_spacing_TX| replace:: 0.5
.. |ant_spacing_RX| replace:: 0.5
.. |num_paths_radar| replace:: 1000
.. |S| replace:: 15e12
.. |Fs| replace:: 15e6
.. |N_samples| replace:: 512
.. |N_chirp| replace:: 128
.. |comp_speed| replace:: 5
"""