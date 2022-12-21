# Configuration file for the Sphinx documentation builder.
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Project information -----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information

import os
import sphinx_rtd_theme, sphinx_bootstrap_theme

project = 'DeepVerse 6G'
copyright = '2022, Umut Demirhan, Abdelrahman Taha, Ahmed Alkhateeb'
author = 'Umut Demirhan, Abdelrahman Taha, Ahmed Alkhateeb'
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

html_static_path = ['_static']

pygments_style = 'staroffice'

html_theme_options = {
    "navigation_depth": 4
}

html_css_files = [
    'css/custom.css',
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

.. |num_ant_BS| replace:: [32, 1, 1]
.. |num_ant_UE| replace:: [1, 1, 1]
.. |activate_array_rotation| replace:: 0
.. |array_rotation_BS| replace:: [5, 10, 20]
.. |array_rotation_UE| replace:: [0, 30, 0]
.. |ant_spacing_BS| replace:: 0.5
.. |ant_spacing_UE| replace:: 0.5
.. |radiation_pattern| replace:: 0
.. |bandwidth| replace:: 0.05
.. |activate_RX_filter| replace:: 0
.. |generate_OFDM_channels| replace:: 1
.. |num_paths| replace:: 25
.. |num_OFDM| replace:: 512
.. |OFDM_sampling_factor| replace:: 1
.. |OFDM_limit| replace:: 1

.. |num_ant_TX| replace:: [1, 1, 1]
.. |num_ant_RX| replace:: [16, 1, 1]
.. |activate_radar_array_rotation| replace:: 0
.. |array_rotation_TX| replace:: [5, 10, 20]
.. |array_rotation_RX| replace:: [5, 10, 20]
.. |ant_spacing_TX| replace:: 0.5
.. |ant_spacing_RX| replace:: 0.5
.. |radar_channel_taps| replace:: 1000
.. |S| replace:: 15e12
.. |Fs| replace:: 15e6
.. |N_ADC| replace:: 512
.. |N_loop| replace:: 128
.. |T_idle| replace:: 7e-6
.. |T_start| replace:: 4.22e-6
.. |T_excess| replace:: 1e-6
.. |duty_cycle| replace:: 1
.. |comp_speed| replace:: 5
"""